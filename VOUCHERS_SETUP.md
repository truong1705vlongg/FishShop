# Mã giảm giá và luồng mua hàng

Máy hiện tại đã cập nhật database. Khi chuyển sang máy khác có database cũ, từ thư mục gốc FishShop chạy:

```powershell
C:\xampp\php\php.exe database\migrate_vouchers.php
```

Hoặc nhập `database/Vouchers.sql` trong phpMyAdmin (MariaDB/XAMPP). Migration tạo bảng vouchers/voucher_usages và thêm cột đơn hàng; không thay đổi giá trị đơn cũ. File SQL database chính cũng đã có cấu trúc này.

Quản trị vào mục **Mã giảm giá** để tạo mã, chọn số tiền cố định hoặc phần trăm (1–99%), đơn tối thiểu, mức giảm tối đa, thời gian áp dụng (giờ Việt Nam), giới hạn tổng lượt và lượt mỗi khách. Có thể bật/tắt và sửa điều kiện; mã đã tạo không đổi tên. Không tự tạo chương trình giảm giá thật khi cài tính năng.

Khách có thể xem cửa hàng, tìm kiếm, xem sản phẩm và thêm vào giỏ khi chưa đăng nhập. Khi tiến hành đặt hàng, website yêu cầu đăng nhập, gộp giỏ khách với giỏ tài khoản theo tồn kho rồi quay lại bước đặt hàng. Trang cá nhân, đơn hàng và khu quản trị vẫn kiểm tra quyền riêng.

Tại bước đặt hàng, nhập mã ở phần tóm tắt đơn. Mỗi đơn áp dụng một mã. Đổi/bỏ mã giữ lại thông tin giao hàng và ghim đang chọn. Mã sai/hết hạn/hết lượt phải được đổi hoặc bỏ trước khi đặt hàng, tránh âm thầm mất ưu đãi. Máy chủ luôn kiểm tra lại mã, lượt dùng, giá và tồn kho trong giao dịch tạo đơn; không tin tổng tiền từ trình duyệt.

Tổng tiền sau giảm được lưu trong đơn, dùng cho thanh toán, hiển thị chi tiết, xuất Word và tính điểm tích lũy. Đơn đã hủy giải phóng lượt dùng mã; lịch sử sử dụng vẫn giữ. Tổng sau giảm phải lớn hơn 0đ. Chuyển khoản chỉ chọn được khi tổng sau giảm nằm trong giới hạn hiện tại 2.000–500.000.000đ; các đơn ngoài khoảng có thể chọn tiền mặt.

Thanh toán chỉ báo thành công sau khi máy chủ xác minh trạng thái đã thanh toán, rồi đếm 3–2–1 và chuyển tới chi tiết đơn. Tín hiệu từ khung thanh toán chỉ bắt đầu xác minh, không tự đánh dấu thành công.
