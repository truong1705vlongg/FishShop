# OTP xác minh đăng ký

Đăng ký bằng biểu mẫu gồm hai bước: nhập thông tin → nhận OTP qua email → xác minh và tạo tài khoản. Trước khi OTP đúng, không có tài khoản mới trong bảng users và không thể đăng nhập bằng thông tin đang chờ. Mật khẩu và câu trả lời bảo mật chỉ lưu dạng băm trong phiên chờ. Mã OTP cũng chỉ lưu dạng băm trong database.

Google vẫn dùng Firebase xác minh, không gửi thêm OTP.

## Bật gửi thư

Mở `config/mail.php`, điền:

```php
'gmail_address' => 'gmail-gui-thu@gmail.com',
'gmail_app_password' => 'mat-khau-ung-dung',
```

Dùng Gmail gửi thư của cửa hàng, không phải email người nhận. Bật xác minh 2 bước cho Gmail đó, tạo App Password tại https://myaccount.google.com/apppasswords . Không dùng mật khẩu Gmail thường. Không gửi App Password trong chat và không commit file chứa mật khẩu lên Git. Có thể dùng biến môi trường FISHSHOP_GMAIL_ADDRESS và FISHSHOP_GMAIL_APP_PASSWORD thay vì điền trực tiếp.

Gmail App Password: https://support.google.com/accounts/answer/185833 . Một số tài khoản tổ chức/Advanced Protection không cho tạo App Password.

PHP cần cURL, kết nối Internet đến smtp.gmail.com:465 và CA hợp lệ. Không tắt xác minh TLS. Thư được gửi bằng SMTP qua TLS, không cần cài Google Authenticator hay Composer.

Khi chưa cấu hình gửi thư, trang đăng ký thông báo rõ và nút đăng ký bằng email tạm tắt. Nút Google vẫn hoạt động.

## Database và giới hạn

Nhập `database/RegistrationOtp.sql` vào WebBanCa. File tạo hai bảng mới, không thay đổi tài khoản cũ và có thể chạy lại.

- OTP 6 số có hiệu lực 5 phút, dùng một lần, gắn với trình duyệt yêu cầu.
- Sai 5 lần cần xin mã mới. Mã mới vô hiệu mã trước đó.
- Mỗi email tối đa 5 lần gửi mỗi giờ, cách nhau ít nhất 60 giây; mỗi IP tối đa 20 lần gửi mỗi giờ.
- Có nút gửi lại, sửa email/thông tin và quay về đăng nhập.
- Sau khi sửa thông tin phải nhập lại mật khẩu và câu trả lời bảo mật.
- Nếu tên đăng nhập/email đã được người khác dùng trong lúc chờ OTP, bước tạo tài khoản sẽ từ chối, không ghi đè.

## Kiểm thử

`C:\xampp\php\php.exe database\verify_registration_otp.php` tạo database thử độc lập, sao chép cấu trúc users/customer_ranks (không sao chép dữ liệu), kiểm tra luồng OTP bằng bộ gửi thư giả rồi xóa database thử. Không gửi thư thật trong kiểm thử này.

Sau khi điền cấu hình, đăng ký bằng email bạn kiểm soát, kiểm tra nhận mã, nhập sai, gửi lại và nhập đúng. Chưa có Gmail/App Password thì không thể kiểm thử gửi thư thật.
