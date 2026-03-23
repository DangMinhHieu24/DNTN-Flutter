# 🎯 HƯỚNG DẪN SETUP BLOC - HOÀN CHỈNH

## 📁 CẤU TRÚC ĐÃ TẠO

```
packages/features/lib/auth/
├── data/
│   ├── models/
│   │   └── user_model.dart              # Model để convert JSON ↔ Entity
│   └── repositories/
│       └── auth_repository_impl.dart    # Implementation của repository (fake API)
├── domain/
│   ├── entities/
│   │   └── user.dart                    # Entity User (domain layer)
│   └── repositories/
│       └── auth_repository.dart         # Abstract repository interface
├── presentation/
│   ├── bloc/
│   │   ├── auth_bloc.dart               # BLoC chính - xử lý logic
│   │   ├── auth_event.dart              # Các events (LoginRequested, RegisterRequested...)
│   │   └── auth_state.dart              # Các states (Loading, Success, Error...)
│   ├── pages/
│   │   ├── login_page.dart              # Trang đăng nhập
│   │   └── register_page.dart           # Trang đăng ký (đã update)
│   └── widgets/
│       └── ...                          # Các widgets
└── di/
    └── auth_injection.dart              # Dependency Injection cho Auth module

packages/features/lib/core/
└── di/
    └── injection_container.dart         # Service Locator chính

packages/features/lib/home/
└── presentation/
    └── pages/
        └── home_page.dart               # Trang chủ sau khi đăng nhập

lib/
└── main.dart                            # Entry point (đã update với BLoC)
```

---

## 🔄 FLOW HOẠT ĐỘNG

### **1. User nhấn "Đăng ký ngay"**

```dart
// register_page.dart
GradientButton(
  onPressed: _handleRegister,  // ← Gọi function này
)

void _handleRegister() {
  if (_formKey.currentState!.validate()) {  // ← Validate form
    context.read<AuthBloc>().add(          // ← Dispatch event
      RegisterRequested(
        name: _nameController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
      ),
    );
  }
}
```

### **2. BLoC nhận event và xử lý**

```dart
// auth_bloc.dart
Future<void> _onRegisterRequested(
  RegisterRequested event,
  Emitter<AuthState> emit,
) async {
  emit(const AuthLoading());  // ← 1. Emit loading state
  
  final result = await authRepository.register(  // ← 2. Gọi repository
    name: event.name,
    phone: event.phone,
    password: event.password,
  );
  
  result.fold(
    (error) => emit(AuthError(error)),      // ← 3a. Nếu lỗi
    (user) => emit(AuthSuccess(user)),      // ← 3b. Nếu thành công
  );
}
```

### **3. Repository xử lý logic**

```dart
// auth_repository_impl.dart
@override
Future<Either<String, User>> register({
  required String name,
  required String phone,
  required String password,
}) async {
  await Future.delayed(const Duration(seconds: 2));  // ← Fake network delay
  
  // Check phone đã tồn tại chưa
  if (_fakeUsers.where((u) => u.phone == phone).isNotEmpty) {
    return const Left('Số điện thoại đã được đăng ký');  // ← Error
  }
  
  // Tạo user mới
  final newUser = UserModel(...);
  _fakeUsers.add(newUser);
  
  return Right(newUser);  // ← Success
}
```

### **4. UI listen state changes và react**

```dart
// register_page.dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // ← Navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (state is AuthError) {
      // ← Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: ...
)

// Loading state
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    final isLoading = state is AuthLoading;  // ← Check loading
    return GradientButton(
      isLoading: isLoading,  // ← Show spinner
      ...
    );
  },
)
```

---

## 🎨 CÁC STATES

```dart
AuthInitial()           // Trạng thái ban đầu
AuthLoading()           // Đang xử lý (show loading spinner)
AuthSuccess(user)       // Thành công (có user data)
AuthError(message)      // Có lỗi (show error message)
AuthUnauthenticated()   // Chưa đăng nhập
AuthLoggedOut()         // Đã đăng xuất
```

---

## 🎯 CÁC EVENTS

