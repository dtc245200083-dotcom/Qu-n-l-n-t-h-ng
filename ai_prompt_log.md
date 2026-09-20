# Nhật Ký Sử Dụng AI (AI Prompt Log)
**Dự án:** Tái cấu trúc CSDL HealthSync  

---

## Prompt 1: Tìm hiểu về Anti-pattern của cột `is_active`
* **Nội dung Prompt:** "Trong thiết kế cơ sở dữ liệu quan hệ, tại sao việc dùng một cột is_active (kiểu TINYINT/BOOLEAN) để theo dõi vòng đời của một Đơn hàng/Lịch hẹn lại là một thiết kế tồi (Anti-pattern)? Tôi nên thay thế bằng cấu trúc nào?"
* **Kết quả nhận được:** AI giải thích kiểu BOOLEAN chỉ hỗ trợ 2 trạng thái Nhị phân, không theo dõi được luồng trạng thái phức tạp. Giải pháp là dùng kiểu `ENUM` hoặc tạo bảng riêng `AppointmentStatus`.

## Prompt 2: Lựa chọn kiểu dữ liệu tài chính
* **Nội dung Prompt:** "Khi thiết kế cột deposit_amount và penalty_fee trong MySQL phục vụ tính toán tài chính, tôi nên dùng kiểu dữ liệu FLOAT, DOUBLE hay DECIMAL? Tại sao?"
* **Kết quả nhận được:** AI phân tích rằng `FLOAT` và `DOUBLE` bị lỗi làm tròn dấu phẩy động (Floating-point precision issue). Cần dùng `DECIMAL(precision, scale)` để đảm bảo độ chính xác tuyệt đối cho tiền tệ.

## Prompt 3: Cú pháp ENUM trong MySQL
* **Nội dung Prompt:** "Hãy cho tôi xem cú pháp chuẩn trong MySQL để thêm một cột status với kiểu dữ liệu ENUM chứa các giá trị ('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') vào một bảng có sẵn."
* **Kết quả nhận được:** AI cung cấp cú pháp `ALTER TABLE Appointments ADD COLUMN status ENUM(...) DEFAULT 'PENDING';`.
