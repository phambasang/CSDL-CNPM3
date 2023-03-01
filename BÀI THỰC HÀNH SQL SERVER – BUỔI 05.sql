--Câu 18. Cho biết số lượng đề án của công ty
SELECT COUNT(*) FROM DEAN;

--19 Liệt kê danh sách các phòng ban có tham gia chủ trì các đề án
select TENPHG,count(*)
	from PHONGBAN,DEAN
	where maphg=phong
	group by TENPHG
	--dean
	select*
	from DEAN


--20 Cho biết số lượng các phòng ban có tham gia chủ trì các đề án
select TENPHG,COUNT(*) as 'Số lượng phòng ban làm việc'
	from PHONGBAN,DEAN
	where MAPHG=PHONG
	group by TENDA

--21 Cho biết số lượng đề án do phòng 'Nghiên Cứu' chủ trì
	select count(*)
	from PHONGBAN,DEAN
	where PHONG=MAPHG and TENPHG like N'Nghiên cứu'
	--dean
	select *
	from dean
	--phancong
	select *
	from PHANCONG
	--nhanvien
	select*
	from NHANVIEN

go
--22  Cho biết lương trung bình của các nữ nhân viên
	select avg(LUONG) as 'Lương Trung Bình của các NV nữ'
	from NHANVIEN
	where phai like N'Nữ'
go
--23 Cho biết số thân nhân của nhân viên 'Đinh Bá Tiến'
	select count(*) as 'Số thân nhân của tiến'
	from NHANVIEN,THANNHAN
	where MANV=MA_NVIEN and HONV = N'Đinh' and TENLOT=N'Bá' and TENNV=N'Tiến'
go
--25 Với mỗi đề án, liệt kê mã đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
	select dean.MADA,sum(PHANCONG.THOIGIAN) as 'Tổng giờ làm'
	from PHANCONG,DEAN
	where PHANCONG.MADA = DEAN.MADA
	group by DEAN.MADA 
--26 Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.

	select dean.TENDA,sum(PHANCONG.THOIGIAN) as 'Tổng giờ làm'
	from PHANCONG,DEAN
	where PHANCONG.MADA = DEAN.MADA
	group by DEAN.TENDA 
--27 Với mỗi đề án, cho biết có bao nhiêu nhân viên tham gia đề án đó
	select MADA, count(*)
	from PHANCONG,NHANVIEN
	where MANV=MA_NVIEN
	group by MADA

go
--28. Với mỗi nhân viên, cho biết họ và tên nhân viên và số lượng thân nhân của nhân viên đó.
go
	select HONV+' '+TENNV as 'Họ Và Tên',count(*) as 'Số lượng thân nhân'
	from NHANVIEN,THANNHAN
	where MANV = MA_NVIEN
	group by HONV,TENNV

go
--29 Với mỗi nhân viên, cho biết họ tên của nhân viên và số lượng đề án mà nhân viên đó đã tham gia.
go
	select honv,tennv,count(*)
	from NHANVIEN,PHANCONG
	where MANV=MA_NVIEN
	group by honv,tennv
go
--30 Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm việc cho phòng ban đó.
	select TENPHG,AVG(LUONG)
		from PHONGBAN,NHANVIEN
		where maphg=PHG
		group by TENPHG
	go
--31 Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên phòng ban và số lượng nhân viên của phòng ban đó.
go
	select TENPHG,COUNT(*) as 'Số lượng nhân viên làm việc'
	from PHONGBAN,NHANVIEN
	where MAPHG=PHG
	group by TENPHG
	having avg(LUONG)>5200000
go
--32. Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà phòng ban đó chủ trì
go	
	select TENPHG,count(*)
	from PHONGBAN,DEAN
	where maphg=phong
	group by TENPHG
	--dean
	select*
	from DEAN
go
--33. Với mỗi phòng ban, cho biết tên phòng ban, họ tên người trưởng phòng và số lượng đề án mà phòng ban đó chủ trì
go


select TENPHG,HONV,TENLOT,TENNV,count(*) as 'Số lượng đề án'
	from PHONGBAN,NHANVIEN,DEAN
	where MANV=TRPHG and MAPHG=PHONG
	group by TENPHG,HONV,TENLOT,TENNV
go

--34. Với mỗi đề án, cho biết tên đề án và số lượng nhân viên của đề án
--này.
go
	select DEAN.TENDA,count(TENNV) as 'Số lượng NV'
	from DEAN,NHANVIEN
	where dean.MADA = NHANVIEN.MANV
	group by DEAN.TENDA
go