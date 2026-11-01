# Lưu ảnh bằng Cloudinary

Ảnh sản phẩm (thêm/sửa trong quản trị) và ảnh đại diện (trang tài khoản) được PHP tải lên Cloudinary. Database lưu URL HTTPS, không cần sửa cấu trúc bảng. Ảnh cũ trong `uploads/` vẫn hiển thị; khi thay ảnh, ảnh mới được lưu trên Cloudinary.

## Cấu hình

1. Đăng nhập [Cloudinary Console](https://console.cloudinary.com/).
2. Chọn đúng product environment, vào **Settings → API Keys** để lấy **Cloud name**, **API Key**, **API Secret**.
3. Thêm các giá trị sau vào file `.env` ở thư mục gốc FishShop:

```dotenv
CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=
CLOUDINARY_FOLDER=fishshop
```

`CLOUDINARY_FOLDER` là tiền tố public ID cho ảnh của cửa hàng. Mặc định ảnh dùng ID `fishshop/products/<mã ngẫu nhiên>` hoặc `fishshop/avatars/<mã ngẫu nhiên>`. Có thể đặt thư mục trước lần tải đầu tiên; giữ nguyên để hệ thống nhận diện và xóa ảnh cũ khi thay ảnh.

PHP phải bật extension **cURL** và kết nối HTTPS được đến `api.cloudinary.com`. Không cần Composer, webhook hay upload preset. PHP ký yêu cầu bằng SHA-256; API Secret chỉ được đọc ở máy chủ. Không đưa key vào JavaScript hay commit `.env` lên Git. `.env.example` chỉ chứa ô trống và `.gitignore` đã chặn `.env`.

## Cách hoạt động

- Chấp nhận JPG, PNG, WEBP, tối đa 2MB; kiểm tra nội dung ảnh thật trước khi gửi đi.
- Tạo public ID riêng cho từng lần tải, lưu `secure_url` vào `products.image` hoặc `users.avatar`.
- Chỉ xóa ảnh cũ sau khi cập nhật database thành công. Nếu ghi database thất bại, dọn ảnh vừa tải lên.
- Chỉ gửi lệnh xóa Cloudinary cho URL trong đúng tài khoản, tiền tố và mẫu ID do ứng dụng tạo. Lỗi dọn ảnh không làm hỏng việc lưu thông tin đã thành công.
- Khi chưa có cấu hình hoặc Cloudinary không phản hồi, hiển thị lỗi tải ảnh và giữ dữ liệu/ảnh hiện tại.

Tham khảo: [Cloudinary Upload API](https://cloudinary.com/documentation/image_upload_api_reference), [chữ ký xác thực](https://cloudinary.com/documentation/authentication_signatures).
