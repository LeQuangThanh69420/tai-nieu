CREATE DATABASE quanlyrapchieu;

USE quanlyrapchieu;

--Phim:
CREATE TABLE Phim(
MaPhim char(20),
TenPhim nvarchar(50) NOT NULL,
NamPhatHanh smallint NOT NULL,
QuocGia nvarchar(50) NOT NULL,
ThoiLuong time NOT NULL,
TheLoai nvarchar(50) NOT NULL,
DienVien nvarchar(50) NOT NULL,
CONSTRAINT ma_phim PRIMARY KEY (MaPhim)
);

--Lich chieu:
CREATE TABLE LichChieu(
MaLichChieu char(10),
NgayChieu date NOT NULL,
GioChieu time NOT NULL ,
MaPhongChieu char(3) NOT NULL FOREIGN KEY REFERENCES PhongChieu(MaPhongChieu),
MaPhim char(20) NOT NULL FOREIGN KEY REFERENCES Phim(MaPhim),
CONSTRAINT ma_lich_chieu PRIMARY KEY (MaLichChieu),
);

--Phong chieu:
CREATE TABLE PhongChieu(
MaPhongChieu char(3),
DinhDangPhong char(2) NOT NULL,
CONSTRAINT ma_phong_chieu PRIMARY KEY (MaPhongChieu)
);

--Ghe:
CREATE TABLE Ghe(
MaGhe char(6) ,
TenGhe char(3) ,
LoaiGhe nvarchar(5),
GiaGhe money,
MaPhongChieu char(3) FOREIGN KEY REFERENCES PhongChieu(MaPhongChieu)
CONSTRAINT ma_ghe PRIMARY KEY (Maghe)
);

--Ve xem phim:
CREATE TABLE VeXemPhim(
MaVe char(20),
NgayKhoiTao date NOT NULL,
ThanhTien money NOT NULL,
MaLichChieu char(10) NOT NULL FOREIGN KEY REFERENCES LichChieu(MaLichChieu),
MaGhe char(6) NOT NULL FOREIGN KEY REFERENCES Ghe(MaGhe),
MaKhachHang char(20) NOT NULL FOREIGN KEY REFERENCES KhachHang(MaKhachHang),
MaNhanVien char(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
CONSTRAINT ma_ve PRIMARY KEY (MaVe)
);

--Hoa don dich vu:
CREATE TABLE HoaDonDV(
MaHoaDon char(20),
NgayKhoiTao date NOT NULL,
SoLuong tinyint NOT NULL,
ThanhTien money NOT NULL,
MaKhachHang char(20) NOT NULL FOREIGN KEY REFERENCES KhachHang(MaKhachHang),
MaNhanVien char(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
CONSTRAINT ma_hoa_don PRIMARY KEY (MaHoaDon)
);

--Khach hang:
CREATE TABLE KhachHang(
MaKhachHang char(20),
Ten nvarchar(50) NOT NULL,
NgaySinh date ,
Email char(50),
SDT char(12),
CONSTRAINT ma_khach_hang PRIMARY KEY (MaKhachHang)
);

--Nhan vien:
CREATE TABLE NhanVien(
MaNhanVien char(20),
Ten nvarchar(50) NOT NULL,
NgaySinh date NOT NULL,
DiaChi nvarchar(50) NOT NULL,
SDT char(12) NOT NULL,
CONSTRAINT ma_nhan_vien PRIMARY KEY (MaNhanVien)
);

--Cham cong:
CREATE TABLE ChamCong(
MaCaLam char(10) NOT NULL FOREIGN KEY REFERENCES CaLam(MaCaLam),
MaNhanVien char(20) NOT NULL FOREIGN KEY REFERENCES NhanVien(MaNhanVien),
CONSTRAINT cham_cong PRIMARY KEY (MaCaLam,MaNhanVien) 
);

--Ca lam:
CREATE TABLE CaLam(
MaCaLam char(10),
NgayLam date NOT NULL,
GioLam time NOT NULL,
TongGioLam time NOT NULL,
MucLuong1h money NOT NULL,
CONSTRAINT ma_ca_lam PRIMARY KEY (MaCaLam)
);

--Lay dich vu:
CREATE TABLE LayDV(
MaDV char(3) NOT NULL FOREIGN KEY REFERENCES DSachDV(MaDV),
MaHoaDon char(20) NOT NULL FOREIGN KEY REFERENCES HoaDonDichVu(MaHoaDon),
CONSTRAINT lay_dv PRIMARY KEY (MaDV,MaHoaDon) 
);

--Danh sach dich vu:
CREATE TABLE DSachDV(
MaDV char(3),
TenSP nvarchar(50) NOT NULL,
DonViTinh nchar(3) NOT NULL,
DonGia money NOT NULL,
CONSTRAINT ma_dv PRIMARY KEY (MaDV)
);

SELECT * FROM  NhanVien
SELECT * FROM  KhachHang
SELECT * FROM  Phim

--Dua ra lich chieu trong ngay
SELECT NgayChieu, GioChieu, MaPhongChieu, TenPhim, NamPhatHanh, ThoiLuong
FROM LichChieu join Phim on LichChieu.MaPhim=Phim.MaPhim
WHERE NgayChieu = cast(getdate() as Date)

SELECT * FROM VeXemPhim WHERE NgayKhoiTao = cast(getdate() as Date)

SELECT * FROM HoaDonDV WHERE NgayKhoiTao = cast(getdate() as Date)

--Dua ra so luong va tong doanh thu cua thang hien tai cua ve va hoa ðon
SELECT COUNT(ThanhTien) as SLHD, SUM(ThanhTien) as DoanhThuHD
FROM HoaDonDV 
WHERE MONTH(NgayKhoiTao)=MONTH(getdate()) and YEAR(NgayKhoiTao)=YEAR(getdate())

SELECT COUNT(ThanhTien) as SLVXP, SUM(ThanhTien) as DoanhThuVXP
FROM VeXemPhim 
WHERE MONTH(NgayKhoiTao)=MONTH(getdate()) and YEAR(NgayKhoiTao)=YEAR(getdate())

SELECT * FROM DSachDV

SELECT  Sum(DATEPART(HOUR,TongGioLam)*MucLuong1h) as Luong
FROM CaLam join ChamCong on CaLam.MaCaLam=ChamCong.MaCaLam join NhanVien on ChamCong.MaNhanVien=NhanVien.MaNhanVien
WHERE Ten='Jong Xina'

