# Ứng dụng Đặt mượn Sách Thư viện

Bài tập lớn học phần **Lập trình thiết bị di động** – Ứng dụng hỗ trợ độc giả tra cứu, đặt giữ chỗ sách giấy trên điện thoại và hỗ trợ thủ thư quản lý kho sách, duyệt phiếu mượn trả trực tiếp tại quầy.

## Thành viên thực hiện

| Họ và tên | MSSV | Nội dung phụ trách |
| :--- | :--- | :--- |
| **Vũ Xuân Minh** | `24100363` | Xây dựng trang chủ độc giả và thủ thư, tìm kiếm, lọc, xem chi tiết sách và quản lý danh mục sách. |
| **Lê Anh Quân** | `23010580` | Xây dựng đăng ký, đăng nhập, đăng xuất, thông tin cá nhân, đa ngôn ngữ và mô hình, kho dữ liệu dùng chung. |
| **Trần Hữu Kiên** | `23010258` | Xây dựng luồng đặt mượn, theo dõi, hủy, gia hạn, duyệt phiếu, giao–trả sách và quản lý sách yêu thích. |

---

## Tính năng chính

### 1. Phân hệ Độc giả
- Đăng ký tài khoản độc giả mới và đăng nhập.
- Tìm kiếm sách theo từ khóa, lọc theo thể loại (*Văn học*, *Khoa học*).
- Xem số lượng bản sách còn khả dụng thực tế tại thư viện và lưu sách yêu thích.
- Đăng ký đặt mượn trước (chọn ngày hẹn nhận trong vòng 7 ngày, giữ chỗ ngay khi gửi yêu cầu, giới hạn tối đa 3 phiếu đang hoạt động và không đặt trùng đầu sách đang mượn).
- Theo dõi trạng thái phiếu mượn (*Chờ duyệt*, *Chờ nhận*, *Đang mượn*, *Đã trả*, *Từ chối*, *Đã hủy*), hủy yêu cầu khi chưa nhận sách và gia hạn thêm 7 ngày (tối đa 1 lần khi chưa quá hạn).
- Nhận thông báo nhắc nhở trên màn hình chính khi có sách sắp đến hạn trả (còn từ 2 ngày trở xuống) hoặc quá hạn.

### 2. Phân hệ Thủ thư
- Xem nhanh số liệu tổng quan: tổng đầu sách, số bản đang mượn, phiếu chờ duyệt và các phiếu đang quá hạn.
- Quản lý danh mục sách: thêm đầu sách mới (chọn nhanh 6 bìa mẫu trên Android/Web; bản Web hỗ trợ thêm tải ảnh bìa từ máy), chỉnh sửa thông tin và số lượng bản (ràng buộc không thấp hơn số bản đang giữ/mượn), ngừng phục vụ hoặc xóa đầu sách chưa từng phát sinh lịch sử mượn.
- Quản lý và xử lý phiếu mượn toàn thư viện: lọc theo trạng thái, duyệt yêu cầu, từ chối kèm lý do, xác nhận giao sách tại quầy và xác nhận độc giả đã trả sách.

---

## Cấu trúc thư mục mã nguồn (`lib/`)

```text
lib/
├── core/            # Cấu hình theme, route, hằng số và exception
├── data/            # Kho dữ liệu RAM + đồng bộ tab (LibraryDataStore), dữ liệu mẫu (SeedData) và các Repository
├── l10n/            # File ngôn ngữ Tiếng Việt (app_vi.arb) và Tiếng Anh (app_en.arb)
├── models/          # Các lớp thực thể: User, Book, Loan, Favorite, LoanStatus, UserRole
├── services/        # Xử lý nghiệp vụ: AuthService, BookService, LoanService
├── presentation/    # Giao diện và ViewModel chia theo auth, common, reader, librarian
├── app.dart         # Khởi tạo MultiProvider và MaterialApp
└── main.dart        # Điểm vào ứng dụng
```

---

## Hướng dẫn cài đặt và chạy dự án

### 1. Yêu cầu môi trường
- Đã cài đặt **Flutter SDK** (phiên bản Dart `^3.13.4` trở lên).
- Trình duyệt Chrome/Edge (nếu chạy bản Web để demo 2 màn hình song song) hoặc máy ảo Android (Android Studio / VS Code).

### 2. Các bước chạy ứng dụng

Mở terminal tại thư mục gốc của dự án và chạy lần lượt các lệnh sau:

```bash
# Bước 1: Tải các thư viện phụ thuộc
flutter pub get

# Bước 2: Sinh file đa ngôn ngữ (Việt / Anh)
flutter gen-l10n

# Bước 3: Chạy ứng dụng
flutter run
```

Nếu muốn chạy trực tiếp trên trình duyệt Chrome để dễ demo 2 vai trò cùng lúc:

```bash
flutter run -d chrome
```


## Tài khoản có sẵn để kiểm thử

Mật khẩu chung cho tất cả tài khoản mẫu là: **`12345678`**

- **Tài khoản Thủ thư**:
  - Tên đăng nhập: `librarian`
- **Tài khoản Độc giả**:
  - Tên đăng nhập: `minh.reader` (Vũ Xuân Minh)
  - Tên đăng nhập: `lan.reader` (Trần Thị Lan)
  - Tên đăng nhập: `huy.reader` (Lê Quốc Huy)
  - Tên đăng nhập: `mai.reader` (Nguyễn Thị Mai)
  - Tên đăng nhập: `nam.reader` (Phạm Hoàng Nam)

---
*Cập nhật tài liệu hướng dẫn cài đặt và báo cáo dự án - Nhóm 7 (CSE702027).*

