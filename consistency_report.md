# Báo Cáo Chẩn Đoán Lỗ Hổng Dữ Liệu (Gap Analysis Report)
**Dự án:** Hệ thống Quản lý Phòng khám HealthSync  
**Người thực hiện:** System Analyst & DBA  

---

## Các điểm "vênh" nghiêm trọng giữa Activity Diagram và Legacy SQL

### 1. Dùng kiểu dữ liệu BOOLEAN cho quy trình đa trạng thái (Anti-pattern)
* **Thực trạng cũ:** Cột `is_active` (BOOLEAN) chỉ biểu diễn được 2 trạng thái (`TRUE` / `FALSE`).
* **Yêu cầu nghiệp vụ:** Lịch hẹn chuyển qua 5 trạng thái: `PENDING` -> `CONFIRMED` -> `CHECKED_IN` -> `COMPLETED` / `CANCELLED`.
* **Hậu quả:** Hệ thống không thể biết lịch hẹn đang ở bước nào trong quy trình, dẫn đến sai lệch luồng khám bệnh.

### 2. Thiếu hụt các trường quản lý tài chính và hủy lịch
* **Thực trạng cũ:** Bảng `Appointments` hoàn toàn không có cột lưu tiền cọc, phí phạt hay lý do hủy.
* **Yêu cầu nghiệp vụ:** Cần ghi nhận tiền cọc (`deposit_amount`), phí phạt (`penalty_fee`) khi hủy sau khi đã xác nhận, và lý do hủy (`cancel_reason`).
* **Hậu quả:** Không thể đối soát doanh thu, thất thoát tài chính và không theo dõi được nguyên nhân bệnh nhân bỏ khám.

### 3. Vắng mặt hoàn toàn bảng Đơn thuốc (`Prescriptions`)
* **Thực trạng cũ:** CSDL legacy không có bảng hay cấu trúc nào để lưu thông tin đơn thuốc.
* **Yêu cầu nghiệp vụ:** Khi lịch hẹn hoàn tất (`COMPLETED`), Bác sĩ kê đơn thuốc tương ứng với lịch hẹn đó.
* **Hậu quả:** Bác sĩ không thể lưu đơn thuốc lên hệ thống, tính năng cốt lõi của phòng khám bị tê liệt.
