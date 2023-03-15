--1.Viết SP spTangLuong dùng để tăng lương lên 10% cho tất cả các nhân viên.

CREATE PROCEDURE spTangLuong
AS
BEGIN
    UPDATE NHANVIEN
    SET Luong = Luong * 1.1
END
--2.Thêm vào cột NgayNghiHuu (ngày nghỉ hưu) trong bảng NHANVIEN. Viết SP spNghiHuu dùng để cập nhật ngày nghỉ hưu là ngày hiện tại cộng thêm 100 (ngày) cho những nhân viên nam có tuổi từ 60 trở lên và nữ từ 55 trở lên.

ALTER TABLE NHANVIEN
ADD NgayNghiHuu DATE
--
GO

CREATE PROCEDURE spNghiHuu
AS
BEGIN
    UPDATE NHANVIEN
    SET NgayNghiHuu = DATEADD(day, 100, GETDATE())
    WHERE PHAI = 'Nam' AND DATEDIFF(year, NGSINH, GETDATE()) >= 60
        OR PHAI = 'Nữ' AND DATEDIFF(year, NGSINH, GETDATE()) >= 55
END
GO

--3.Tạo SP spXemDeAn cho phép xem các đề án có địa điểm đề án được truyền vào khi gọi thủ tục.

CREATE PROCEDURE spXemDeAn
    @DiaDiemDeAn NVARCHAR(50)
AS
BEGIN
    SELECT * FROM DEAN WHERE DDIEM_DA = @DiaDiemDeAn
END
GO

--4.Tạo SP spCapNhatDeAn cho phép cập nhật lại địa điểm đề án với 2 tham số truyền và vào là diadiem_cu, diadiem_moi.

CREATE PROCEDURE spCapNhatDeAn
    @DiaDiemCu NVARCHAR(50),
    @DiaDiemMoi NVARCHAR(50)
AS
BEGIN
    UPDATE DEAN
    SET DDIEM_DA = @DiaDiemMoi
    WHERE DDIEM_DA = @DiaDiemCu
END
GO

--5.Viết SP spThemDeAn để thêm dữ liệu vào bảng DEAN với các tham số vào là các trường của bảng DEAN.

ALTER TABLE DEAN
ADD MaPBB NVARCHAR(10),
    NgayBD DATE,
    NgayKT DATE,
    KinhPhi INT
    
GO

CREATE PROCEDURE spThemDeAn
    @MaDeAn NVARCHAR(10),
    @TenDeAn NVARCHAR(50),
    @DiaDiemDeAn NVARCHAR(50),
    @MaPB NVARCHAR(10),
    @NgayBD DATE,
    @NgayKT DATE,
    @KinhPhi INT
AS
BEGIN
    INSERT INTO DEAN (MADA, TENDA, DDIEM_DA, MaPBB, NgayBD, NgayKT, KinhPhi)
    VALUES (@MaDeAn, @TenDeAn, @DiaDiemDeAn, @MaPB, @NgayBD, @NgayKT, @KinhPhi)
END

GO

--6.SP spThemDeAn:

CREATE PROCEDURE spThemDeAnN 
    @MaDA VARCHAR(10),
    @TenDA NVARCHAR(50),
    @MaPB VARCHAR(10),
    @NgayBD DATE,
    @NgayKT DATE,
    @MoTa NVARCHAR(MAX)
AS
BEGIN
    IF EXISTS (SELECT * FROM DEAN WHERE MaDA = @MaDA)
    BEGIN
        PRINT 'Mã đề án đã tồn tại, đề nghị chọn mã đề án khác.'
        RETURN
    END

    IF NOT EXISTS (SELECT * FROM PHONGBAN WHERE MaPBB = @MaPB)
    BEGIN
        PRINT 'Mã phòng không tồn tại.'
        RETURN
    END

    INSERT INTO DEAN (MaDA, TenDA, MaPBB, NgayBD, NgayKT, MoTa)
    VALUES (@MaDA, @TenDA, @MaPB, @NgayBD, @NgayKT, @MoTa)
    PRINT 'Thêm đề án thành công.'
END
GO

--Trường hợp đúng:


