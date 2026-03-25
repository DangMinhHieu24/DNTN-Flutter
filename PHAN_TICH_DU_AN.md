# 📚 PHÂN TÍCH CHI TIẾT DỰ ÁN AI LEARNING COACH

## 🎯 TỔNG QUAN DỰ ÁN

**Tên dự án:** AI Learning Coach - Mindful Curator Package Module  
**Framework:** Flutter  
**Kiến trúc:** Clean Architecture + BLoC Pattern  
**Cấu trúc:** Package Module (Monorepo)

---

## 🏗️ KIẾN TRÚC TỔNG QUAN

### Cấu trúc thư mục chính:
```
app_hoctap/
├── lib/                    # App chính
│   ├── main.dart          # Entry point
│   ├── config/            # Cấu hình (routes, theme)
│   └── di/                # Dependency Injection
│
└── packages/              # Các module độc lập
    ├── core/              # Shared utilities
    │   ├── network/       # API client, endpoints
    │   ├── error/         # Error handling
    │   ├── theme/         # UI theme
    │   ├── widgets/       # Reusable widgets
    │   └── usecases/      # Base UseCase
    │
    └── features/          # Các tính năng
        └── auth/          # Authentication feature
            ├── data/      # Data Layer
            ├── domain/    # Domain Layer
            └── presentation/ # Presentation Layer
```

---

## 🔄 CLEAN ARCHITECTURE - 3 LAYERS

### 1️⃣ PRESENTATION LAYER (UI + State Management)
**Nhiệm vụ:** Hiển thị UI và xử lý user interactions

**Thành phần:**
- **Pages:** Các màn hình (LoginPage, RegisterPage, HomePage)
- **Widgets:** UI components tái sử dụng
- **BLoC:** Quản lý state và business logic

**Ví dụ LoginPage:**
```dart
// User nhập phone + password
// Click "Đăng nhập"
context.read<AuthBloc>().add(
  LoginRequested(phone: phone, password: password)
);

// Listen state changes
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // Navigate to Home
    } else if (state is AuthError) {
      // Show error
    }
  }
)
```

---

### 2️⃣ DOMAIN LAYER (Business Logic Core)
**Nhiệm vụ:** Chứa business logic thuần túy, không phụ thuộc framework

**Thành phần:**
- **Entities:** Đối tượng nghiệp vụ (UserEntity)
- **Repositories (Interface):** Contract cho data operations
- **UseCases:** Các use case cụ thể (LoginUseCase, RegisterUseCase)

**Đặc điểm:**
- ✅ Không import Flutter
- ✅ Không import Dio, SharedPreferences
- ✅ Chỉ chứa logic nghiệp vụ
- ✅ Dễ test, dễ maintain

**Ví dụ LoginUseCase:**
```dart
class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  
  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(
      phone: params.phone,
      password: params.password,
    );
  }
}
```

---

### 3️⃣ DATA LAYER (Data Management)
**Nhiệm vụ:** Quản lý dữ liệu từ nhiều nguồn (API, Cache, Database)

**Thành phần:**
- **Models:** Data models với JSON serialization
- **Repositories (Implementation):** Implement interface từ Domain
- **DataSources:** 
  - Remote: Gọi API
  - Local: Cache với SharedPreferences

**Ví dụ AuthRepositoryImpl:**
```dart
@override
Future<Either<Failure, UserEntity>> login({
  required String phone,
  required String password,
}) async {
  try {
    // 1. Gọi API
    final authResponse = await remoteDataSource.login(
      phone: phone,
      password: password,
    );
    
    // 2. Lưu token vào ApiClient
    apiClient.setAuthToken(authResponse.accessToken);
    
    // 3. Cache user data
    await localDataSource.cacheUser(authResponse.user);
    await localDataSource.saveAccessToken(authResponse.accessToken);
    
    // 4. Trả về Entity
    return Right(authResponse.user.toEntity());
  } on AuthException catch (e) {
    return Left(AuthFailure(message: e.message));
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  }
}
```

---

## 🔥 BLOC PATTERN - STATE MANAGEMENT

### Các thành phần:

#### 1. **Events** (User Actions)
```dart
// User muốn đăng nhập
class LoginRequested extends AuthEvent {
  final String phone;
  final String password;
}

// User muốn đăng xuất
class LogoutRequested extends AuthEvent {}

// Kiểm tra session khi app start
class AuthCheckRequested extends AuthEvent {}
```

#### 2. **States** (UI States)
```dart
// Trạng thái ban đầu
class AuthInitial extends AuthState {}

// Đang xử lý
class AuthLoading extends AuthState {}

// Thành công
class AuthSuccess extends AuthState {
  final UserEntity user;
}

// Lỗi
class AuthError extends AuthState {
  final String message;
}

// Chưa đăng nhập
class AuthUnauthenticated extends AuthState {}
```

