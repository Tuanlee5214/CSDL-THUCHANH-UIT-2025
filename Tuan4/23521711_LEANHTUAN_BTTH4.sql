--I. Ngôn ngữ định nghĩa dữ liệu (Data Definition Language):

--Câu 1. Tạo quan hệ và khai báo tất cả các ràng buộc khóa chính, khóa ngoại. Thêm vào 3 thuộc tính GHICHU,
--DIEMTB, XEPLOAI cho quan hệ HOCVIEN.
ALTER TABLE HOCVIEN ADD GHICHU NVARCHAR(50)
ALTER TABLE HOCVIEN ADD DIEMTB NUMERIC(4,2)
ALTER TABLE HOCVIEN ADD XEPLOAI NVARCHAR(15)

--Câu 2. Thuộc tính GIOITINH chỉ có giá trị là “Nam” hoặc “Nu”.
ALTER TABLE HOCVIEN ADD CHECK (GIOITINH IN('Nam', 'Nu'))
ALTER TABLE GIAOVIEN ADD CHECK (GIOITINH IN('Nam', 'Nu'))

--Câu 3.** Điểm số của một lần thi có giá trị từ 0 đến 10 và cần lưu đến 2 số lẽ (VD: 6.22).
ALTER TABLE KETQUATHI ADD CHECK (DIEM BETWEEN 0 AND 10 AND RIGHT(CAST(DIEM AS VARCHAR), 3) LIKE '.__')

--Câu 4.** Kết quả thi là “Dat” nếu điểm từ 5 đến 10 và “Khong dat” nếu điểm nhỏ hơn 5.
ALTER TABLE KETQUATHI ADD CHECK (
	(KQUA = 'Dat' AND DIEM BETWEEN 5 AND 10) OR 
	(KQUA = 'Khong Dat' AND DIEM < 5)
)
				
--Câu 5. Học viên thi một môn tối đa 3 lần.
ALTER TABLE KETQUATHI ADD CHECK (LANTHI <= 3)

--Câu 6. Học kỳ chỉ có giá trị từ 1 đến 3.
ALTER TABLE GIANGDAY ADD CHECK (HOCKY IN (1, 2, 3))

--Câu 7. Học vị của giáo viên chỉ có thể là “CN”, “KS”, “Ths”, ”TS”, ”PTS”.
ALTER TABLE GIAOVIEN ADD CHECK (HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS'))

--Câu 8. Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 18)

--Câu 9. Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CHECK (TUNGAY < DENNGAY)

--Câu 10. Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD CHECK (YEAR(GETDATE()) - YEAR(NGSINH) >= 22)

--Câu 11. Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC ADD CHECK (ABS(TCLT - TCTH) <= 3)

--II. Ngôn ngữ thao tác dữ liệu (Data Manipulation Language):

--Câu 1. Tăng hệ số lương thêm 0.2 cho những giáo viên là trưởng khoa.
UPDATE GIAOVIEN 
SET HESO = HESO + 0.2
WHERE MAGV IN (SELECT TRGKHOA
			   FROM KHOA)

--Câu 2. Cập nhật giá trị điểm trung bình tất cả các môn học (DIEMTB) của mỗi học viên (tất cả các môn học
--đều có hệ số 1 và nếu học viên thi một môn nhiều lần, chỉ lấy điểm của lần thi sau cùng).
UPDATE HV
SET HV.DIEMTB = M.DIEMTB
FROM HOCVIEN HV JOIN (
SELECT kq.MAHV, AVG(DIEM) AS DIEMTB
FROM KETQUATHI kq JOIN (
SELECT MAHV, MAMH, MAX(LANTHI) AS LANTHI
FROM KETQUATHI 
GROUP BY MAHV, MAMH) AS T ON T.MAHV = kq.MAHV AND T.MAMH = kq.MAMH AND T.LANTHI = kq.LANTHI
GROUP BY kq.MaHV) AS M ON M.MAHV = HV.MAHV

