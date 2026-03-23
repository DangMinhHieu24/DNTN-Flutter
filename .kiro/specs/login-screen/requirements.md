# Tài Liệu Yêu Cầu: Màn Hình Đăng Nhập

## Giới Thiệu

Màn hình đăng nhập là điểm vào chính của ứng dụng AI Learning Coach, được thiết kế theo triết lý "Mindful Curator" - một không gian học tập tối giản, sang trọng và tập trung. Màn hình này cung cấp nhiều phương thức xác thực (Email/Password, Google, Phone) với giao diện responsive tuân thủ design system "Nordic-Earth" và kiến trúc Clean Architecture.

## Thuật Ngữ

- **Login_Screen**: Màn hình đăng nhập chính của ứng dụng
- **Auth_Service**: Dịch vụ xác thực người dùng
- **Form_Validator**: Bộ kiểm tra tính hợp lệ của form đăng nhập
- **Navigation_Router**: Bộ điều hướng màn hình trong ứng dụng
- **Design_System**: Hệ thống thiết kế "Mindful Curator" với Nordic-Earth palette
- **Responsive_Layout**: Bố cục tự động điều chỉnh theo kích thước màn hình
- **Auth_State_Manager**: Quản lý trạng thái xác thực (BLoC/Cubit)
- **Email_Auth_Provider**: Nhà cung cấp xác thực qua Email/Password
- **Google_Auth_Provider**: Nhà cung cấp xác thực qua Google
- **Phone_Auth_Provider**: Nhà cung cấp xác thực qua số điện thoại
- **Branding_Section**: Phần giới thiệu thương hiệu (chỉ hiển thị trên desktop)
- **Login_Form**: Form nhập thông tin đăng nhập
- **Password_Visibility_Toggle**: Nút bật/tắt hiển thị mật khẩu
- **Social_Login_Buttons**: Các nút đăng nhập qua mạng xã hội/phương thức khác
- **Error_Display**: Hiển thị thông báo lỗi cho người dùng
- **Loading_Indicator**: Chỉ báo trạng thái đang xử lý
- **Organic_Background_Shapes**: Các hình dạng nền mờ với hiệu ứng blur
- **Bento_Cards**: Các thẻ thông tin theo phong cách bento grid

## Yêu Cầu

### Yêu Cầu 1: Hiển Thị Giao Diện Responsive

**User Story:** Là người dùng, tôi muốn màn hình đăng nhập hiển thị tối ưu trên mọi thiết bị, để tôi có thể đăng nhập dễ dàng từ mobile hoặc desktop.

#### Tiêu Chí Chấp Nhận


1. WHEN màn hình có chiều rộng nhỏ hơn 1024px, THE Responsive_Layout SHALL hiển thị layout 1 cột chỉ chứa Login_Form
2. WHEN màn hình có chiều rộng từ 1024px trở lên, THE Responsive_Layout SHALL hiển thị layout 2 cột với Branding_Section bên trái và Login_Form bên phải
3. THE Responsive_Layout SHALL căn giữa nội dung trên màn hình với max-width 1200px
4. THE Organic_Background_Shapes SHALL hiển thị 2 hình dạng mờ với blur effect ở góc trên-trái và dưới-phải
5. WHILE hiển thị trên mobile, THE Login_Form SHALL chiếm toàn bộ chiều rộng với padding 24px
6. WHILE hiển thị trên desktop, THE Branding_Section SHALL hiển thị logo "Mindful Curator", tiêu đề lớn, mô tả và 2 Bento_Cards

### Yêu Cầu 2: Xác Thực Qua Email và Password

**User Story:** Là người dùng, tôi muốn đăng nhập bằng email và mật khẩu, để tôi có thể truy cập tài khoản của mình một cách an toàn.

#### Tiêu Chí Chấp Nhận

