# Đăng nhập Google qua Firebase

FishShop dùng Firebase Authentication của dự án `fishshop-de2f9`. Cấu hình Web nằm trong `config/firebase.php`. Không cần điền Google Client Secret trong `config/google.php` cho luồng Firebase này và không cần service-account private key.

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

- `C:\xampp\php\php.exe database\verify_firebase.php`: kiểm tra dữ liệu token và định danh.
- Thêm `--remote`: gửi token giả tới Firebase để xác nhận bị từ chối.
- `C:\xampp\php\php.exe database\verify_firebase.php 3306 --remote`: tạo database thử có tên ngẫu nhiên, kiểm tra đăng ký, liên kết, quyền customer và tài khoản khóa, rồi xóa database thử; không sửa dữ liệu tài khoản thật.
- Đã qua 26 kiểm tra và HTTP smoke test trên XAMPP (trang đăng nhập/đăng ký, chặn GET và CSRF sai).
- Đăng nhập thành công bằng tài khoản Google thật vẫn cần người dùng chọn tài khoản trong popup. Nếu Google chưa bật hoặc tên miền không hợp lệ, thông báo tương ứng sẽ hiện dưới nút.

Tài liệu:
- https://firebase.google.com/docs/auth/web/google-signin
- https://firebase.google.com/docs/reference/rest/auth
- https://firebase.google.com/docs/auth/admin/verify-id-tokens