--Câu 3. Cập nhật giá trị cho cột GHICHU là “Cam thi” đối với trường hợp: học viên có một môn bất kỳ thi lần
--thứ 3 dưới 5 điểm.
UPDATE HOCVIEN
SET GHICHU = 'Cam thi'
WHERE MAHV IN (
SELECT DISTINCT MAHV
FROM KETQUATHI 
WHERE LANTHI = 3 AND DIEM < 5)

--Câu 4. Cập nhật giá trị cho cột XEPLOAI trong quan hệ HOCVIEN như sau:
--o Nếu DIEMTB >= 9 thì XEPLOAI =”XS”
--o Nếu 8 <= DIEMTB < 9 thì XEPLOAI = “G”
--o Nếu 6.5 <= DIEMTB < 8 thì XEPLOAI = “K”
--o Nếu 5 <= DIEMTB < 6.5 thì XEPLOAI = “TB”
--o Nếu DIEMTB < 5 thì XEPLOAI = ”Y”
UPDATE HOCVIEN
SET XEPLOAI = CASE 
					WHEN DIEMTB >= 9 THEN 'XS'
					WHEN DIEMTB >= 8 AND DIEMTB < 9 THEN 'G'
					WHEN DIEMTB >= 6.5 AND DIEMTB < 8 THEN 'K'
					WHEN DIEMTB >= 5 AND DIEMTB < 6.5 THEN 'TB'
					WHEN DIEMTB < 5 THEN 'Y'
			   END;

--III. Ngôn ngữ truy vấn dữ liệu:
--Câu 1. In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HV.MAHV, HV.HO, HV.TEN, HV.NGSINH, L.MALOP
FROM HOCVIEN HV JOIN LOP L ON L.TRGLOP = HV.MAHV

--Câu 2. In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo
--tên, họ học viên.
SELECT HV.MAHV, HV.HO, HV.TEN, KQ.LANTHI, KQ.DIEM
FROM HOCVIEN HV JOIN KETQUATHI KQ ON KQ.MAHV = HV.MAHV
WHERE HV.MALOP = 'K12' AND KQ.MAMH = 'CTRR'
ORDER BY TEN, HO ASC

--Câu 3. In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ
--nhất đã đạt.
SELECT HV.MAHV, HV.HO, HV.TEN, MH.TENMH
FROM HOCVIEN HV JOIN KETQUATHI KQ ON KQ.MAHV = HV.MAHV 
				JOIN MONHOC MH ON MH.MAMH = KQ.MAMH
WHERE LANTHI = 1 AND KQUA = 'Dat'

--Câu 4. In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV JOIN KETQUATHI KQ ON KQ.MAHV = HV.MAHV
WHERE HV.MALOP = 'K11' AND KQ.MAMH = 'CTRR' AND KQ.LANTHI = 1 AND KQ.KQUA = 'Khong dat'

--Câu 5. * Danh sách học viên (mã học viên, họ tên) của lớp “K12” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT HV.MAHV, HV.HO, HV.TEN
FROM HOCVIEN HV JOIN KETQUATHI KQ ON HV.MAHV = KQ.MAHV
WHERE HV.MALOP = 'K11' AND KQ.MAMH = 'CTRR' AND KQ.LANTHI = 3 AND KQ.KQUA = 'Khong dat'

--Câu 6. Tìm tên những môn học mà giáo viên có tên “Tran Tam Thanh” dạy trong học kỳ 1 năm 2006.
SELECT DISTINCT MH.TENMH
FROM GIANGDAY GD JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
				 JOIN MONHOC MH ON MH.MAMH = GD.MAMH
WHERE GV.HOTEN = 'Tran Tam Thanh' AND GD.HOCKY = 1 AND GD.NAM = 2006

