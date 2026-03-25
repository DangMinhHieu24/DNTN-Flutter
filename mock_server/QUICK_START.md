# 🚀 Quick Start - Mock Server

## Bước 1: Cài đặt Node.js

Nếu chưa có Node.js, download tại: https://nodejs.org/

Kiểm tra đã cài đặt chưa:
```bash
node --version
npm --version
```

## Bước 2: Cài đặt dependencies

```bash
cd mock_server
npm install
```

## Bước 3: Chạy server

### Windows
Double-click file `START_SERVER.bat`

Hoặc:
```bash
npm start
```

### macOS/Linux
```bash
npm start
```

## Bước 4: Test server

Mở browser: http://localhost:3000

Hoặc test với cURL:
```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"0123456789\",\"password\":\"password123\"}"
```

## Bước 5: Chạy Flutter app

```bash
# Quay lại thư mục root
cd ..

# Chạy app
flutter run
```

## ✅ Test credentials

- Phone: `0123456789`
- Password: `password123`

## 🔧 Troubleshooting

### Port 3000 đã được sử dụng?
Mở `server.js`, đổi dòng:
```javascript
const PORT = 3000; // Đổi thành 3001 hoặc port khác
```

Và update trong Flutter:
```dart
// packages/core/lib/network/api_endpoints.dart
static const String baseUrl = 'http://10.0.2.2:3001';
```

### Không kết nối được từ Android Emulator?
Dùng `10.0.2.2` thay vì `localhost`

### Không kết nối được từ iOS Simulator?
Dùng `localhost` hoặc `127.0.0.1`

### Không kết nối được từ thiết bị thật?
1. Lấy IP máy tính:
   - Windows: `ipconfig`
   - Mac/Linux: `ifconfig`
2. Update baseUrl: `http://YOUR_IP:3000`
3. Đảm bảo cùng WiFi

## 📝 Logs

Server sẽ hiển thị logs:
```
📥 Login request: { phone: '0123456789', password: '***' }
✅ Login successful: Nguyễn Văn A
```

## 🛑 Dừng server

Press `Ctrl + C` trong terminal