EXEC spThemDeAnN 'DA04', N'Đề án 04', 'PB01', '2023-03-01', '2023-03-31', N'Mô tả đề án 04'

--Trường hợp sai vì mã đề án đã tồn tại:


EXEC spThemDeAnN 'DA01', N'Đề án 01', 'PB01', '2023-03-01', '2023-03-31', N'Mô tả đề án 01'

--Trường hợp sai vì mã phòng ban không tồn tại:


EXEC spThemDeAnN 'DA05', N'Đề án 05', 'PB05', '2023-03-01', '2023-03-31', N'Mô tả đề án 05'

GO

--7.SP spXoaDeAn:

CREATE PROCEDURE spXoaDeAn
    @MaDA VARCHAR(10)
AS
BEGIN
    IF EXISTS (SELECT * FROM PHANCONG WHERE MaDA = @MaDA)
    BEGIN
        PRINT 'Mã đề án đã được phân công, không thể xóa.'
        RETURN
    END

    DELETE FROM DEAN WHERE MaDA = @MaDA
    PRINT 'Xóa đề án thành công.'
END
GO

--8.Cập nhật SP spXoaDeAn:

CREATE PROCEDURE spXoaDeAnN
    @MaDA VARCHAR(10)
AS
BEGIN
    IF EXISTS (SELECT * FROM PHANCONG WHERE MaDA = @MaDA)
    BEGIN
        DELETE FROM PHANCONG WHERE MaDA = @MaDA
    END

    DELETE FROM DEAN WHERE MaDA = @MaDA
    PRINT 'Xóa đề án thành công.'
END
GO

--9. SP spTongGioLamViec:

CREATE PROCEDURE spTongGioLamViec
@MaNV VARCHAR(10),
@TongThoiGian FLOAT OUTPUT
AS
BEGIN
SELECT @TongThoiGian = SUM(ThoiGian)
FROM PHANCONG
WHERE MANV = @MaNV
END

GO

-- Sử dụng SP
DECLARE @TongThoiGian FLOAT
EXEC spTongGioLamViec 'NV001', @TongThoiGian OUTPUT
PRINT 'Tổng thời gian làm việc của nhân viên NV001 là ' + CAST(@TongThoiGian AS VARCHAR(10)) + ' giờ'

GO

--10.SP spTongTien:
CREATE PROCEDURE spTongTien
@MaNV VARCHAR(10)
AS
BEGIN
DECLARE @Luong FLOAT, @TongThoiGian FLOAT, @LuongDeAn FLOAT
SELECT @Luong = Luong FROM NHANVIEN WHERE MaNV = @MaNV


EXEC spTongGioLamViec @MaNV, @TongThoiGian OUTPUT
SET @LuongDeAn = @TongThoiGian * 100000

PRINT 'Tổng tiền phải trả cho nhân viên ''' + @MaNV + ''' là ' + CAST((@Luong + @LuongDeAn) AS VARCHAR(20)) + ' đồng'
END

-- Sử dụng SP
EXEC spTongTien 'NV001'

GO

--11.SP spThemPhanCong:
CREATE PROCEDURE spThemPhanCong
@MaNV VARCHAR(10),
@MaDA VARCHAR(10),
@ThoiGian FLOAT
AS
BEGIN
IF @ThoiGian <= 0
BEGIN
PRINT 'Thời gian phải là một số dương'
RETURN
END


IF NOT EXISTS (SELECT * FROM DEAN WHERE MaDA = @MaDA)
BEGIN
    PRINT 'Mã đề án không tồn tại ở bảng DEAN'
    RETURN
END

IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MaNV = @MaNV)
BEGIN
    PRINT 'Mã nhân viên không tồn tại trong bảng NHANVIEN'
    RETURN
END

INSERT INTO PHANCONG(MANV, MADA, ThoiGian)
VALUES(@MaNV, @MaDA, @ThoiGian)

PRINT 'Thêm phân công thành công'
END

-- Sử dụng SP
EXEC spThemPhanCong 'NV001', 'DA001', 30.5 -- Thêm phân công với mã nhân viên NV001, mã đề án DA001 và thời gian làm việc là 30.5 giờ.