#### 3. **BLoC** (Business Logic Component)
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  
  AuthBloc({required this.loginUseCase}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
  
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // 1. Emit loading
    emit(AuthLoading());
    
    // 2. Gọi UseCase
    final result = await loginUseCase(
      LoginParams(phone: event.phone, password: event.password)
    );
    
    // 3. Xử lý kết quả
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }
}
```

---

## 🌊 LUỒNG DỮ LIỆU HOÀN CHỈNH - LOGIN FLOW

### Bước 1: User nhập thông tin và click "Đăng nhập"
**File:** `packages/features/lib/auth/presentation/pages/login_page.dart`
```dart
void _handleLogin() {
  final phone = _emailController.text.trim();
  final password = _passwordController.text;
  
  // Dispatch event
  context.read<AuthBloc>().add(
    LoginRequested(phone: phone, password: password)
  );
}
```

### Bước 2: AuthBloc nhận event
**File:** `packages/features/lib/auth/presentation/bloc/auth_bloc.dart`
```dart
Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<AuthState> emit,
) async {
  // Emit loading state
  emit(AuthLoading());
  
  // Gọi LoginUseCase
  final result = await loginUseCase(
    LoginParams(phone: event.phone, password: event.password)
  );
  
  // Xử lý kết quả
  result.fold(
    (failure) => emit(AuthError(message: failure.message)),
    (user) => emit(AuthSuccess(user: user)),
  );
}
```

### Bước 3: LoginUseCase xử lý
**File:** `packages/features/lib/auth/domain/usecases/login_usecase.dart`
```dart
@override
Future<Either<Failure, UserEntity>> call(LoginParams params) {
  // Gọi Repository
  return repository.login(
    phone: params.phone,
    password: params.password,
  );
}
```

### Bước 4: AuthRepository xử lý
**File:** `packages/features/lib/auth/data/repositories/auth_repository_impl.dart`
```dart
@override
Future<Either<Failure, UserEntity>> login({
  required String phone,
  required String password,
}) async {
  try {
    // 4.1: Gọi Remote DataSource (API)
    final authResponse = await remoteDataSource.login(
      phone: phone,
      password: password,
    );
    
    // 4.2: Lưu token vào ApiClient
    apiClient.setAuthToken(authResponse.accessToken);
    
    // 4.3: Cache user data và tokens
    await localDataSource.cacheUser(authResponse.user);
    await localDataSource.saveAccessToken(authResponse.accessToken);
    
    // 4.4: Trả về UserEntity
    return Right(authResponse.user.toEntity());
  } catch (e) {
    return Left(AuthFailure(message: e.message));
  }
}
```

### Bước 5: AuthRemoteDataSource gọi API
**File:** `packages/features/lib/auth/data/datasources/auth_remote_datasource.dart`
```dart
@override
Future<AuthResponseModel> login({
  required String phone,
  required String password,
}) async {
  // Gọi ApiClient
  final response = await apiClient.post(
    ApiEndpoints.login,  // '/api/auth/login'
    data: {
      'phone': phone,
      'password': password,
    },
  );
  
  // Parse response
  return AuthResponseModel.fromJson(response.data);
}
```

### Bước 6: ApiClient gửi HTTP request
**File:** `packages/core/lib/network/api_client.dart`
```dart
Future<Response> post(String path, {dynamic data}) async {
  try {
    final response = await _dio.post(path, data: data);
    return response;
  } on DioException catch (e) {
    throw _handleDioError(e);
  }
}
```

### Bước 7: Server trả về response
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "123",
      "name": "Nguyễn Văn A",
      "phone": "0123456789",
      "email": "user@example.com"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Bước 8: UI nhận state và cập nhật
**File:** `packages/features/lib/auth/presentation/pages/login_page.dart`
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      // Navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else if (state is AuthError) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }
)
```

---

## 🔌 DEPENDENCY INJECTION VỚI GETIT

### Tại sao cần Dependency Injection?
1. **Loose Coupling:** Các class không phụ thuộc trực tiếp vào nhau
2. **Testability:** Dễ dàng mock dependencies khi test
3. **Maintainability:** Thay đổi implementation không ảnh hưởng code khác
4. **Single Responsibility:** Mỗi class chỉ lo việc của mình

### Cách hoạt động:

#### 1. Đăng ký dependencies (trong `auth_injection.dart`)
```dart
// Factory - Tạo mới mỗi lần gọi
sl.registerFactory(() => AuthBloc(
  loginUseCase: sl(),
  registerUseCase: sl(),
  logoutUseCase: sl(),
  getCurrentUserUseCase: sl(),
));

// Lazy Singleton - Tạo 1 lần, dùng chung
sl.registerLazySingleton(() => LoginUseCase(sl()));
sl.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    apiClient: sl(),
  )
);
```

