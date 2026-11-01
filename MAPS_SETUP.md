# Bản đồ giao hàng và vị trí cửa hàng

Fish Shop dùng Leaflet 1.9.4 để hiển thị bản đồ nền OpenStreetMap. Thư viện được lưu tại `assets/vendor/leaflet/`, không cần Composer hoặc Google Maps API key. Cần Internet để tải nền bản đồ; thư viện chỉ khởi tạo khi bản đồ sắp xuất hiện trong màn hình.

## Chọn điểm giao hàng

Trang `checkout.php` cho phép bấm lên bản đồ, kéo ghim, ghim tại tâm bản đồ hoặc chọn **Vị trí của tôi**. Trình duyệt chỉ xin quyền định vị sau khi khách bấm nút. Định vị cần HTTPS hoặc localhost; khi khách không cấp quyền, vẫn có thể chọn ghim thủ công.

Địa chỉ đầy đủ vẫn phải được nhập để giao hàng. Ghim là tùy chọn; không tự suy đoán địa chỉ từ tọa độ. Khi bỏ ghim, đơn dùng địa chỉ văn bản như trước. Tọa độ đã chọn được máy chủ kiểm tra và lưu cùng đơn hàng; khách chỉ xem được điểm của đơn mình, quản trị xem trong chi tiết đơn. Các nút **Xem điểm giao hàng**/**Chỉ đường đến cửa hàng** mở Google Maps mà không gọi Maps API.

Từ thư mục gốc FishShop, chạy migration khi chuyển sang máy khác:

```powershell
C:\xampp\php\php.exe database\migrate_delivery_location.php
```

Có thể nhập `database/DeliveryLocation.sql` bằng phpMyAdmin nếu dùng MariaDB của XAMPP. Migration chỉ thêm hai cột nullable `orders.shipping_latitude` và `orders.shipping_longitude`; chạy lặp lại không mất dữ liệu. File database chính đã có hai cột này. Máy hiện tại đã chạy migration.

## Vị trí cửa hàng

Điền tại `.env` (bản mẫu trong `.env.example`):

```dotenv
FISHSHOP_STORE_LOCATION_NAME=
FISHSHOP_STORE_ADDRESS=
FISHSHOP_STORE_LATITUDE=
FISHSHOP_STORE_LONGITUDE=
FISHSHOP_MAP_TILE_URL=https://tile.openstreetmap.org/{z}/{x}/{y}.png
```

Bản đồ cửa hàng xuất hiện trong phần **Hỗ trợ** ở chân trang khách hàng, có địa chỉ và nút chỉ đường. Máy hiện tại đặt tại Trường Đại học Công nghệ Kỹ thuật Vĩnh Long theo địa điểm người dùng chọn: 73 Nguyễn Huệ, phường Long Châu, tỉnh Vĩnh Long. Tọa độ lấy theo vị trí khuôn viên trên OpenStreetMap, có thể chỉnh lại nếu cần đặt chính xác tại một cổng.

Giữ hiển thị ghi công OpenStreetMap trên bản đồ. Không tải trước hàng loạt hoặc sử dụng nền này cho bản đồ offline. Nếu triển khai lưu lượng lớn, chuyển `FISHSHOP_MAP_TILE_URL` sang nhà cung cấp phù hợp và cập nhật ghi công tương ứng trong `assets/js/maps.js`.

Tham khảo: [Leaflet](https://leafletjs.com/examples/quick-start/), [chính sách nền bản đồ OSM](https://operations.osmfoundation.org/policies/tiles/), [địa chỉ nhà trường](https://vlute.edu.vn/truong-dai-hoc-su-pham-ky-thuat-vinh-long?language=vi), [vị trí khuôn viên](https://mapcarta.com/W1085777666).