```dart
LoginRequested(phone, password)           // User muốn đăng nhập
RegisterRequested(name, phone, password)  // User muốn đăng ký
LogoutRequested()                         // User muốn đăng xuất
CheckAuthStatus()                         // Check xem đã login chưa
```

---

## ✅ VALIDATION

### **Họ tên:**
- Không được rỗng
- Ít nhất 2 ký tự

### **Số điện thoại:**
- Không được rỗng
- Format: 0xxxxxxxxx hoặc +84xxxxxxxxx (10 số)

### **Mật khẩu:**
- Không được rỗng
- Ít nhất 6 ký tự

### **Nhập lại mật khẩu:**
- Phải khớp với mật khẩu

---

## 🚀 CÁCH CHẠY

### **1. Chạy app:**
```bash
flutter run
```

### **2. Test flow đăng ký:**
1. Mở app → Thấy Login Page
2. Click "Đăng ký ngay" → Navigate to Register Page
3. Nhập thông tin:
   - Họ tên: Nguyễn Văn A
   - Số điện thoại: 0901234567
   - Mật khẩu: 123456
   - Nhập lại: 123456
4. Click "Đăng ký ngay"
5. Thấy loading spinner 2 giây
6. Navigate to Home Page
7. Thấy thông tin user

### **3. Test validation:**
- Để trống field → Thấy error message
- Nhập phone sai format → Thấy error
- Password không khớp → Thấy error

### **4. Test logout:**
- Ở Home Page, click icon logout
- Confirm dialog
- Navigate back to Login Page

---

## 🔧 DEPENDENCY INJECTION

### **Setup trong main.dart:**
```dart
void main() async {
  await initializeDependencies();  // ← Initialize GetIt
  runApp(const MyApp());
}
```

### **Đăng ký dependencies:**
```dart
// injection_container.dart
AuthInjection.init(sl);

// auth_injection.dart
sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
sl.registerFactory(() => AuthBloc(authRepository: sl()));
```

### **Sử dụng:**
```dart
// main.dart
BlocProvider(
  create: (context) => sl<AuthBloc>(),  // ← Lấy từ GetIt
  child: MaterialApp(...),
)
```

---

## 📝 NEXT STEPS

### **Bước tiếp theo bạn có thể làm:**

1. **Update LoginPage tương tự RegisterPage**
   - Add validation
   - Connect với BLoC
   - Navigate to Home on success

2. **Thêm Remember Me feature**
   - Save auth state vào SharedPreferences
   - Auto login khi mở app

3. **Thêm các Auth Pages khác:**
   - Forgot Password Page
   - OTP Verification Page
   - Reset Password Page

4. **Connect với API thật:**
   - Thay AuthRepositoryImpl bằng API calls
   - Sử dụng Dio để gọi API
   - Handle network errors

5. **Xây dựng Home Page đầy đủ:**
   - Navigation drawer/bottom nav
   - Các features chính của app

---

## 🎓 KIẾN THỨC ĐÃ HỌC

✅ **Clean Architecture** - Tách biệt layers (domain, data, presentation)
✅ **BLoC Pattern** - State management với events và states
✅ **Dependency Injection** - Sử dụng GetIt service locator
✅ **Form Validation** - Validate user input
✅ **Error Handling** - Xử lý và hiển thị errors
✅ **Navigation** - Navigate giữa các pages
✅ **Either Type** - Functional programming với dartz

---

## 💡 TÓM TẮT

**Bạn đã có:**
- ✅ Auth flow hoàn chỉnh (Register → Home)
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Clean Architecture structure
- ✅ BLoC pattern
- ✅ Dependency Injection

**Giờ bạn có thể:**
- ✅ Đăng ký tài khoản mới
- ✅ Thấy loading khi xử lý
- ✅ Thấy error nếu có lỗi
- ✅ Navigate to Home khi thành công
- ✅ Logout và quay về Login

**Foundation vững chắc để:**
- 🚀 Build các features khác
- 🚀 Scale app lên
- 🚀 Maintain code dễ dàng
- 🚀 Work trong team

---

Chúc mừng! Bạn đã setup thành công BLoC pattern với Clean Architecture! 🎉
