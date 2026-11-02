FISH SHOP - NHANH XAMPP CAU HINH PHP
==================================

Nhanh codex/xampp-php-config khong doc .env va khong doc bien moi truong.
Database van cau hinh truc tiep trong config/database.php.

CAU HINH
--------
- config/settings.php: mang PHP mau, cac khoa bi mat de trong tren GitHub.
- config/settings.local.php: mang PHP da dien thong tin that, tu dong ghi de
  ban mau. File nay bi Git va pre-push chan de tranh lo Gmail/PayOS/Cloudinary.
- Chep settings.local.php tu may da cau hinh sang thu muc config tren may moi.
  Goi ZIP cau hinh rieng chi can giai nen file nay vao config, khong can .env.
- Cung co the dien truc tiep config/settings.php tren may chay, nhung khong
  commit/push file da dien khoa that len GitHub.
- File .env cu neu con tren may chi la ban luu de quay lai main; nhanh nay
  khong doc no. Khong can xoa .env cua main.

CHAY TREN XAMPP
---------------
1. Bat Apache va MySQL; PHP 8.2 voi curl, pdo_mysql, mbstring.
2. Dat code tai C:\xampp\htdocs\FishShop va chep cau hinh PHP that nhu tren.
3. Cai moi: tao database WebBanCa, import database/WebBanCa.sql. Khong import
   de dump vao database da co du lieu. Sao luu truoc khi nang cap.
4. Giu C:\xampp\htdocs\Quantri neu dang dung URL /Quantri chuyen tiep admin.
5. Mo http://localhost/FishShop/; dat hang moi can dang nhap.
6. Neu Apache bao thieu curl hoac CA, sua php.ini va Stop/Start Apache.
   Chuyen sang cau hinh PHP khong tu sua loi extension/chung chi cua XAMPP.

DANG NHAP GOOGLE
----------------
- Firebase SDK 13.1.0 nam trong assets/vendor/firebase/13.1.0, khong tai SDK
  tu CDN khi mo trang. Chep ca thu muc nay khi cap nhat sang may khac.
- Sau khi cap nhat, bam Ctrl+F5 tai trang dang nhap de bo cache code cu.
- Nut Google chi bat khi SDK san sang; qua 15 giay se bao loi va cho tai lai.
- Dang nhap van can Internet de mo Google va xac minh tai khoan Firebase.

KIEM TRA
--------
C:\xampp\php\php.exe C:\xampp\htdocs\FishShop\database\check_setup.php
C:\xampp\php\php.exe C:\xampp\htdocs\FishShop\database\check_google_login.php

Migration database cu, chay tu thu muc FishShop:
C:\xampp\php\php.exe database\migrate_delivery_location.php
C:\xampp\php\php.exe database\migrate_vouchers.php

LOG RIENG
---------
C:\xampp\htdocs\FishShop\storage\logs\auth.log.php
Tim [FishShop OTP] hoac [FishShop Firebase]. File bi chan truy cap web va Git.
Chi gui dong loi; khong gui khoa, mat khau, token hoac file settings.local.php.
