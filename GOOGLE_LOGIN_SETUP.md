# Đăng nhập Google qua Firebase

FishShop dùng Firebase Authentication của dự án `fishshop-de2f9`. Cấu hình Web được lưu trong `.env` và đọc qua `config/firebase.php`. Nút Google trên trang đăng nhập/đăng ký dùng nhóm `FISHSHOP_FIREBASE_*`.

## Cấu hình trong .env

Lấy Web config tại Firebase Console → Project settings → General → Your apps → ứng dụng Web. Điền các biến sau trong `.env` ở thư mục gốc FishShop (máy hiện tại đã được điền bằng cấu hình dự án đang dùng):

```dotenv
FISHSHOP_FIREBASE_API_KEY=
FISHSHOP_FIREBASE_AUTH_DOMAIN=
FISHSHOP_FIREBASE_PROJECT_ID=
FISHSHOP_FIREBASE_STORAGE_BUCKET=
FISHSHOP_FIREBASE_MESSAGING_SENDER_ID=
FISHSHOP_FIREBASE_APP_ID=
FISHSHOP_FIREBASE_MEASUREMENT_ID=
```

Chúng lần lượt tương ứng với `apiKey`, `authDomain`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`, `measurementId` trong Firebase Web config. `measurementId` có thể để trống vì đăng nhập không bật Analytics. Các giá trị Web công khai vẫn được gửi tới Firebase SDK trên trình duyệt để đăng nhập hoạt động; service-account private key không được dùng ở đây.

Nhóm `FISHSHOP_GOOGLE_CLIENT_ID`, `FISHSHOP_GOOGLE_CLIENT_SECRET`, `FISHSHOP_GOOGLE_REDIRECT_URI` dành cho luồng Google OAuth trực tiếp cũ (`google_login.php`/`google_callback.php`), có thể để trống hai giá trị Client ID/Secret khi dùng Firebase. Hai nhóm biến đều được liệt kê trong `.env.example` để phân biệt. `.env.example` là mẫu trống; `.env` chứa cấu hình thật và đã bị Git bỏ qua.

## Trạng thái tích hợp

- Nút Google trên trang đăng nhập mở cửa sổ chọn tài khoản bằng Firebase SDK.
- Trang đăng ký có nút Google, tạo tài khoản customer và hồ sơ hạng nếu chưa có.
- PHP gửi chính ID token đến Firebase `accounts:lookup` qua HTTPS để xác minh, đồng thời kiểm tra project, issuer, thời hạn, lần xác thực gần nhất, Google provider và UID tương ứng. Chỉ sau khi xác minh thành công mới tạo phiên PHP.
- Đăng nhập Google lần đầu tự tạo tài khoản customer nếu email chưa tồn tại, kể cả email trường học/công ty hoặc địa chỉ ngoài Gmail. Những lần sau nhận diện bằng Google provider ID. Gmail/Googlemail trùng tài khoản cũ được liên kết; email ngoài Google trùng tài khoản cũ cần đăng nhập bằng mật khẩu, không tự liên kết chỉ dựa vào email. Tài khoản khóa luôn bị từ chối.
- Firebase chỉ giữ trạng thái trên bộ nhớ trang trong quá trình xác thực; phiên đăng nhập chính của website vẫn là phiên PHP.
- Không bật Analytics vì chức năng đăng nhập chỉ cần Firebase App và Auth.

## Cấu hình Firebase Console

1. Mở https://console.firebase.google.com/project/fishshop-de2f9/authentication/providers . Trong Authentication / Sign-in method, bật **Google**, chọn email hỗ trợ và lưu.
2. Authentication / Settings / Authorized domains cần có `localhost`. Đã kiểm tra API cấu hình công khai: dự án hiện có localhost. Nếu truy cập bằng `127.0.0.1` hoặc tên miền khác, thêm tên miền đó (không kèm đường dẫn hoặc port).
3. Khi lên hosting thật, thêm tên miền thật và dùng HTTPS.
4. Google Cloud có thể yêu cầu thêm người dùng thử nếu OAuth consent screen đang ở chế độ Testing.

## Database và PHP

Bảng `login_google_accounts` đã được tạo trên WebBanCa ở máy hiện tại. Khi chuyển máy, nhập `database/FirebaseLogin.sql` sau database chính. Migration chỉ tạo bảng còn thiếu và không xóa tài khoản cũ.

PHP cần cURL và chứng chỉ CA hợp lệ; giữ xác minh TLS bật. Máy hiện tại đã kiểm tra kết nối Firebase HTTPS thành công. Không cần Composer hoặc Node để chạy: trình duyệt tải Firebase SDK phiên bản cố định từ CDN Google.

## Kiểm thử

Nếu máy Windows khác trả `firebase_login.php 503`, trên chính máy đó chạy:

```powershell
C:\xampp\php\php.exe C:\xampp\htdocs\FishShop\database\check_google_login.php
```

Lệnh kiểm tra `.env`, cURL/HTTPS, file CA, khả năng gọi Firebase và các bảng/cột dùng khi đăng nhập. Nó gửi một token giả cố định để Firebase từ chối, không đăng nhập tài khoản thật, không thay đổi database và không in API key/token. Các dòng `[LOI]` chỉ ra lỗi kết nối, chứng chỉ, API key bị hạn chế hoặc schema thiếu.

Lỗi `503` từ PHP có mã hỗ trợ, tương ứng dòng `[FishShop Firebase] login_failed` trong PHP log (`C:\xampp\php\logs\php_error_log` ở máy hiện tại). Log ghi bước lỗi, mã cURL/HTTP/database và tên cấu hình thiếu; không ghi ID token, email, API key, SQL hay thông báo exception gốc.

Cảnh báo `Cross-Origin-Opener-Policy ... window.closed` liên quan popup. Nếu trình duyệt đã gửi POST đến `firebase_login.php` và PHP trả `503`, phải xem lỗi PHP riêng; chỉ đổi chính sách popup không giải quyết lỗi backend. Không tắt kiểm tra token, TLS hay CORS để bỏ qua lỗi. Máy hiện tại không đặt COOP nghiêm ngặt trên trang đăng nhập.

- `C:\xampp\php\php.exe database\verify_firebase.php`: kiểm tra dữ liệu token và định danh.
- Thêm `--remote`: gửi token giả tới Firebase để xác nhận bị từ chối.
- `C:\xampp\php\php.exe database\verify_firebase.php 3306 --remote`: tạo database thử có tên ngẫu nhiên, kiểm tra đăng ký, liên kết, quyền customer và tài khoản khóa, rồi xóa database thử; không sửa dữ liệu tài khoản thật.
- Đã qua 26 kiểm tra và HTTP smoke test trên XAMPP (trang đăng nhập/đăng ký, chặn GET và CSRF sai).
- Đăng nhập thành công bằng tài khoản Google thật vẫn cần người dùng chọn tài khoản trong popup. Nếu Google chưa bật hoặc tên miền không hợp lệ, thông báo tương ứng sẽ hiện dưới nút.

Tài liệu:
- https://firebase.google.com/docs/auth/web/google-signin
- https://firebase.google.com/docs/reference/rest/auth
- https://firebase.google.com/docs/auth/admin/verify-id-tokens

