# OTP xác minh đăng ký

Đăng ký bằng biểu mẫu gồm hai bước: nhập thông tin → nhận OTP qua email → xác minh và tạo tài khoản. Trước khi OTP đúng, không có tài khoản mới trong bảng users và không thể đăng nhập bằng thông tin đang chờ. Mật khẩu chỉ lưu dạng băm trong phiên chờ. Mã OTP cũng chỉ lưu dạng băm trong database.

Google vẫn dùng Firebase xác minh, không gửi thêm OTP.

## Bật gửi thư

Mở `.env` trong thư mục gốc FishShop, điền:

```dotenv
FISHSHOP_GMAIL_ADDRESS=gmail-gui-thu@gmail.com
FISHSHOP_GMAIL_APP_PASSWORD=
```

Dùng Gmail gửi thư của cửa hàng, không phải email người nhận. Bật xác minh 2 bước cho Gmail đó, tạo App Password tại https://myaccount.google.com/apppasswords rồi điền giá trị thật vào biến còn trống. Không dùng mật khẩu Gmail thường. `config/mail.php` tự đọc `.env`. File `.env` bị Git bỏ qua: máy khác phải chép file riêng hoặc tự điền lại; import SQL không mang theo cấu hình Gmail.

Nếu hiện “Đăng ký qua email chưa sẵn sàng gửi mã OTP”, chạy lệnh sau trên chính máy bị lỗi. Lệnh không gửi thư và không in mật khẩu:

```powershell
C:\xampp\php\php.exe C:\xampp\htdocs\FishShop\database\check_setup.php
```

Các dòng `[THIEU]` chỉ rõ cấu hình/extension/bảng còn thiếu. Thông báo trên trang đăng ký hiện tại chỉ phản ánh Gmail, App Password hoặc cURL chưa đủ; nó không chứng minh import SQL lỗi.

## Log lỗi OTP

Log dùng PHP `error_log`, tìm các dòng bắt đầu bằng `[FishShop OTP]`. Máy XAMPP hiện tại ghi tại `C:\xampp\php\logs\php_error_log`; `check_setup.php` in ra đúng đường dẫn cấu hình trên máy đang chạy. Nếu đường dẫn trống, xem Apache error log. Không có Gmail cụ thể, App Password, mã OTP hoặc token trong log.

- `configuration_unavailable`: tên biến/extension còn thiếu, ví dụ `FISHSHOP_GMAIL_APP_PASSWORD_MISSING`, `PHP_CURL_EXTENSION_MISSING` hoặc `CURL_CA_FILE_MISSING`.
- `smtp_send_failed`: mã lỗi cURL và SMTP, phân biệt không kết nối được, DNS, timeout, chứng chỉ TLS hoặc Gmail từ chối App Password.
- `operation_failed`: lỗi xử lý đăng ký/database, có mã driver (1146: thiếu bảng; 1054: thiếu cột), không ghi SQL hoặc dữ liệu cá nhân.

Mở lại trang đăng ký trên máy bị lỗi rồi xem cuối file log. Chỉ cần gửi các dòng `[FishShop OTP]` liên quan, không gửi nội dung `.env`.

Gmail App Password: https://support.google.com/accounts/answer/185833 . Một số tài khoản tổ chức/Advanced Protection không cho tạo App Password.

PHP cần cURL, kết nối Internet đến smtp.gmail.com:465 và CA hợp lệ. Không tắt xác minh TLS. Thư được gửi bằng SMTP qua TLS, không cần cài Google Authenticator hay Composer.

Khi chưa cấu hình gửi thư, trang đăng ký thông báo rõ và nút đăng ký bằng email tạm tắt. Nút Google vẫn hoạt động.

## Database và giới hạn

Nhập `database/RegistrationOtp.sql` vào WebBanCa. File tạo hai bảng mới, không thay đổi tài khoản cũ và có thể chạy lại.

- OTP 6 số có hiệu lực 5 phút, dùng một lần, gắn với trình duyệt yêu cầu.
- Sai 5 lần cần xin mã mới. Mã mới vô hiệu mã trước đó.
- Mỗi email tối đa 5 lần gửi mỗi giờ, cách nhau ít nhất 60 giây; mỗi IP tối đa 20 lần gửi mỗi giờ.
- Có nút gửi lại, sửa email/thông tin và quay về đăng nhập.
- Sau khi sửa thông tin phải nhập lại mật khẩu.
- Nếu tên đăng nhập/email đã được người khác dùng trong lúc chờ OTP, bước tạo tài khoản sẽ từ chối, không ghi đè.

## Kiểm thử

`C:\xampp\php\php.exe database\verify_registration_otp.php` tạo database thử độc lập, sao chép cấu trúc users/customer_ranks (không sao chép dữ liệu), kiểm tra luồng OTP bằng bộ gửi thư giả rồi xóa database thử. Không gửi thư thật trong kiểm thử này.

Sau khi điền cấu hình, đăng ký bằng email bạn kiểm soát, kiểm tra nhận mã, nhập sai, gửi lại và nhập đúng. Chưa có Gmail/App Password thì không thể kiểm thử gửi thư thật.