1. THE Login_Form SHALL hiển thị input field cho email với icon mail bên trái
2. THE Login_Form SHALL hiển thị input field cho password với icon lock bên trái và Password_Visibility_Toggle bên phải
3. WHEN người dùng nhập email, THE Form_Validator SHALL kiểm tra định dạng email hợp lệ theo RFC 5322
4. WHEN người dùng nhập password, THE Form_Validator SHALL kiểm tra password có ít nhất 8 ký tự
5. WHEN người dùng nhấn nút "Đăng nhập" với thông tin hợp lệ, THE Auth_Service SHALL gửi yêu cầu xác thực đến Email_Auth_Provider
6. IF email hoặc password không hợp lệ, THEN THE Error_Display SHALL hiển thị thông báo lỗi cụ thể dưới input field tương ứng
7. WHEN xác thực thành công, THE Navigation_Router SHALL điều hướng đến màn hình chính
8. WHEN xác thực thất bại, THE Error_Display SHALL hiển thị thông báo "Email hoặc mật khẩu không chính xác"

### Yêu Cầu 3: Quản Lý Hiển Thị Mật Khẩu

**User Story:** Là người dùng, tôi muốn có thể bật/tắt hiển thị mật khẩu, để tôi có thể kiểm tra mật khẩu đã nhập đúng chưa.

#### Tiêu Chí Chấp Nhận

1. THE Password_Visibility_Toggle SHALL hiển thị icon "visibility" khi password đang ẩn
2. THE Password_Visibility_Toggle SHALL hiển thị icon "visibility_off" khi password đang hiện
3. WHEN người dùng nhấn Password_Visibility_Toggle lần đầu, THE Login_Form SHALL hiển thị password dạng text rõ ràng
4. WHEN người dùng nhấn Password_Visibility_Toggle lần thứ hai, THE Login_Form SHALL ẩn password dạng dấu chấm
5. THE Password_Visibility_Toggle SHALL duy trì trạng thái hiển thị trong suốt phiên nhập liệu

### Yêu Cầu 4: Xác Thực Qua Google

**User Story:** Là người dùng, tôi muốn đăng nhập bằng tài khoản Google, để tôi có thể truy cập nhanh chóng mà không cần tạo tài khoản mới.

#### Tiêu Chí Chấp Nhận

1. THE Social_Login_Buttons SHALL hiển thị nút "Google" với logo Google và text "Google"
2. WHEN người dùng nhấn nút Google, THE Auth_Service SHALL khởi tạo luồng OAuth 2.0 với Google_Auth_Provider
3. WHEN Google_Auth_Provider trả về token hợp lệ, THE Auth_Service SHALL tạo hoặc cập nhật thông tin người dùng
4. WHEN xác thực Google thành công, THE Navigation_Router SHALL điều hướng đến màn hình chính
5. IF người dùng hủy luồng OAuth, THEN THE Login_Screen SHALL giữ nguyên trạng thái không hiển thị lỗi
6. IF Google_Auth_Provider trả về lỗi, THEN THE Error_Display SHALL hiển thị thông báo "Không thể đăng nhập bằng Google. Vui lòng thử lại"

### Yêu Cầu 5: Xác Thực Qua Số Điện Thoại

**User Story:** Là người dùng, tôi muốn đăng nhập bằng số điện thoại, để tôi có thể sử dụng phương thức xác thực quen thuộc.

#### Tiêu Chí Chấp Nhận

1. THE Social_Login_Buttons SHALL hiển thị nút "Số điện thoại" với icon smartphone và text "Số điện thoại"
2. WHEN người dùng nhấn nút "Số điện thoại", THE Navigation_Router SHALL điều hướng đến màn hình nhập số điện thoại
3. WHEN Phone_Auth_Provider gửi OTP thành công, THE Navigation_Router SHALL điều hướng đến màn hình nhập OTP
4. WHEN người dùng nhập OTP đúng, THE Auth_Service SHALL xác thực và tạo session
5. WHEN xác thực phone thành công, THE Navigation_Router SHALL điều hướng đến màn hình chính
6. IF OTP không hợp lệ hoặc hết hạn, THEN THE Error_Display SHALL hiển thị thông báo lỗi phù hợp