--Câu 7. Tìm những môn học (mã môn học, tên môn học) mà giáo viên chủ nhiệm lớp “K11” dạy trong học kỳ 1
--năm 2006.
SELECT DISTINCT MH.MAMH, MH.TENMH
FROM GIANGDAY GD JOIN MONHOC MH ON MH.MAMH = GD.MAMH 
				 JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
WHERE GD.HOCKY = 1 AND GD.NAM = 2006 AND GV.MAGV = (
	SELECT MAGVCN
	FROM LOP 
	WHERE MALOP = 'K11'
)

--Câu 8. Tìm họ tên lớp trưởng của các lớp mà giáo viên có tên “Nguyen To Lan” dạy môn “Co So Du Lieu”.
SELECT HV.HO, HV.TEN
FROM GIANGDAY GD JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
				 JOIN MONHOC MH ON MH.MAMH = GD.MAMH 
				 JOIN LOP L ON L.MALOP = GD.MALOP
				 JOIN HOCVIEN HV ON HV.MAHV = L.TRGLOP
WHERE GV.HOTEN = 'Nguyen To Lan' AND MH.TENMH = 'Co So Du Lieu'

--Câu 9. In ra danh sách những môn học (mã môn học, tên môn học) phải học liền trước môn “Co So Du Lieu”.
SELECT MAMH, TENMH
FROM MONHOC 
WHERE MAMH IN (
SELECT DISTINCT DK.MAMH_TRUOC
FROM DIEUKIEN DK JOIN MONHOC MH ON MH.MAMH = DK.MAMH
WHERE MH.TENMH = 'Co So Du Lieu')

--Câu 10. Môn “Cau Truc Roi Rac” là môn bắt buộc phải học liền trước những môn học (mã môn học, tên môn
--học) nào.

SELECT MAMH, TENMH 
FROM MONHOC
WHERE MAMH IN (
SELECT DK.MAMH
FROM DIEUKIEN DK JOIN MONHOC MH ON MH.MAMH = DK.MAMH_TRUOC
WHERE MH.TENMH = 'Cau Truc Roi Rac')

--Câu 11. Tìm họ tên giáo viên dạy môn CTRR cho cả hai lớp “K11” và “K12” trong cùng học kỳ 1 năm 2006.
SELECT GV.HOTEN 
FROM GIANGDAY GD JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'CTRR' AND GD.MALOP = 'K11' AND HOCKY = 1 AND NAM = 2006
INTERSECT 
SELECT GV.HOTEN 
FROM GIANGDAY GD JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'CTRR' AND GD.MALOP = 'K12' AND HOCKY = 1 AND NAM = 2006


--Câu 12. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại
--môn này.
SELECT HV.MAHV, HV.HO, HV.TEN
FROM KETQUATHI KQ JOIN HOCVIEN HV ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL' AND KQ.LANTHI = 1 AND KQ.KQUA = 'Khong Dat'
EXCEPT 
SELECT HV.MAHV, HV.HO, HV.TEN
FROM  KETQUATHI KQ JOIN HOCVIEN HV ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CSDL' AND KQ.LANTHI = 2


--Câu 13. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào.
SELECT MAGV, HOTEN
FROM GIAOVIEN 
WHERE MAGV NOT IN (SELECT GD.MAGV
		 FROM GIANGDAY GD JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV)

--Câu 14. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào thuộc khoa
--giáo viên đó phụ trách.
SELECT MAGV, HOTEN
FROM GIAOVIEN 
WHERE MAGV NOT IN (
SELECT GD.MAGV
FROM GIANGDAY GD JOIN MONHOC MH ON MH.MAMH = GD.MAMH
				 JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
WHERE GV.MAKHOA = MH.MAKHOA
)

