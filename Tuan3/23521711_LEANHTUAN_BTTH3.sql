SET DATEFORMAT DMY

--Câu 26. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT hd.SOHD
FROM HOADON hd JOIN CTHD ct ON hd.SOHD = ct.SOHD
			   JOIN SANPHAM sp ON sp.MASP = ct.MASP
WHERE sp.NUOCSX = 'Singapore'
GROUP BY hd.SOHD
HAVING COUNT(DISTINCT sp.MASP) = (SELECT COUNT(*)
								  FROM SANPHAM
								  WHERE NUOCSX = 'Singapore')

--Câu 27. Tìm số hóa đơn trong năm 2006 đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT hd.SOHD
FROM HOADON hd JOIN CTHD ct ON hd.SOHD = ct.SOHD
			   JOIN SANPHAM sp ON sp.MASP = ct.MASP
WHERE sp.NUOCSX = 'Singapore' AND YEAR(hd.NGHD) = 2006
GROUP BY hd.SOHD
HAVING COUNT(DISTINCT sp.MASP) = (SELECT COUNT(*)
								  FROM SANPHAM
								  WHERE NUOCSX = 'Singapore')

--Câu 28. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*) AS SoHoaDonKhongCoKHDKMua
FROM HOADON 
WHERE MAKH IS NULL
	
--Câu 29. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT  COUNT(DISTINCT ct.MASP)
FROM CTHD ct JOIN HOADON hd ON hd.SOHD = ct.SOHD
WHERE YEAR(hd.NGHD) = 2006

--Câu 30. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) AS TriGiaMax, MIN(TRIGIA) AS TriGiaMin 
FROM HOADON


--Câu 31. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TriGiaTB
FROM HOADON 
WHERE YEAR(NGHD) = 2006

--Câu 32. Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS DoanhThu
FROM HOADON
WHERE YEAR(NGHD) = 2006

--Câu 33. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 SOHD, TRIGIA
FROM HOADON 
WHERE YEAR(NGHD) = 2006
ORDER BY TRIGIA DESC

--Câu 34. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT TOP 1 kh.HOTEN, hd.TRIGIA
FROM KHACHHANG kh JOIN HOADON hd ON hd.MAKH = kh.MAKH
WHERE YEAR(NGHD) = 2006
ORDER BY hd.TRIGIA DESC


--Câu 35. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm dần.
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC

--Câu 36. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (SELECT DISTINCT TOP 3 GIA 
			  FROM SANPHAM
			  ORDER BY GIA DESC)


--Câu 37. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao
--nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN(SELECT DISTINCT TOP 3 GIA
									 FROM SANPHAM
									 ORDER BY GIA DESC)

--Câu 38. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá
--cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN(SELECT DISTINCT TOP 3 GIA
									   FROM SANPHAM
									   WHERE NUOCSX = 'Trung Quoc'
									   ORDER BY GIA DESC)


--Câu 39. In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số).
SELECT MAKH, HOTEN
FROM KHACHHANG
WHERE DOANHSO IN (SELECT DISTINCT TOP 3 DOANHSO
				  FROM KHACHHANG
				  ORDER BY DOANHSO DESC)
					


--Câu 40. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(TENSP) AS SanPham
FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc'

--Câu 41. Tính tổng số sản phẩm của từng nước sản xuất.

SELECT NUOCSX, COUNT(TENSP) AS TONGSANPHAM
FROM SANPHAM
GROUP BY NUOCSX

--Câu 42. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS MaxGia, MIN(GIA) AS MinGia, AVG(GIA) AS TB
FROM SANPHAM
GROUP BY NUOCSX
 
--Câu 43. Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON 
GROUP BY NGHD

--Câu 44. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT ct.MASP, SUM(ct.SL) AS SoLuongSanPham
FROM HOADON hd JOIN CTHD ct ON ct.SOHD = hd.SOHD
WHERE MONTH(hd.NGHD) = 10 AND YEAR(hd.NGHD) = 2006
GROUP BY ct.MASP

--Câu 45. Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANHTHU
FROM HOADON 
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)

--Câu 46. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD, COUNT(DISTINCT MASP) AS SoLoaiSanPham
FROM CTHD
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP) >= 4

--Câu 47. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT ct.SOHD, COUNT(DISTINCT sp.MASP) AS SoSanPham
FROM CTHD ct JOIN SANPHAM sp ON sp.MASP = ct.MASP
WHERE sp.NUOCSX = 'Viet Nam'
GROUP BY ct.SOHD
HAVING COUNT(DISTINCT sp.MASP) = 3

--Câu 48. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT DISTINCT TOP 1 hd.MAKH, kh.HOTEN, COUNT(hd.MAKH) AS SoLanMua
				 FROM HOADON hd JOIN KHACHHANG kh ON kh.MAKH = hd.MAKH
				 GROUP BY hd.MAKH, kh.HOTEN
				 ORDER BY COUNT(hd.MAKH) DESC

--Câu 49. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất?
SELECT TOP 1 MONTH(NGHD) AS Thang, SUM(TRIGIA) AS DoanhSo
FROM HOADON 
WHERE YEAR(NGHD) = 2006
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC

--Câu 50. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 sp.MASP, sp.TENSP, SUM(ct.SL) AS TongLuongBanRa
FROM SANPHAM sp JOIN CTHD ct ON ct.MASP = sp.MASP
				JOIN HOADON hd ON hd.SOHD = ct.SOHD
GROUP BY sp.MASP, sp.TENSP
ORDER BY TongLuongBanRa ASC

--Câu 51. Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT MASP, TENSP
FROM SANPHAM sp JOIN (
SELECT  NUOCSX, MAX(GIA) AS Gia
FROM SANPHAM 
GROUP BY NUOCSX) AS T
ON T.NUOCSX = sp.NUOCSX AND sp.GIA = T.Gia


--Câu 52. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX, COUNT(DISTINCT GIA) AS SoLuongSanPhamGiaKhacNhau
FROM SANPHAM 
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3

--Câu 53. Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất
SELECT TOP 1 WITH TIES kh.MAKH, kh.HOTEN, COUNT(hd.MAKH) AS SoLanMuaHang
FROM HOADON hd JOIN KHACHHANG kh ON kh.MAKH = hd.MAKH
WHERE kh.MAKH IN (SELECT TOP 10 MAKH
				  FROM KHACHHANG 
				  ORDER BY DOANHSO DESC)
GROUP BY kh.MAKH, kh.HOTEN
ORDER BY COUNT(hd.MAKH) DESC

