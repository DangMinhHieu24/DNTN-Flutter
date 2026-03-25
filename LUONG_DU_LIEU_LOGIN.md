# 🔄 LUỒNG DỮ LIỆU CHI TIẾT - LOGIN FLOW

## 📊 SƠ ĐỒ TỔNG QUAN

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                          │
│  ┌──────────────┐         ┌──────────────┐         ┌─────────────┐ │
│  │  LoginPage   │────────▶│   AuthBloc   │────────▶│  AuthState  │ │
│  │   (UI)       │◀────────│ (BLoC Logic) │◀────────│  (States)   │ │
│  └──────────────┘         └──────────────┘         └─────────────┘ │
│         │                         │                                 │
│         │ dispatch event          │ call usecase                    │
│         ▼                         ▼                                 │
└─────────────────────────────────────────────────────────────────────┘
                                    │
┌─────────────────────────────────────────────────────────────────────┐
│                          DOMAIN LAYER                               │
│                    ┌──────────────────┐                             │
│                    │  LoginUseCase    │                             │
│                    │ (Business Logic) │                             │
│                    └──────────────────┘                             │
│                            │                                        │
│                            │ call repository                        │
│                            ▼                                        │
│                    ┌──────────────────┐                             │
│                    │  AuthRepository  │                             │
│                    │   (Interface)    │                             │
│                    └──────────────────┘                             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
┌─────────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                                │
│  ┌──────────────────────┐         ┌──────────────────────┐         │
│  │ AuthRepositoryImpl   │────────▶│ AuthRemoteDataSource │         │
│  │  (Implementation)    │         │    (API Calls)       │         │
│  └──────────────────────┘         └──────────────────────┘         │
│            │                                  │                     │
│            │                                  │                     │
│            ▼                                  ▼                     │
│  ┌──────────────────────┐         ┌──────────────────────┐         │
│  │ AuthLocalDataSource  │         │     ApiClient        │         │
│  │   (Cache/Storage)    │         │   (HTTP Client)      │         │
│  └──────────────────────┘         └──────────────────────┘         │
│            │                                  │                     │
│            ▼                                  ▼                     │
│  ┌──────────────────────┐         ┌──────────────────────┐         │
│  │  SharedPreferences   │         │    Backend API       │         │
│  │   (Local Storage)    │         │  (Server/Database)   │         │
│  └──────────────────────┘         └──────────────────────┘         │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🎬 TIMELINE - TỪNG BƯỚC CHI TIẾT

### ⏱️ T = 0ms: User nhập thông tin và click "Đăng nhập"

**File:** `packages/features/lib/auth/presentation/pages/login_page.dart`

```dart
// User action
void _handleLogin() {
  final phone = _emailController.text.trim();      // "0123456789"
  final password = _passwordController.text;       // "password123"
  
  // Validate
  if (phone.isEmpty || password.isEmpty) {
    showError('Vui lòng nhập đầy đủ thông tin');
    return;
  }
  
  // Dispatch event đến BLoC
  context.read<AuthBloc>().add(
    LoginRequested(
      phone: phone,
      password: password,
    ),
  );
}
```

**Dữ liệu:**
```dart
LoginRequested {
  phone: "0123456789",
  password: "password123"
}
```

---

### ⏱️ T = 1ms: AuthBloc nhận event

**File:** `packages/features/lib/auth/presentation/bloc/auth_bloc.dart`

```dart
Future<void> _onLoginRequested(
  LoginRequested event,
  Emitter<AuthState> emit,
) async {
  // BƯỚC 1: Emit loading state
  print('📤 Emitting: AuthLoading');
  emit(const AuthLoading());
  
  // UI sẽ hiển thị loading indicator
  // Button "Đăng nhập" sẽ disabled
  
  // BƯỚC 2: Gọi LoginUseCase
  print('📞 Calling LoginUseCase...');
  final result = await loginUseCase(
    LoginParams(
      phone: event.phone,      // "0123456789"
      password: event.password, // "password123"
    ),
  );
  
  // BƯỚC 3: Xử lý kết quả (sẽ xử lý sau khi có response)
  // ...
}
```

**State hiện tại:** `AuthLoading`

**UI hiển thị:**
- Loading indicator trong button
- Button disabled
- Có thể có overlay loading

---

### ⏱️ T = 2ms: LoginUseCase xử lý