--Câu 15. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn “Khong dat” hoặc thi lần thứ
--2 môn CTRR được 5 điểm.
SELECT HV.MAHV, HV.HO, HV.TEN
FROM KETQUATHI KQ JOIN HOCVIEN HV ON HV.MAHV = KQ.MAHV 
WHERE KQ.LANTHI = 3 AND KQ.KQUA = 'Khong Dat' AND HV.MALOP = 'K11'
UNION 
SELECT HV.MAHV, HV.HO, HV.TEN
FROM KETQUATHI KQ JOIN HOCVIEN HV ON HV.MAHV = KQ.MAHV
WHERE KQ.MAMH = 'CTRR' AND KQ.LANTHI = 2 AND KQ.DIEM = 5.00 AND HV.MALOP = 'K11'

--Câu 16. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học.

SELECT GV.HOTEN
FROM GIANGDAY GD JOIN GIAOVIEN GV ON GV.MAGV = GD.MAGV
WHERE GD.MAMH = 'CTRR'
GROUP BY GV.HOTEN, GD.HOCKY, GD.NAM
HAVING COUNT(GD.MALOP) >= 2

--Câu 17. Danh sách học viên và điểm thi môn CSDL (chỉ lấy điểm của lần thi sau cùng).
SELECT KQ.MAHV, T.HO, T.TEN, KQ.DIEM
FROM KETQUATHI KQ 
JOIN (
SELECT HV.MAHV, HV.HO, HV.TEN, MAX(KQ.LANTHI) AS LANTHI
FROM HOCVIEN HV JOIN KETQUATHI KQ ON KQ.MAHV = HV.MAHV
WHERE KQ.MAMH = 'CSDL'
GROUP BY HV.MAHV, HV.HO, HV.TEN
) AS T ON T.MAHV = KQ.MAHV AND 
							  T.LANTHI = KQ.LANTHI
WHERE KQ.MAMH = 'CSDL'


--Câu 18. Danh sách học viên và điểm thi môn “Co So Du Lieu” (chỉ lấy điểm cao nhất của các lần thi).
SELECT HV.MAHV, HV.HO, HV.TEN, MAX(KQ.DIEM) AS DIEM
FROM HOCVIEN HV JOIN KETQUATHI KQ ON KQ.MAHV = HV.MAHV
WHERE KQ.MAMH = 'CSDL'
GROUP BY HV.MAHV, HV.HO, HV.TEN

--Câu 19. Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA
FROM KHOA 
WHERE NGTLAP IN (
SELECT MIN(NGTLAP)
FROM KHOA)

--Câu 20. Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(*) AS SOGV
FROM GIAOVIEN 
WHERE  HOCHAM = 'PGS' OR HOCHAM = 'GS'
 

--Câu 21. Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT K.MAKHOA, K.TENKHOA, GV.HOCVI, COUNT(*) AS SOLUONGGV
FROM KHOA K JOIN GIAOVIEN GV ON GV.MAKHOA = K.MAKHOA
WHERE GV.HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY K.MAKHOA, K.TENKHOA, GV.HOCVI
ORDER BY K.TENKHOA

--Câu 22. Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MH.MAMH, MH.TENMH, KQ.KQUA, COUNT(*) AS SOLUONGHV
FROM MONHOC MH JOIN KETQUATHI KQ ON MH.MAMH = KQ.MAMH
JOIN(
SELECT MAHV, MAMH, MAX(LANTHI) AS LANTHI
FROM KETQUATHI
GROUP BY MAHV, MAMH
) AS T ON T.MAHV = KQ.MAHV AND T.MAMH = KQ.MAMH AND KQ.LANTHI = T.LANTHI
GROUP BY MH.MAMH, MH.TENMH, KQ.KQUA
ORDER BY MH.MAMH ASC

--Câu 23. Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít
--nhất một môn học.


--Câu 24. Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.


--Câu 25. * Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần
--thi).


--Câu 26. Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.

--Câu 27. Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.

--Câu 28. Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.

--Câu 29. Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.

--Câu 30. Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.

--Câu 31. Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).

--Câu 32. * Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).

--Câu 33. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).

--Câu 34. * Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi sau cùng).

--Câu 35. ** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau
--cùng).