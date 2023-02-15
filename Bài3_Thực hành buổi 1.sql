CREATE DATABASE  MarkManagement;

CREATE TABLE Students (
StudentID NVARCHAR(12) PRIMARY KEY,
StudentName NVARCHAR(25) not null,
DateofBirth Datetime not null,
Email NVARCHAR(40),
Phone NVARCHAR(12),
Class NVARCHAR(10),
)
CREATE TABLE Subjects (
SubjectID NVARCHAR(10) PRIMARY KEY,
SubjectName NVARCHAR(25) not null,
)
CREATE TABLE Mark (
StudentID NVARCHAR(12),
SubjectID NVARCHAR(10),
Date Datetime not null,
theory Tinyint,
Practical Tinyint,
PRIMARY KEY (StudentID, SubjectID)
);

INSERT INTO Students 
VALUES ('AV0807005', 'Mail Trung Hiếu', '11/10/1989', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
('AV0807006', 'Nguyễn Quý Hùng', '2/12/1988', 'quyhung@yahoo.com', '0955667787', 'AV2'),
('AV0807007', 'Đỗ Đắc Huỳnh', '2/1/1990', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
('AV0807009', 'An Đăng Khuê', '6/3/1986', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
('AV0807010', 'Nguyễn T. Tuyết Lan', '12/7/1989', 'tuyetlan@gmail.com', '0983310342', 'AV2'),
('AV0807011', 'Đinh Phụng Long', '2/12/1990', 'phunglong@yahoo.com', NULL, 'AV1'),
('AV0807012', 'Nguyễn Tuấn Nam', '2/3/1990', 'tuannam@yahoo.com', NULL, 'AV1');

INSERT INTO Subjects 
VALUES ('S001', 'SQL'),
('S002', 'Java Simplefield'),
('S003', 'Active Server Page');

INSERT INTO Mark 
VALUES ('AV0807005', 'S001', 8, 25, '6/5/2008'),
('AV0807006', 'S002', 16, 30, '6/5/2008'),
('AV0807007', 'S001', 10, 25, '6/5/2008'),
('AV0807009', 'S003', 7, 13, '6/5/2008'),
('AV0807010', 'S003', 9, 16, '6/5/2008'),
('AV0807011', 'S002', 8, 30, '6/5/2008'),
('AV0807012', 'S001', 7, 31, '6/5/2008'),
('AV0807005', 'S002', 12, 11, '6/6/2008'),
('AV0807009', 'S003', 11, 20, '6/6/2008'),
('AV0807010', 'S001', 7, 6, '6/6/2008');
--1 Hiển thị nội dung bảng Students
select* from Students
--2. Hiển thị nội dung danh sách sinh viên lớp AV1
Select *
From Students
Where Class='AV1';
--3: Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
UPDATE students
set Class = 'AV2'
where studentID='AVAV0807012' ;
--4 Tính tổng số sinh viên của từng lớp
SELECT  Class, COUNT(StudentID) AS 'Số sinh viên'
FROM Students
GROUP BY  Class;
--5 Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
SELECT * FROM Students
Where Class = 'AV2'
ORDER BY StudentName
--6 Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
select * from Students inner join Mark ON Students.StudentID = Mark.StudentID
Where theory > 10 and Date = '6/5/2008'
--7 
SELECT COUNT(*) 
FROM Students S INNER JOIN Mark M
ON S.StudentID = M.StudentID
WHERE M.SubjectID = 'S001' AND  M.theory < 10 
--8 
SELECT * 
FROM Students 
WHERE Class = 'AV1' AND DateofBirth > '1980/1/1';
--9
DELETE 
FROM Students 
WHERE StudentID = 'AV0807011';
--10
SELECT Students.StudentID, StudentName, SubjectName, Theory, Practical, Date 
FROM Mark 
INNER JOIN Subjects ON Mark.SubjectID = Subjects.SubjectID 
INNER JOIN Students ON Mark.StudentID = Students.StudentID 
WHERE Subjects.SubjectID = 'S001' AND Date = '2008/05/06';