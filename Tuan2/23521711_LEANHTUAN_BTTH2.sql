SET DATEFORMAT DMY;

--Câu 1. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

--Câu 2. In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”. 
SELECT MASP, TENSP
FROM SANPHAM 
WHERE DVT IN ('cay', 'quyen')

--Câu 3. In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”. 
SELECT MASP, TENSP
FROM SANPHAM 
WHERE MASP LIKE 'B%01'

--Câu 4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA BETWEEN 30000 AND 40000
--Câu 5. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 
--đến 40.000.
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX IN ('Trung Quoc', 'Thai Lan') AND GIA BETWEEN 30000 AND 40000

--Câu 6. In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD IN ('1/1/2007', '2/1/2007')

--Câu 7. In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa 
--đơn (giảm dần). 
SELECT SOHD, NGHD, TRIGIA
FROM HOADON 
WHERE NGHD BETWEEN '1/1/2007' AND '31/1/2007'
ORDER BY NGHD ASC, TRIGIA DESC

--Câu 8. In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT kh.MAKH, kh.HOTEN
FROM KHACHHANG kh INNER JOIN HOADON hd ON kh.MAKH = hd.MAKH
WHERE hd.NGHD = '1/1/2007'

--Câu 9. In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT hd.SOHD, hd.TRIGIA 
FROM NHANVIEN nv INNER JOIN HOADON hd ON nv.MANV = hd.MANV
WHERE nv.HOTEN = 'Nguyen Van B' AND hd.NGHD = '28/10/2006'

--Câu 10.  In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 
--10/2006. 
SELECT sp.MASP, sp.TENSP 
FROM SANPHAM sp 
INNER JOIN CTHD cthd ON cthd.MASP = sp.MASP
INNER JOIN HOADON hd ON hd.SOHD = cthd.SOHD
INNER JOIN KHACHHANG kh ON kh.MAKH = hd.MAKH
WHERE kh.HOTEN = 'Nguyen Van A' AND hd.NGHD BETWEEN '1/10/2006' AND '31/10/2006'

--Câu 11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT DISTINCT hd.SOHD
FROM HOADON hd JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE cthd.MASP IN ('BB01', 'BB02')

--Câu 12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20
SELECT DISTINCT hd.SOHD
FROM HOADON hd JOIN CTHD cthd ON hd.SOHD = cthd.SOHD
WHERE cthd.MASP IN ('BB01', 'BB02') AND (SL BETWEEN 10 AND 20) 

--Câu 13.  Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản phẩm mua với số lượng từ 10 đến 20
SELECT SOHD
FROM CTHD 
WHERE MASP IN ('BB01') AND (SL BETWEEN 10 AND 20)
INTERSECT
SELECT SOHD
FROM CTHD
WHERE MASP IN ('BB02') AND (SL BETWEEN 10 AND 20)

--Câu 14.  In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản phẩm được bán ra 
--trong ngày 1/1/2007. 
SELECT DISTINCT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc'
UNION
SELECT DISTINCT sp.MASP, TENSP
FROM SANPHAM sp JOIN CTHD ct ON sp.MASP = ct.MASP
				JOIN HOADON hd ON hd.SOHD = ct.SOHD
WHERE hd.NGHD = '1/1/2007'

--Câu 15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (SELECT MASP
					FROM CTHD)

--Câu 16.  In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN (SELECT MASP
					FROM CTHD ct JOIN HOADON hd ON hd.SOHD = ct.SOHD
					WHERE year(NGHD) = 2006)
--Câu 17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong năm 2006.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc' AND MASP NOT IN (SELECT MASP 
					FROM CTHD ct JOIN HOADON hd ON hd.SOHD = ct.SOHD
					WHERE year(NGHD) = 2006)

--Câu 18.  Thống kê số lượng hóa đơn do mỗi nhân viên lập trong năm 2006, hiển thị (MANV, HOTEN, SoLuongHD). 

SELECT nv.MANV, nv.HOTEN, COUNT(hd.SOHD) AS SoLuongHD
FROM NHANVIEN nv JOIN HOADON hd ON nv.MANV = hd.MANV
WHERE year(NGHD) = 2006
GROUP BY nv.MANV, nv.HOTEN

--Câu 19.  In ra danh sách nhân viên và tổng số khách hàng khác nhau mà họ đã bán hàng cho trong năm 2006. 
SELECT nv.MANV, nv.HOTEN, COUNT(distinct kh.MAKH) AS SoLuongKhachHang
FROM NHANVIEN nv JOIN HOADON hd ON nv.MANV = hd.MANV
				 JOIN KHACHHANG kh ON kh.MAKH = hd.MAKH
WHERE year(NGHD) = 2006
GROUP BY nv.MANV, nv.HOTEN
	
--Câu 20. Liệt kê sản phẩm (MASP, TENSP) có tổng số lượng bán ra nhiều nhất trong năm 2006.
SELECT TOP 1 WITH TIES sp.MASP, sp.TENSP, SUM(SL) as TongSoLuongBanRa
FROM  SANPHAM sp JOIN CTHD ct ON ct.MASP = sp.MASP
				 JOIN HOADON hd ON hd.SOHD = ct.SOHD
WHERE YEAR(NGHD) = 2006
GROUP BY sp.MASP, sp.TENSP
ORDER BY TongSoLuongBanRa DESC

--Câu 21. Tìm nhân viên có doanh số bán hàng cao nhất trong tháng 10/2006.
SELECT TOP 1 WITH TIES nv.MANV, HOTEN, SUM(TRIGIA) AS DoanhSo
FROM NHANVIEN nv JOIN HOADON hd ON hd.MANV = nv.MANV
WHERE MONTH(NGHD) = 10 AND YEAR(NGHD) = 2006
GROUP BY nv.MANV, HOTEN
ORDER BY DoanhSo DESC

--Câu 22. . In ra danh sách sản phẩm không bán được trong năm 2007 nhưng có bán trong năm 2006. 
(SELECT sp.MASP, TENSP
FROM SANPHAM sp JOIN CTHD ct ON ct.MASP = sp.MASP
				JOIN HOADON hd ON hd.SOHD = ct.SOHD
WHERE YEAR(NGHD) = 2006)
EXCEPT
(SELECT sp.MASP, TENSP
FROM SANPHAM sp JOIN CTHD ct ON ct.MASP = sp.MASP
				JOIN HOADON hd ON hd.SOHD = ct.SOHD
WHERE YEAR(NGHD) = 2007)


--Câu 23.  Liệt kê danh sách sản phẩm (MASP, TENSP) được bán bởi ít nhất 2 nhân viên khác nhau. 
SELECT sp.MASP, TENSP, COUNT(hd.MANV) AS SoNhanVien
FROM SANPHAM sp JOIN CTHD ct ON ct.MASP = sp.MASP
				JOIN HOADON hd ON hd.SOHD = ct.SOHD
GROUP BY sp.MASP, TENSP
HAVING COUNT(hd.MANV) >= 2

--Câu 24.  In ra danh sách khách hàng không mua sản phẩm nào do Thái Lan sản xuất.

--Câu 25. Tìm hóa đơn có trị giá lớn nhất trong năm 2006, in ra (SOHD, NGHD, TRIGIA). 