**File:** `packages/features/lib/auth/domain/usecases/login_usecase.dart`

```dart
@override
Future<Either<Failure, UserEntity>> call(LoginParams params) {
  print('🎯 LoginUseCase: Calling repository.login()');
  print('   Phone: ${params.phone}');
  print('   Password: ${params.password}');
  
  // Gọi repository
  return repository.login(
    phone: params.phone,
    password: params.password,
  );
}
```

**Dữ liệu truyền xuống:**
```dart
phone: "0123456789"
password: "password123"
```

---

### ⏱️ T = 3ms: AuthRepositoryImpl xử lý

**File:** `packages/features/lib/auth/data/repositories/auth_repository_impl.dart`

```dart
@override
Future<Either<Failure, UserEntity>> login({
  required String phone,
  required String password,
}) async {
  try {
    print('🏪 Repository: Calling remoteDataSource.login()');
    
    // Gọi API
    final authResponse = await remoteDataSource.login(
      phone: phone,
      password: password,
    );
    
    // Sẽ xử lý response sau...
  } catch (e) {
    // Error handling
  }
}
```

---

### ⏱️ T = 5ms: AuthRemoteDataSource gọi API

**File:** `packages/features/lib/auth/data/datasources/auth_remote_datasource.dart`

```dart
@override
Future<AuthResponseModel> login({
  required String phone,
  required String password,
}) async {
  print('🌐 RemoteDataSource: Calling API...');
  print('   Endpoint: ${ApiEndpoints.login}');
  print('   Method: POST');
  
  final response = await apiClient.post(
    ApiEndpoints.login,  // '/api/auth/login'
    data: {
      'phone': phone,
      'password': password,
    },
  );
  
  // Parse response sau...
}
```

**HTTP Request:**
```http
POST https://api.example.com/api/auth/login
Content-Type: application/json

{
  "phone": "0123456789",
  "password": "password123"
}
```

---

### ⏱️ T = 10ms: ApiClient gửi HTTP request

**File:** `packages/core/lib/network/api_client.dart`

```dart
Future<Response> post(String path, {dynamic data}) async {
  try {
    print('🚀 ApiClient: Sending POST request');
    print('   URL: ${_dio.options.baseUrl}$path');
    print('   Data: $data');
    
    final response = await _dio.post(path, data: data);
    
    print('✅ ApiClient: Response received');
    print('   Status: ${response.statusCode}');
    
    return response;
  } on DioException catch (e) {
    print('❌ ApiClient: Error occurred');
    throw _handleDioError(e);
  }
}
```

**Network Activity:**
```
🌐 Sending HTTP request...
   → DNS lookup
   → TCP connection
   → TLS handshake
   → Send request
   → Wait for response...
```

---

### ⏱️ T = 500ms: Server xử lý và trả về response

**Backend Processing:**
1. Nhận request
2. Validate phone + password
3. Query database
4. Verify password hash
5. Generate JWT tokens
6. Return response

