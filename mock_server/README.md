# 🚀 Mock API Server cho App HocTap

Mock server đơn giản sử dụng JSON Server để test app mà không cần backend thật.

## 📦 Cài đặt

```bash
cd mock_server
npm install
```

## ▶️ Chạy server

```bash
npm start
```

Server sẽ chạy tại: `http://localhost:3000`

## 🔧 Development mode (auto-reload)

```bash
npm run dev
```

## 📚 API Endpoints

### 1. Đăng nhập
```bash
POST /auth/login
Content-Type: application/json

{
  "phone": "0123456789",
  "password": "password123"
}
```

**Response 200:**
```json
{
  "user": {
    "id": "1",
    "name": "Nguyễn Văn A",
    "phone": "0123456789",
    "email": "nguyenvana@example.com",
    "avatar_url": "https://i.pravatar.cc/150?img=1",
    "created_at": "2024-01-15T10:30:00Z"
  },
  "access_token": "mock_token_1_1234567890",
  "refresh_token": "mock_token_1_refresh_1234567890",
  "expires_at": "2024-01-16T10:30:00Z"
}
```

**Response 401:**
```json
{
  "message": "Số điện thoại hoặc mật khẩu không đúng"
}
```

### 2. Đăng ký
```bash
POST /auth/register
Content-Type: application/json

{
  "name": "Nguyễn Văn C",
  "phone": "0999888777",
  "password": "password123"
}
```

**Response 201:**
```json
{
  "user": {
    "id": "3",
    "name": "Nguyễn Văn C",
    "phone": "0999888777",
    "email": null,
    "avatar_url": "https://i.pravatar.cc/150?img=15",
    "created_at": "2024-01-25T10:30:00Z"
  },
  "access_token": "mock_token_3_1234567890",
  "refresh_token": "mock_token_3_refresh_1234567890",
  "expires_at": "2024-01-26T10:30:00Z"
}
```

**Response 422:**
```json
{
  "message": "Số điện thoại đã được đăng ký"
}
```

### 3. Lấy thông tin user hiện tại
```bash
GET /auth/me
Authorization: Bearer mock_token_1_1234567890
```

**Response 200:**
```json
{
  "user": {
    "id": "1",
    "name": "Nguyễn Văn A",
    "phone": "0123456789",
    "email": "nguyenvana@example.com",
    "avatar_url": "https://i.pravatar.cc/150?img=1",
    "created_at": "2024-01-15T10:30:00Z"
  },
  "access_token": "mock_token_1_1234567890",
  "refresh_token": "mock_token_1_refresh_1234567890"
}
```

### 4. Đăng xuất
```bash
POST /auth/logout
Authorization: Bearer mock_token_1_1234567890
```

**Response 200:**
```json
{
  "message": "Đăng xuất thành công"
}
```

### 5. Refresh token
```bash
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "mock_token_1_refresh_1234567890"
}
```

**Response 200:**
```json
{
  "access_token": "mock_token_1_1234567891",
  "refresh_token": "mock_token_1_refresh_1234567891",
  "expires_at": "2024-01-26T10:30:00Z"
}
```

## 👤 Test Accounts

| Phone | Password | Name |
|-------|----------|------|
| 0123456789 | password123 | Nguyễn Văn A |
| 0987654321 | password123 | Trần Thị B |

## 🔧 Cấu hình Flutter App

Mở file `packages/core/lib/network/api_endpoints.dart`:

```dart
class ApiEndpoints {
  // Cho Android Emulator
  static const String baseUrl = 'http://10.0.2.2:3000';
  
  // Cho iOS Simulator
  // static const String baseUrl = 'http://localhost:3000';
  
  // Cho thiết bị thật (thay YOUR_IP bằng IP máy tính)
  // static const String baseUrl = 'http://YOUR_IP:3000';
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String refreshToken = '/auth/refresh';
}
```

## 🌐 Lấy IP máy tính

### Windows
```bash
ipconfig
# Tìm IPv4 Address
```

### macOS/Linux
```bash
ifconfig | grep "inet "
# hoặc
ip addr show
```

## 📝 Thêm user mới

Chỉnh sửa file `db.json` và thêm vào mảng `users`:

```json
{
  "id": "3",
  "name": "Tên mới",
  "phone": "0111222333",
  "email": "email@example.com",
  "password": "password123",
  "avatar_url": "https://i.pravatar.cc/150?img=3",
  "created_at": "2024-01-25T10:30:00Z"
}
```

## 🧪 Test với cURL

```bash
# Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"0123456789","password":"password123"}'

# Register
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","phone":"0111222333","password":"password123"}'

# Get current user
curl -X GET http://localhost:3000/auth/me \
  -H "Authorization: Bearer mock_token_1_1234567890"
```

## 🐛 Troubleshooting

### Port 3000 đã được sử dụng
Thay đổi PORT trong `server.js`:
```javascript
const PORT = 3001; // Đổi sang port khác
```

### Không kết nối được từ Android Emulator
- Dùng `10.0.2.2` thay vì `localhost`
- Check firewall có block port 3000 không

### Không kết nối được từ thiết bị thật
- Đảm bảo máy tính và điện thoại cùng WiFi
- Dùng IP máy tính thay vì localhost
- Check firewall

## 📊 View logs

Server sẽ log mọi request:
```
📥 Login request: { phone: '0123456789', password: '***' }
✅ Login successful: Nguyễn Văn A
```

## 🔄 Reset database

Xóa file `db.json` và restart server, hoặc restore từ backup.

## 💡 Tips

1. Dùng Postman để test API trước khi test trên app
2. Check console logs để debug
3. Có thể thêm delay để simulate network:
```javascript
server.use((req, res, next) => {
  setTimeout(next, 1000); // 1 second delay
});
```

4. Có thể thêm random errors để test error handling:
```javascript
server.use((req, res, next) => {
  if (Math.random() < 0.1) { // 10% chance
    return res.status(500).json({ message: 'Random server error' });
  }
  next();
});
```
