--Phần I: Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):

--Câu 1. Thêm vào thuộc tính GHICHU có kiểu dữ liệu varchar(20) cho quan hệ SANPHAM.
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20);

--Câu 2. Thêm vào thuộc tính LOAIKH có kiểu dữ liệu là tinyint cho quan hệ KHACHHANG.
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT;

--Câu 3. Sửa kiểu dữ liệu của thuộc tính GHICHU trong quan hệ SANPHAM thành varchar(100).
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100);

--Câu 4. Xóa thuộc tính GHICHU trong quan hệ SANPHAM.
ALTER TABLE SANPHAM DROP COLUMN GHICHU;

--Câu 5. Làm thế nào để thuộc tính LOAIKH trong quan hệ KHACHHANG có thể lưu các giá trị là: “Vang lai”,
--“Thuong xuyen”, “Vip”, …
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(50);

--Câu 6. Đơn vị tính của sản phẩm chỉ có thể là (“cay”, “hop”, “cai”, “quyen”, “chuc”).
ALTER TABLE SANPHAM ADD CHECK(DVT = 'cay' OR DVT = 'hop' OR DVT = 'cai' OR DVT = 'quyen' OR DVT = 'chuc');

--Câu 7. Giá bán của sản phẩm từ 500 đồng trở lên.
ALTER TABLE SANPHAM ADD CHECK(GIA >= 500);

--Câu 8. Số điện thoại của nhân viên phải bắt đầu bằng chữ số “0”.
ALTER TABLE NHANVIEN ADD CHECK(SODT LIKE '0%');

--Câu 9. Mỗi lần mua hàng, khách hàng phải mua ít nhất 1 sản phẩm.
ALTER TABLE CTHD ADD CHECK (SL >= 1);

--Câu 10. Ngày khách hàng đăng ký là khách hàng thành viên phải lớn hơn ngày sinh của người đó.
ALTER TABLE KHACHHANG ADD CHECK(NGDK > NGSINH);

--Phần II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):

--Câu 1. Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa
--toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT * INTO SANPHAM1 FROM SANPHAM;
SELECT * INTO KHACHHANG1 FROM KHACHHANG;

--Câu 2. Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1
SET GIA = GIA * 1.05
WHERE NUOCSX = 'Thai Lan';

--Câu 3. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho
--quan hệ SANPHAM1).
UPDATE SANPHAM1
SET GIA = 0.95 * GIA
WHERE NUOCSX = 'Trung Quoc' AND GIA <= '10000';

--Câu 4. Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có
--doanh số từ 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số
--từ 2.000.000 trở lên (cho quan hệ KHACHHANG1)

UPDATE KHACHHANG1 
SET LOAIKH = 'Vip'
WHERE (NGDK < '1/1/2007' AND DOANHSO >= '10000000') 
OR    (NGDK >= '1/1/2007' AND DOANHSO >= '2000000')