**HTTP Response:**
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "success": true,
  "message": "Đăng nhập thành công",
  "data": {
    "user": {
      "id": "user_123",
      "name": "Nguyễn Văn A",
      "phone": "0123456789",
      "email": "user@example.com",
      "avatar_url": "https://example.com/avatar.jpg",
      "created_at": "2024-01-01T00:00:00Z"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzEyMyIsImlhdCI6MTYxNjIzOTAyMn0.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzEyMyIsInR5cCI6InJlZnJlc2gifQ.4pcPyMD09olPSyXnrXCjTwXyr4BsezdI1AVTmud2fU4"
  }
}
```

---

### ⏱️ T = 510ms: AuthRemoteDataSource parse response

**File:** `packages/features/lib/auth/data/datasources/auth_remote_datasource.dart`

```dart
@override
Future<AuthResponseModel> login(...) async {
  final response = await apiClient.post(...);
  
  print('📦 RemoteDataSource: Parsing response');
  
  // Parse JSON thành Model
  final authResponse = AuthResponseModel.fromJson(response.data);
  
  print('✅ Parsed successfully');
  print('   User ID: ${authResponse.user.id}');
  print('   User Name: ${authResponse.user.name}');
  print('   Access Token: ${authResponse.accessToken.substring(0, 20)}...');
  
  return authResponse;
}
```

**Dữ liệu:**
```dart
AuthResponseModel {
  user: UserModel {
    id: "user_123",
    name: "Nguyễn Văn A",
    phone: "0123456789",
    email: "user@example.com",
    avatarUrl: "https://example.com/avatar.jpg",
    createdAt: DateTime(2024, 1, 1)
  },
  accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  refreshToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### ⏱️ T = 515ms: AuthRepositoryImpl xử lý response

**File:** `packages/features/lib/auth/data/repositories/auth_repository_impl.dart`

```dart
@override
Future<Either<Failure, UserEntity>> login(...) async {
  try {
    // Đã nhận được authResponse từ remoteDataSource
    
    print('💾 Repository: Saving auth data...');
    
    // BƯỚC 1: Lưu access token vào ApiClient
    // Để các request tiếp theo tự động có Authorization header
    apiClient.setAuthToken(authResponse.accessToken);
    print('   ✓ Token set in ApiClient');
    
    // BƯỚC 2: Cache user data và tokens vào local storage
    await Future.wait([
      localDataSource.cacheUser(authResponse.user),
      localDataSource.saveAccessToken(authResponse.accessToken),
      localDataSource.saveRefreshToken(authResponse.refreshToken!),
    ]);
    print('   ✓ User cached');
    print('   ✓ Access token saved');
    print('   ✓ Refresh token saved');
    
    // BƯỚC 3: Convert Model → Entity
    final userEntity = authResponse.user.toEntity();
    
    // BƯỚC 4: Trả về Right (success)
    print('✅ Repository: Login successful');
    return Right(userEntity);
    
  } on AuthException catch (e) {
    print('❌ Repository: Auth error - ${e.message}');
    return Left(AuthFailure(message: e.message));
  } on NetworkException catch (e) {
    print('❌ Repository: Network error - ${e.message}');
    return Left(NetworkFailure(message: e.message));
  } on ServerException catch (e) {
    print('❌ Repository: Server error - ${e.message}');
    return Left(ServerFailure(message: e.message));
  }
}
```

**Dữ liệu lưu vào SharedPreferences:**
```dart
// Key: 'cached_user'
{
  "id": "user_123",
  "name": "Nguyễn Văn A",
  "phone": "0123456789",
  "email": "user@example.com",
  "avatar_url": "https://example.com/avatar.jpg",
  "created_at": "2024-01-01T00:00:00.000Z"
}

// Key: 'access_token'
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

// Key: 'refresh_token'
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**ApiClient headers:**
```dart
{
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
}
```

---

### ⏱️ T = 520ms: LoginUseCase trả về kết quả

**File:** `packages/features/lib/auth/domain/usecases/login_usecase.dart`

```dart
@override
Future<Either<Failure, UserEntity>> call(LoginParams params) {
  // Repository đã trả về Right(userEntity)
  print('🎯 LoginUseCase: Returning result to BLoC');
  
  return repository.login(...);
  // → Right(UserEntity)
}
```

**Dữ liệu trả về:**
```dart
Right(
  UserEntity {
    id: "user_123",
    name: "Nguyễn Văn A",
    phone: "0123456789",
    email: "user@example.com",
    avatarUrl: "https://example.com/avatar.jpg",
    createdAt: DateTime(2024, 1, 1)
  }
)
```

---

### ⏱️ T = 525ms: AuthBloc xử lý kết quả

**File:** `packages/features/lib/auth/presentation/bloc/auth_bloc.dart`

```dart
Future<void> _onLoginRequested(...) async {
  emit(const AuthLoading());
  
  final result = await loginUseCase(...);
  // result = Right(UserEntity)
  
  print('📥 BLoC: Received result from UseCase');
  
  // Xử lý Either với fold
  result.fold(
    // Left case (failure)
    (failure) {
      print('❌ BLoC: Login failed - ${failure.message}');
      emit(AuthError(message: failure.message));
    },
    
    // Right case (success)
    (user) {
      print('✅ BLoC: Login successful');
      print('   User: ${user.name}');
      emit(AuthSuccess(user: user));
    },
  );
}
```

**State mới:** `AuthSuccess(user: UserEntity)`

---

### ⏱️ T = 530ms: UI nhận state và cập nhật

**File:** `packages/features/lib/auth/presentation/pages/login_page.dart`

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    print('👂 UI: State changed to ${state.runtimeType}');
    
    if (state is AuthSuccess) {
      print('🎉 UI: Login successful!');
      print('   Welcome ${state.user.name}');
      
      // Navigate to Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (state is AuthError) {
      print('😢 UI: Login failed');
      print('   Error: ${state.message}');
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  },
  child: BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      final isLoading = state is AuthLoading;
      
      return GradientButton(
        text: 'Đăng nhập',
        onPressed: isLoading ? () {} : _handleLogin,
        isLoading: isLoading,
      );
    },
  ),
)
```

**UI Changes:**
1. Loading indicator biến mất
2. Button enabled lại
3. Navigate đến HomePage
4. HomePage hiển thị thông tin user

---

## 🎯 TỔNG KẾT LUỒNG

### Timeline Summary:
```
T=0ms    : User click "Đăng nhập"
T=1ms    : AuthBloc emit AuthLoading
T=2ms    : LoginUseCase được gọi
T=3ms    : AuthRepository được gọi
T=5ms    : AuthRemoteDataSource gọi API
T=10ms   : ApiClient gửi HTTP request
T=500ms  : Server trả về response
T=510ms  : Parse response thành Model
T=515ms  : Lưu user + tokens vào cache
T=520ms  : Convert Model → Entity
T=525ms  : AuthBloc emit AuthSuccess
T=530ms  : UI navigate đến HomePage
```

### Data Transformations:
```
LoginRequested (Event)
  ↓
LoginParams (UseCase Input)
  ↓
HTTP Request Body (JSON)
  ↓
HTTP Response Body (JSON)
  ↓
AuthResponseModel (Data Model)
  ↓
UserEntity (Domain Entity)
  ↓
AuthSuccess (State)
  ↓
UI Update (Navigation)
```

### Side Effects:
1. ✅ Access token lưu vào ApiClient headers
2. ✅ User data lưu vào SharedPreferences
3. ✅ Access token lưu vào SharedPreferences
4. ✅ Refresh token lưu vào SharedPreferences
5. ✅ Navigate đến HomePage

---

## 🔍 DEBUG TIPS

### 1. Thêm logging ở mỗi layer:
```dart
// Presentation
print('📱 [UI] User clicked login');

// BLoC
print('🧠 [BLoC] Processing login event');

// UseCase
print('🎯 [UseCase] Executing login logic');

// Repository
print('🏪 [Repository] Fetching data');

// DataSource
print('🌐 [DataSource] Calling API');
```

### 2. Dùng Dio Interceptor để log requests:
```dart
_dio.interceptors.add(LogInterceptor(
  request: true,
  requestHeader: true,
  requestBody: true,
  responseHeader: true,
  responseBody: true,
  error: true,
));
```

### 3. Dùng BLoC Observer:
```dart
class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print('📥 Event: $event');
  }
  
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('🔄 Transition: ${transition.currentState} → ${transition.nextState}');
  }
  
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('❌ Error: $error');
  }
}

// Trong main.dart
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
```

### 4. Dùng Flutter DevTools:
- Network tab: Xem HTTP requests
- Timeline: Xem performance
- Logging: Xem console logs

---

## 🚨 ERROR SCENARIOS

### Scenario 1: Sai mật khẩu
```
T=500ms: Server response
{
  "success": false,
  "message": "Số điện thoại hoặc mật khẩu không đúng",
  "error_code": "INVALID_CREDENTIALS"
}

T=510ms: ApiClient throw AuthException
T=515ms: Repository catch và return Left(AuthFailure)
T=520ms: UseCase return Left(AuthFailure)
T=525ms: BLoC emit AuthError
T=530ms: UI show SnackBar với error message
```

### Scenario 2: Không có mạng
```
T=10ms: ApiClient gửi request
T=50ms: DioException (connectionError)
T=55ms: ApiClient throw NetworkException
T=60ms: Repository catch và return Left(NetworkFailure)
T=65ms: UseCase return Left(NetworkFailure)
T=70ms: BLoC emit AuthError("Không có kết nối mạng")
T=75ms: UI show SnackBar
```

### Scenario 3: Server lỗi (500)
```
T=500ms: Server response 500
T=510ms: ApiClient throw ServerException
T=515ms: Repository catch và return Left(ServerFailure)
T=520ms: UseCase return Left(ServerFailure)
T=525ms: BLoC emit AuthError("Lỗi máy chủ, vui lòng thử lại")
T=530ms: UI show SnackBar
```

---

Bạn có câu hỏi gì về luồng dữ liệu này không?