### Yêu Cầu 6: Quản Lý Trạng Thái Loading

**User Story:** Là người dùng, tôi muốn thấy trạng thái đang xử lý khi đăng nhập, để tôi biết hệ thống đang làm việc.

#### Tiêu Chí Chấp Nhận

1. WHEN Auth_Service đang xử lý yêu cầu xác thực, THE Loading_Indicator SHALL hiển thị trên nút đăng nhập
2. WHILE Loading_Indicator đang hiển thị, THE Login_Form SHALL vô hiệu hóa tất cả input fields và buttons
3. WHEN Auth_Service hoàn thành xử lý, THE Loading_Indicator SHALL ẩn đi
4. THE Loading_Indicator SHALL sử dụng màu primary từ Design_System
5. IF quá trình xác thực vượt quá 30 giây, THEN THE Auth_Service SHALL timeout và hiển thị thông báo lỗi


### Yêu Cầu 7: Áp Dụng Design System "Mindful Curator"

**User Story:** Là người dùng, tôi muốn giao diện đăng nhập có thiết kế đẹp mắt và nhất quán, để tôi có trải nghiệm thẩm mỹ cao.

#### Tiêu Chí Chấp Nhận

1. THE Design_System SHALL sử dụng font chữ Be Vietnam Pro với các weight: Regular (400), Medium (500), Bold (700), ExtraBold (800)
2. THE Design_System SHALL sử dụng Nordic-Earth color palette với primary color #4a6549 và surface color #f9f9f7
3. THE Login_Form SHALL sử dụng background surface-container-low (#f4f4f2) với border-radius 16px
4. THE Login_Form SHALL có padding 32px trên mobile và 40px trên desktop
5. THE Login_Form SHALL sử dụng shadow-sm với blur 40-60px và opacity 4-8%
6. WHEN input field được focus, THE Login_Form SHALL hiển thị ghost border với primary color ở opacity 20%
7. THE Login_Form SHALL không sử dụng hard borders (1px solid) cho bất kỳ phần tử nào
8. THE nút "Đăng nhập" SHALL sử dụng gradient từ primary (#4a6549) đến primary-container (#8ba888) với góc 135 độ
9. THE nút "Đăng nhập" SHALL có border-radius full (9999px) và text màu on-primary (#ffffff)
10. WHEN người dùng hover nút "Đăng nhập", THE nút SHALL scale lên 1.02x với transition 200ms
11. THE input fields SHALL sử dụng background surface-container-highest (#e2e3e1) với border-radius 16px
12. THE Bento_Cards SHALL sử dụng border-radius 16px với padding 24px

### Yêu Cầu 8: Điều Hướng và Liên Kết

**User Story:** Là người dùng, tôi muốn có thể truy cập các chức năng liên quan như quên mật khẩu và đăng ký, để tôi có thể quản lý tài khoản của mình.

#### Tiêu Chí Chấp Nhận

1. THE Login_Form SHALL hiển thị link "Quên mật khẩu?" bên phải label "Mật khẩu"
2. WHEN người dùng nhấn "Quên mật khẩu?", THE Navigation_Router SHALL điều hướng đến màn hình khôi phục mật khẩu
3. THE Login_Screen SHALL hiển thị footer với text "Chưa có tài khoản?" và link "Đăng ký ngay"
4. WHEN người dùng nhấn "Đăng ký ngay", THE Navigation_Router SHALL điều hướng đến màn hình đăng ký
5. THE Login_Screen SHALL hiển thị các link "Privacy", "Terms", "Support" ở footer
6. WHEN người dùng nhấn link footer, THE Navigation_Router SHALL điều hướng đến trang tương ứng

### Yêu Cầu 9: Xử Lý Lỗi và Thông Báo

**User Story:** Là người dùng, tôi muốn nhận được thông báo lỗi rõ ràng khi có vấn đề, để tôi biết cách khắc phục.

#### Tiêu Chí Chấp Nhận

1. WHEN Form_Validator phát hiện email không hợp lệ, THE Error_Display SHALL hiển thị "Email không đúng định dạng" dưới input email
2. WHEN Form_Validator phát hiện password ngắn hơn 8 ký tự, THE Error_Display SHALL hiển thị "Mật khẩu phải có ít nhất 8 ký tự" dưới input password
3. WHEN Auth_Service trả về lỗi network, THE Error_Display SHALL hiển thị "Không có kết nối mạng. Vui lòng kiểm tra và thử lại"
4. WHEN Auth_Service trả về lỗi server, THE Error_Display SHALL hiển thị "Lỗi hệ thống. Vui lòng thử lại sau"
5. THE Error_Display SHALL sử dụng màu error (#ba1a1a) từ Design_System
6. THE Error_Display SHALL sử dụng font size 12px với font weight Medium (500)
7. WHEN lỗi được hiển thị, THE Error_Display SHALL tự động ẩn sau 5 giây hoặc khi người dùng sửa input
8. THE Error_Display SHALL hiển thị icon error bên trái text thông báo

### Yêu Cầu 10: Quản Lý Trạng Thái với BLoC

**User Story:** Là developer, tôi muốn state management được tổ chức tốt, để code dễ bảo trì và test.

#### Tiêu Chí Chấp Nhận

1. THE Auth_State_Manager SHALL sử dụng BLoC hoặc Cubit pattern
2. THE Auth_State_Manager SHALL quản lý các state: Initial, Loading, Authenticated, Unauthenticated, Error
3. WHEN người dùng submit form, THE Auth_State_Manager SHALL emit Loading state
4. WHEN xác thực thành công, THE Auth_State_Manager SHALL emit Authenticated state với user data
5. WHEN xác thực thất bại, THE Auth_State_Manager SHALL emit Error state với error message
6. THE Auth_State_Manager SHALL lưu trữ authentication token vào secure storage
7. THE Auth_State_Manager SHALL expose stream để UI có thể listen state changes

### Yêu Cầu 11: Kiến Trúc Clean Architecture

**User Story:** Là developer, tôi muốn code tuân thủ Clean Architecture, để dự án có cấu trúc rõ ràng và dễ mở rộng.

#### Tiêu Chí Chấp Nhận

1. THE Login_Screen SHALL được tổ chức theo 3 layers: Presentation, Domain, Data
2. THE Presentation layer SHALL chứa widgets, pages, và BLoC/Cubit
3. THE Domain layer SHALL chứa entities, use cases, và repository interfaces
4. THE Data layer SHALL chứa repository implementations, data sources, và models
5. THE Domain layer SHALL không phụ thuộc vào Presentation hoặc Data layers
6. THE Data layer SHALL implement repository interfaces từ Domain layer
7. THE Presentation layer SHALL chỉ giao tiếp với Domain layer qua use cases
8. THE Login_Screen SHALL sử dụng dependency injection để inject dependencies

### Yêu Cầu 12: Form Validation Realtime

**User Story:** Là người dùng, tôi muốn nhận phản hồi ngay lập tức khi nhập sai, để tôi có thể sửa lỗi trước khi submit.

#### Tiêu Chí Chấp Nhận

1. WHEN người dùng nhập email, THE Form_Validator SHALL validate realtime sau mỗi 500ms không có thay đổi
2. WHEN email hợp lệ, THE Login_Form SHALL hiển thị icon check màu primary bên phải input
3. WHEN email không hợp lệ, THE Login_Form SHALL hiển thị border màu error và error message
4. WHEN password hợp lệ, THE Login_Form SHALL hiển thị icon check màu primary bên phải input
5. THE Form_Validator SHALL không validate khi input đang rỗng
6. THE nút "Đăng nhập" SHALL bị disable khi có bất kỳ validation error nào
7. WHEN tất cả fields hợp lệ, THE nút "Đăng nhập" SHALL được enable với full opacity


### Yêu Cầu 13: Accessibility và Internationalization

**User Story:** Là người dùng khuyết tật hoặc người dùng quốc tế, tôi muốn ứng dụng hỗ trợ accessibility và đa ngôn ngữ, để tôi có thể sử dụng dễ dàng.

#### Tiêu Chí Chấp Nhận

1. THE Login_Form SHALL cung cấp semantic labels cho tất cả input fields
2. THE Login_Form SHALL hỗ trợ screen reader với proper ARIA labels
3. THE Login_Form SHALL hỗ trợ keyboard navigation với tab order hợp lý
4. THE Login_Form SHALL có contrast ratio tối thiểu 4.5:1 cho text
5. THE Login_Form SHALL hỗ trợ text scaling lên đến 200% mà không bị vỡ layout
6. THE Login_Screen SHALL hỗ trợ đa ngôn ngữ (Tiếng Việt, English) thông qua i18n
7. WHEN người dùng thay đổi ngôn ngữ hệ thống, THE Login_Screen SHALL tự động cập nhật text

### Yêu Cầu 14: Performance và Optimization

**User Story:** Là người dùng, tôi muốn màn hình đăng nhập load nhanh và mượt mà, để tôi có trải nghiệm tốt.

#### Tiêu Chí Chấp Nhận

1. THE Login_Screen SHALL render trong vòng 300ms trên thiết bị tầm trung
2. THE Login_Screen SHALL sử dụng lazy loading cho các assets không cần thiết ngay lập tức
3. THE Login_Screen SHALL cache Design_System tokens để tránh re-compute
4. THE Login_Screen SHALL sử dụng const constructors cho widgets không thay đổi
5. THE Login_Screen SHALL optimize rebuild bằng cách sử dụng BlocBuilder với buildWhen
6. THE Organic_Background_Shapes SHALL sử dụng CustomPainter thay vì image assets
7. THE Login_Screen SHALL có frame rate ổn định 60fps khi có animation

### Yêu Cầu 15: Security và Data Protection

**User Story:** Là người dùng, tôi muốn thông tin đăng nhập của tôi được bảo mật, để tôi yên tâm sử dụng ứng dụng.

#### Tiêu Chí Chấp Nhận

1. THE Login_Form SHALL không lưu password vào bất kỳ log nào
2. THE Auth_Service SHALL sử dụng HTTPS cho tất cả API calls
3. THE Auth_Service SHALL lưu authentication token vào Flutter Secure Storage
4. THE Auth_Service SHALL implement token refresh mechanism
5. THE Login_Form SHALL clear sensitive data khỏi memory sau khi xác thực
6. THE Auth_Service SHALL implement rate limiting để chống brute force (tối đa 5 lần thử trong 15 phút)
7. IF người dùng nhập sai 5 lần liên tiếp, THEN THE Auth_Service SHALL khóa tài khoản tạm thời 15 phút
8. THE Auth_Service SHALL hash password trước khi gửi lên server (nếu backend yêu cầu)

### Yêu Cầu 16: Testing và Quality Assurance

**User Story:** Là developer, tôi muốn có test coverage tốt, để đảm bảo chất lượng code và tránh regression bugs.

#### Tiêu Chí Chấp Nhận

1. THE Login_Screen SHALL có unit tests cho tất cả use cases với coverage tối thiểu 80%
2. THE Form_Validator SHALL có unit tests cho tất cả validation rules
3. THE Auth_State_Manager SHALL có unit tests cho tất cả state transitions
4. THE Login_Screen SHALL có widget tests cho tất cả UI components
5. THE Login_Screen SHALL có integration tests cho các luồng đăng nhập chính
6. THE tests SHALL sử dụng mock objects cho external dependencies
7. THE tests SHALL verify accessibility requirements

### Yêu Cầu 17: Animation và Micro-interactions

**User Story:** Là người dùng, tôi muốn có các animation mượt mà và tinh tế, để trải nghiệm sử dụng thú vị hơn.

#### Tiêu Chí Chấp Nhận

1. WHEN Login_Screen được load, THE Login_Form SHALL fade in với duration 400ms
2. WHEN người dùng focus vào input field, THE input SHALL có scale animation nhẹ (1.01x) với duration 200ms
3. WHEN người dùng hover nút đăng nhập, THE nút SHALL có shadow animation với duration 200ms
4. WHEN validation error xuất hiện, THE Error_Display SHALL slide down với duration 300ms
5. WHEN người dùng submit form thành công, THE Login_Screen SHALL fade out với duration 300ms trước khi navigate
6. THE Organic_Background_Shapes SHALL có subtle floating animation với duration 20 giây
7. THE animations SHALL sử dụng easing curves phù hợp (easeInOut, easeOut)

### Yêu Cầu 18: Offline Support và Error Recovery

**User Story:** Là người dùng, tôi muốn ứng dụng xử lý tốt khi mất kết nối, để tôi biết cách khắc phục.

#### Tiêu Chí Chấp Nhận

1. WHEN không có kết nối mạng, THE Login_Screen SHALL hiển thị banner thông báo "Không có kết nối mạng"
2. WHEN kết nối mạng được khôi phục, THE Login_Screen SHALL tự động ẩn banner và cho phép retry
3. THE Auth_Service SHALL implement exponential backoff cho retry logic
4. THE Auth_Service SHALL retry tối đa 3 lần với delay 1s, 2s, 4s
5. IF tất cả retry thất bại, THEN THE Error_Display SHALL hiển thị option "Thử lại" cho người dùng
6. THE Login_Screen SHALL cache Design_System assets để hiển thị UI ngay cả khi offline

### Yêu Cầu 19: Analytics và Monitoring

**User Story:** Là product owner, tôi muốn theo dõi hành vi người dùng trên màn hình đăng nhập, để tối ưu hóa conversion rate.

#### Tiêu Chí Chấp Nhận

1. WHEN Login_Screen được hiển thị, THE Auth_Service SHALL log event "login_screen_viewed"
2. WHEN người dùng nhấn nút "Đăng nhập", THE Auth_Service SHALL log event "login_attempted" với method "email"
3. WHEN xác thực thành công, THE Auth_Service SHALL log event "login_success" với method và duration
4. WHEN xác thực thất bại, THE Auth_Service SHALL log event "login_failed" với error type (không log sensitive data)
5. WHEN người dùng nhấn "Quên mật khẩu?", THE Auth_Service SHALL log event "forgot_password_clicked"
6. WHEN người dùng nhấn nút Google/Phone, THE Auth_Service SHALL log event "social_login_attempted" với provider
7. THE Auth_Service SHALL không log bất kỳ PII (email, password, phone) nào

### Yêu Cầu 20: Biometric Authentication Support (Optional)

**User Story:** Là người dùng, tôi muốn có thể đăng nhập bằng sinh trắc học, để truy cập nhanh hơn trong các lần sau.

#### Tiêu Chí Chấp Nhận

1. WHERE thiết bị hỗ trợ biometric, THE Login_Screen SHALL hiển thị option "Đăng nhập bằng sinh trắc học"
2. WHEN người dùng đăng nhập thành công lần đầu, THE Auth_Service SHALL hỏi "Bạn có muốn bật đăng nhập bằng sinh trắc học?"
3. WHEN người dùng đồng ý, THE Auth_Service SHALL lưu biometric credential vào secure storage
4. WHEN người dùng mở app lần sau, THE Login_Screen SHALL tự động hiển thị biometric prompt
5. WHEN biometric authentication thành công, THE Auth_Service SHALL tự động đăng nhập và navigate
6. IF biometric authentication thất bại, THEN THE Login_Screen SHALL fallback về form đăng nhập thông thường
7. THE Auth_Service SHALL cho phép người dùng tắt biometric authentication trong settings
