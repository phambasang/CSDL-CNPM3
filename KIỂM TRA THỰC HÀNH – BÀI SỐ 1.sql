--Câu1:
-- Tạo login cho trưởng nhóm trưởng nhóm
CREATE LOGIN TruongNhom WITH PASSWORD = '12042002';
GO

-- Tạo user cho trưởng nhóm trưởng nhóm
USE AdventureWorks2008R2;
CREATE USER TruongNhom FOR LOGIN TruongNhom;
GO

-- Tạo login cho nhân viên NV
CREATE LOGIN NhanVien WITH PASSWORD = '12042002';
GO

-- Tạo user cho nhân viên NV
USE AdventureWorks2008R2;
CREATE USER NhanVien FOR LOGIN NhanVien;
GO

-- Tạo login cho nhân viên QuanLy
CREATE LOGIN QuanLy WITH PASSWORD = '12042002';
GO

-- Tạo user cho nhân viên QL
USE AdventureWorks2008R2;
CREATE USER QuanLy FOR LOGIN QuanLy;
GO

--b. Phân quyền cho các nhân viên:

-- Phân quyền cho trưởng nhóm TN
USE AdventureWorks2008R2;
GRANT SELECT, UPDATE,DELETE ON Production.ProductInventory TO TruongNhom;
GO

-- Phân quyền cho nhân viên NV
USE AdventureWorks2008R2;
GRANT SELECT,UPDATE, DELETE ON Production.ProductInventory TO NhanVien;
GO

-- Phân quyền cho nhân viên QL
USE AdventureWorks2008R2;
GRANT SELECT ON Production.ProductInventory TO QuanLy;
GO

-- Admin phải có quyền CONTROL trên tất cả các đối tượng trong cơ sở dữ liệu
USE AdventureWorks2008R2;
GRANT CONTROL TO [Admin];
GO

--c. Đăng nhập và thực hiện các yêu cầu:

-- Đăng nhập với tài khoản của trưởng nhóm TN
USE AdventureWorks2008R2;
EXECUTE AS USER = 'TN';

-- Sửa 1 dòng dữ liệu tùy ý trong bảng Production.ProductInventory
UPDATE Production.ProductInventory
SET Quantity = 20
WHERE ProductID = 1;

-- Kết thúc quyền của trưởng nhóm TN
REVERT;

-- Đăng nhập với tài khoản của nhân viên NV
USE AdventureWorks2008R2;
EXECUTE AS USER = 'NV';

-- Xóa 1 dòng dữ liệu tùy ý trong bảng Production.ProductInventory
DELETE FROM Production.ProductInventory
WHERE ProductID = 2;

-- Kết thúc quyền của nhân viên NV
REVERT;

-- Đăng nhập với tài khoản của nhân viên QL
USE AdventureWorks2008R2;
EXECUTE AS USER = 'QL';

-- Xem lại kết quả thực hiện của trưởng nhóm TN và nhân viên NV
SELECT * FROM Production.ProductInventory;

-- Kết thúc quyền của nhân viên QL
REVERT;

d. Ai có thể sửa được dữ liệu bảng Production.Product ?

Chỉ có trưởng nhóm TN và nhân viên QL có thể sửa được dữ liệu bảng Production.Product, vì họ được phân quyền SELECT và UPDATE trên bảng này.

e. Thu hồi quyền cấp cho nhân viên NV:

-- Thu hồi quyền của nhân viên NV
USE AdventureWorks2008R2;
DELETE FROM sys.database_principals WHERE name = 'NV';

USE AdventureWorks2008R2;
DELETE FROM Production.ProductInventory WHERE EmployeeID = 'NV';

USE AdventureWorks2008R2;
REVOKE SELECT, DELETE ON Production.ProductInventory FROM NV;
GO

-- Xóa user của nhân viên NV
USE AdventureWorks2008R2;
DROP USER NV;
GO


--Câu 2:Thực hiện chuỗi các thao tác sau để có thể phục hồi database khi có sự cố ở thời điểm T8?

-- 1: Thực hiện Full Backup
BACKUP DATABASE AdventureWorks2008R2
TO DISK = 'd:\path\AdventureWorks2008R2_Full.bak'
--2 Cập nhật tăng mức tồn kho an toàn SafetyStockLevel trong table Production.Product lên 10% cho các mặt hàng là nguyên liệu sản xuất.
UPDATE Production.Product
SET SafetyStockLevel = SafetyStockLevel * 1.1
WHERE FinishedGoodsFlag = 0;
--3: Thực hiện Differential Backup
BACKUP DATABASE AdventureWorks2008R2
TO DISK = 'd:\path\AdventureWorks2008R2_Diff1.bak'
WITH DIFFERENTIAL
--4 Xóa mọi bản ghi trong bảng Person.Emailaddress
DELETE FROM Person.EmailAddress
--5Thực hiện Differential Backup
BACKUP DATABASE AdventureWorks2008R2
TO DISK = 'd:\path\AdventureWorks2008R2_Diff2.bak'
WITH DIFFERENTIAL
--6 Thêm một dòng trong table Person.ContactType
INSERT INTO Person.ContactType (Name)
VALUES ('Assistant')
--7: Thực hiện Log Backup
BACKUP LOG AdventureWorks2008R2
TO DISK = 'd:\path\AdventureWorks2008R2_Log1.bak'
--8:BACKUP LOG AdventureWorks2008R2
DROP DATABASE AdventureWorks2008R2
--9
-- Phục hồi Full backup
RESTORE DATABASE AdventureWorks2008R2
FROM DISK = 'd:\path\AdventureWorks2008R2_Full.bak'
WITH NORECOVERY;

-- Phục hồi Differential backup gần nhất
RESTORE DATABASE AdventureWorks2008R2
FROM DISK = 'd:\path\AdventureWorks2008R2_Diff2.bak'
WITH NORECOVERY;

-- Phục hồi Differential backup xa hơn
RESTORE DATABASE AdventureWorks2008R2
FROM DISK = 'd:\path\AdventureWorks2008R2_Diff1.bak'
WITH NORECOVERY;

-- Phục hồi các transaction log
RESTORE LOG [database_name]
FROM DISK = 'd:\path\AdventureWorks2008R2_Diff3.bak'
WITH NORECOVERY;
RESTORE LOG [database_name]
FROM DISK = 'd:\path\AdventureWorks2008R2_Diff4.bak'
WITH NORECOVERY;


--10
RESTORE HEADERONLY FROM DISK='d:\path_to_backup_file.bak'