#### 2. Sử dụng dependencies
```dart
// Trong main.dart
BlocProvider(
  create: (context) => sl<AuthBloc>(),  // GetIt tự động inject
  child: MaterialApp(...)
)

// Trong test
final mockRepository = MockAuthRepository();
sl.registerFactory<AuthRepository>(() => mockRepository);
```

### Dependency Graph:
```
AuthBloc
  ├─→ LoginUseCase
  │     └─→ AuthRepository
  │           ├─→ AuthRemoteDataSource
  │           │     └─→ ApiClient
  │           ├─→ AuthLocalDataSource
  │           │     └─→ SharedPreferences
  │           └─→ ApiClient
  ├─→ RegisterUseCase
  ├─→ LogoutUseCase
  └─→ GetCurrentUserUseCase
```

---

## 🛣️ ROUTING VỚI GO_ROUTER

### Cấu hình routes:
```dart
static final GoRouter router = GoRouter(
  initialLocation: '/',  // Splash screen
  routes: [
    GoRoute(path: '/', name: 'splash', builder: (_) => SplashPage()),
    GoRoute(path: '/login', name: 'login', builder: (_) => LoginPage()),
    GoRoute(path: '/register', name: 'register', builder: (_) => RegisterPage()),
    GoRoute(path: '/home', name: 'home', builder: (_) => HomePage()),
  ],
);
```

### Navigation flow:
```
App Start
  ↓
SplashPage (dispatch AuthCheckRequested)
  ↓
AuthBloc check session
  ├─→ Có session → emit AuthSuccess → context.go('/home')
  └─→ Không có → emit AuthUnauthenticated → context.go('/login')

LoginPage
  ↓
User login thành công
  ↓
emit AuthSuccess → context.go('/home')

HomePage
  ↓
User logout
  ↓
emit AuthUnauthenticated → context.go('/login')
```

---

## 🎨 THEME SYSTEM

### Cấu trúc:
```
packages/core/lib/theme/
├── app_colors.dart       # Màu sắc
├── app_text_styles.dart  # Typography
├── app_dimensions.dart   # Spacing, sizes
└── app_theme.dart        # Theme tổng hợp
```

### Sử dụng:
```dart
// Colors
Container(color: AppColors.primary)
Text(style: TextStyle(color: AppColors.onSurface))

// Text Styles
Text('Title', style: AppTextStyles.displayLarge)
Text('Body', style: AppTextStyles.bodyMedium)

// Dimensions
SizedBox(height: AppDimensions.spacing16)
Padding(padding: EdgeInsets.all(AppDimensions.padding24))
```

---

## 🧪 ERROR HANDLING

### Exception Hierarchy:
```dart
// Trong Data Layer
try {
  final response = await apiClient.post(...);
} on DioException catch (e) {
  // Network errors, timeouts
  throw NetworkException(message: 'Không có kết nối');
} on ServerException catch (e) {
  // Server errors (500, 502, etc.)
  throw ServerException(message: 'Lỗi máy chủ');
} on AuthException catch (e) {
  // Auth errors (401, 403)
  throw AuthException(message: 'Phiên đăng nhập hết hạn');
}
```

### Failure Handling:
```dart
// Trong Repository
try {
  final result = await remoteDataSource.login(...);
  return Right(result);
} on AuthException catch (e) {
  return Left(AuthFailure(message: e.message));
} on NetworkException catch (e) {
  return Left(NetworkFailure(message: e.message));
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message));
}
```

