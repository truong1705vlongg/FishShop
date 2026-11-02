(() => {
  const form = document.querySelector('[data-firebase-login]');
  if (!form) return;
  const button = form.querySelector('button');
  const status = document.getElementById('firebase-status');
  const retry = document.getElementById('firebase-retry');
  const configElement = document.getElementById('firebase-config');
  if (!button || !status || !retry || !configElement) return;
  let phase = 'loading';
  let ready;
  let initializationError = '';
  let inFlight = false;
  let initializationTimer;
  button.disabled = true;
  form.setAttribute('aria-busy', 'true');
  retry.addEventListener('click', () => window.location.reload());

  function failInitialization(code) {
    if (phase !== 'loading') return;
    window.clearTimeout(initializationTimer);
    phase = 'error';
    button.disabled = true;
    form.removeAttribute('aria-busy');
    const configurationError = ['config/missing', 'config/invalid-json', 'auth/invalid-api-key', 'auth/invalid-auth-domain'].includes(code);
    initializationError = configurationError
      ? 'Đăng nhập Google chưa có cấu hình hợp lệ trên máy chủ. Bạn có thể dùng mật khẩu.'
      : 'Không tải được bộ đăng nhập Google. Kiểm tra kết nối mạng rồi bấm tải lại trang.';
    status.textContent = initializationError;
    retry.hidden = false;
    retry.classList.remove('hidden');
    // Only a non-sensitive error code is logged, never the Firebase config or tokens.
    console.warn('[FishShop Google] initialize_failed', {code: code || 'sdk/load-failed'});
  }

  function initialize() {
    let config;
    try { config = JSON.parse(configElement.textContent); }
    catch { failInitialization('config/invalid-json'); return; }
    if (!config || ['apiKey', 'authDomain', 'projectId'].some(key => typeof config[key] !== 'string' || !config[key].trim())) {
      failInitialization('config/missing');
      return;
    }
    status.textContent = 'Đang chuẩn bị đăng nhập Google…';
    initializationTimer = window.setTimeout(() => failInitialization('sdk/load-timeout'), 15000);
    Promise.all([
      import('../vendor/firebase/13.1.0/firebase-app.js'),
      import('../vendor/firebase/13.1.0/firebase-auth.js')
    ]).then(async ([appSdk, authSdk]) => {
      const app = appSdk.getApps().length ? appSdk.getApp() : appSdk.initializeApp(config);
      const auth = authSdk.getAuth(app);
      await authSdk.setPersistence(auth, authSdk.inMemoryPersistence);
      const provider = new authSdk.GoogleAuthProvider();
      provider.setCustomParameters({prompt: 'select_account'});
      return {auth, authSdk, provider};
    }).then(value => {
      if (phase !== 'loading') return;
      window.clearTimeout(initializationTimer);
      ready = value;
      phase = 'ready';
      button.disabled = false;
      form.removeAttribute('aria-busy');
      status.textContent = '';
    }).catch(error => failInitialization(error.code || 'sdk/load-failed'));
  }

  form.addEventListener('submit', async event => {
    event.preventDefault();
    if (inFlight) return;
    if (phase !== 'ready') {
      status.textContent = phase === 'error' ? initializationError : 'Đang chuẩn bị đăng nhập Google…';
      return;
    }
    inFlight = true;
    button.disabled = true;
    form.setAttribute('aria-busy', 'true');
    status.textContent = 'Đang mở cửa sổ chọn tài khoản Google…';
    try {
      // Called directly during the click to avoid popup blocking.
      const result = await ready.authSdk.signInWithPopup(ready.auth, ready.provider);
      status.textContent = 'Đang xác minh tài khoản…';
      const body = new FormData(form);
      // signInWithPopup already returns a fresh user. Avoid forcing a second
      // token refresh request before sending it to the PHP verifier.
      body.set('id_token', await result.user.getIdToken());
      const controller = new AbortController();
      const responseTimer = window.setTimeout(() => controller.abort(), 35000);
      let response;
      try {
        response = await fetch(form.action, { method: 'POST', body, credentials: 'same-origin', headers: { Accept: 'application/json' }, signal: controller.signal });
      } finally { window.clearTimeout(responseTimer); }
      let data;
      try { data = await response.json(); } catch { throw new Error('Máy chủ chưa sẵn sàng. Vui lòng kiểm tra MySQL và thử lại.'); }
      if (!response.ok || !data.ok) throw new Error(data.message || 'Không thể đăng nhập.');
      await ready.authSdk.signOut(ready.auth).catch(() => {});
      window.location.assign(data.redirect);
    } catch (error) {
      const messages = {
        'auth/popup-closed-by-user': 'Bạn đã đóng cửa sổ Google. Bấm nút để thử lại.',
        'auth/cancelled-popup-request': 'Yêu cầu trước đã bị hủy. Vui lòng thử lại.',
        'auth/popup-blocked': 'Trình duyệt chặn cửa sổ Google. Hãy cho phép cửa sổ bật lên rồi thử lại.',
        'auth/unauthorized-domain': 'Tên miền này chưa được cho phép trong Firebase Authentication.',
        'auth/operation-not-allowed': 'Chưa bật Google trong Firebase Authentication.',
        'auth/network-request-failed': 'Không kết nối được Firebase. Hãy kiểm tra Internet.',
        'auth/account-exists-with-different-credential': 'Email này đã dùng phương thức đăng nhập khác.',
        'auth/invalid-api-key': 'Cấu hình Firebase API key không hợp lệ.'
      };
      status.textContent = error.name === 'AbortError' ? 'Máy chủ phản hồi chậm. Vui lòng thử lại hoặc dùng mật khẩu.' : (messages[error.code] || (error.code ? 'Không thể đăng nhập Google. Vui lòng thử lại.' : error.message));
      await ready.authSdk.signOut(ready.auth).catch(() => {});
    } finally {
      button.disabled = false;
      inFlight = false;
      form.removeAttribute('aria-busy');
    }
  });
  initialize();
})();