### UI Error Display:
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
)
```

---

## 📦 MODELS VS ENTITIES

### Entity (Domain Layer):
```dart
// Không có JSON serialization
// Chỉ chứa business data
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String phone;
  
  const UserEntity({
    required this.id,
    required this.name,
    required this.phone,
  });
}
```

### Model (Data Layer):
```dart
// Có JSON serialization
// Kế thừa từ Entity
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.phone,
  });
  
  // Parse từ JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }
  
  // Convert sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
    };
  }
  
  // Convert sang Entity
  UserEntity toEntity() => this;
}
```

---

## 🔐 TOKEN MANAGEMENT

### Lưu tokens:
```dart
// Trong AuthRepositoryImpl
await localDataSource.saveAccessToken(authResponse.accessToken);
await localDataSource.saveRefreshToken(authResponse.refreshToken);
apiClient.setAuthToken(authResponse.accessToken);
```

### Sử dụng tokens:
```dart
// ApiClient tự động thêm vào headers
void setAuthToken(String token) {
  _dio.options.headers['Authorization'] = 'Bearer $token';
}
```

### Refresh token flow:
```dart
Future<Either<Failure, void>> refreshAccessToken() async {
  final refreshToken = await localDataSource.getRefreshToken();
  final authResponse = await remoteDataSource.refreshToken(refreshToken);
  
  apiClient.setAuthToken(authResponse.accessToken);
  await localDataSource.saveAccessToken(authResponse.accessToken);
  
  return Right(null);
}
```

---

## 📝 NHIỆM VỤ HỌC TẬP CHO BẠN

### ✅ Nhiệm vụ 1: Trace Login Flow
1. Đặt breakpoints ở các file:
   - `login_page.dart` → `_handleLogin()`
   - `auth_bloc.dart` → `_onLoginRequested()`
   - `login_usecase.dart` → `call()`
   - `auth_repository_impl.dart` → `login()`
   - `auth_remote_datasource.dart` → `login()`

2. Run app và login, quan sát luồng dữ liệu

### ✅ Nhiệm vụ 2: Thêm tính năng "Remember Me"
1. Thêm checkbox "Ghi nhớ đăng nhập" vào LoginPage
2. Lưu flag vào SharedPreferences
3. Khi AuthCheck, nếu không có "remember me" → logout

### ✅ Nhiệm vụ 3: Implement Forgot Password
1. Tạo `ForgotPasswordPage`
2. Tạo `ForgotPasswordUseCase`
3. Thêm route `/forgot-password`
4. Implement UI và logic

### ✅ Nhiệm vụ 4: Thêm Loading State cho Button
1. Khi đang login, disable button
2. Hiển thị CircularProgressIndicator trong button
3. Hint: Dùng `state is AuthLoading`

### ✅ Nhiệm vụ 5: Implement Token Refresh
1. Thêm interceptor vào ApiClient
2. Khi nhận 401 → gọi `refreshAccessToken()`
3. Retry request với token mới
4. Nếu refresh fail → logout

### ✅ Nhiệm vụ 6: Viết Unit Tests
1. Test LoginUseCase với mock repository
2. Test AuthBloc với mock use cases
3. Test AuthRepositoryImpl với mock data sources

---

## 🎓 CÁC KHÁI NIỆM QUAN TRỌNG

### 1. Either<Failure, Success> (Dartz)
```dart
// Thay vì throw exception
try {
  return user;
} catch (e) {
  throw Exception(e);
}

// Dùng Either để handle cả 2 cases
Either<Failure, User> result = await repository.login();
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (user) => print('Success: ${user.name}'),
);
```

### 2. Equatable
```dart
// Để so sánh objects
class User extends Equatable {
  final String id;
  final String name;
  
  @override
  List<Object> get props => [id, name];
}

// Bây giờ có thể so sánh:
User user1 = User(id: '1', name: 'A');
User user2 = User(id: '1', name: 'A');
print(user1 == user2);  // true
```

### 3. Factory vs Singleton
```dart
// Factory - Tạo mới mỗi lần
sl.registerFactory(() => AuthBloc());
final bloc1 = sl<AuthBloc>();
final bloc2 = sl<AuthBloc>();
print(bloc1 == bloc2);  // false

// Singleton - Dùng chung 1 instance
sl.registerLazySingleton(() => LoginUseCase());
final useCase1 = sl<LoginUseCase>();
final useCase2 = sl<LoginUseCase>();
print(useCase1 == useCase2);  // true
```

---

## 🚀 TIPS & BEST PRACTICES

### 1. Luôn dispose controllers
```dart
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
```

### 2. Validate input trước khi dispatch event
```dart
void _handleLogin() {
  if (_emailController.text.isEmpty) {
    showError('Email không được để trống');
    return;
  }
  context.read<AuthBloc>().add(LoginRequested(...));
}
```

### 3. Dùng const khi có thể
```dart
const SizedBox(height: 16)  // ✅ Tốt
SizedBox(height: 16)         // ❌ Không tối ưu
```

### 4. Tách widget phức tạp thành widget riêng
```dart
// ❌ Không tốt
Widget build(BuildContext context) {
  return Column(
    children: [
      // 100 dòng code UI phức tạp
    ],
  );
}

// ✅ Tốt
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),
      _buildForm(),
      _buildFooter(),
    ],
  );
}
```

### 5. Sử dụng BlocConsumer khi cần cả listener và builder
```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Side effects: navigation, snackbar
  },
  builder: (context, state) {
    // UI rebuild
  },
)
```

---

## 📚 TÀI LIỆU THAM KHẢO

1. **Clean Architecture:** https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
2. **BLoC Pattern:** https://bloclibrary.dev
3. **Dartz (Functional Programming):** https://pub.dev/packages/dartz
4. **GetIt (DI):** https://pub.dev/packages/get_it
5. **GoRouter:** https://pub.dev/packages/go_router

---

Bạn muốn tôi giải thích chi tiết phần nào? Hoặc bạn muốn thực hành một nhiệm vụ cụ thể?
