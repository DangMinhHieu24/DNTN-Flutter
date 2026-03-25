const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

// Middleware để log requests
server.use(middlewares);
server.use(jsonServer.bodyParser);

// Helper để tạo token giả
function generateToken(userId) {
  return `mock_token_${userId}_${Date.now()}`;
}

// Helper để tìm user
function findUser(phone, password) {
  const db = router.db;
  return db.get('users')
    .find({ phone: phone, password: password })
    .value();
}

// Custom route: POST /auth/login
server.post('/auth/login', (req, res) => {
  const { phone, password } = req.body;

  console.log('📥 Login request:', { phone, password: '***' });

  if (!phone || !password) {
    return res.status(400).json({
      message: 'Vui lòng nhập đầy đủ số điện thoại và mật khẩu'
    });
  }

  const user = findUser(phone, password);

  if (!user) {
    return res.status(401).json({
      message: 'Số điện thoại hoặc mật khẩu không đúng'
    });
  }

  // Tạo response giống real API
  const response = {
    user: {
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      avatar_url: user.avatar_url,
      created_at: user.created_at
    },
    access_token: generateToken(user.id),
    refresh_token: generateToken(user.id + '_refresh'),
    expires_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString() // 24h
  };

  console.log('✅ Login successful:', user.name);
  res.status(200).json(response);
});

// Custom route: POST /auth/register
server.post('/auth/register', (req, res) => {
  const { name, phone, password } = req.body;

  console.log('📥 Register request:', { name, phone, password: '***' });

  if (!name || !phone || !password) {
    return res.status(400).json({
      message: 'Vui lòng nhập đầy đủ thông tin'
    });
  }

  const db = router.db;
  
  // Check if phone already exists
  const existingUser = db.get('users').find({ phone: phone }).value();
  if (existingUser) {
    return res.status(422).json({
      message: 'Số điện thoại đã được đăng ký'
    });
  }

  // Create new user
  const newUser = {
    id: String(Date.now()),
    name: name,
    phone: phone,
    email: null,
    password: password,
    avatar_url: `https://i.pravatar.cc/150?img=${Math.floor(Math.random() * 70)}`,
    created_at: new Date().toISOString()
  };

  db.get('users').push(newUser).write();

  const response = {
    user: {
      id: newUser.id,
      name: newUser.name,
      phone: newUser.phone,
      email: newUser.email,
      avatar_url: newUser.avatar_url,
      created_at: newUser.created_at
    },
    access_token: generateToken(newUser.id),
    refresh_token: generateToken(newUser.id + '_refresh'),
    expires_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
  };

  console.log('✅ Register successful:', newUser.name);
  res.status(201).json(response);
});

// Custom route: POST /auth/logout
server.post('/auth/logout', (req, res) => {
  console.log('📥 Logout request');
  res.status(200).json({
    message: 'Đăng xuất thành công'
  });
});

// Custom route: GET /auth/me
server.get('/auth/me', (req, res) => {
  const authHeader = req.headers.authorization;
  
  console.log('📥 Get current user request');

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      message: 'Unauthorized - Token không hợp lệ'
    });
  }

  const token = authHeader.substring(7);
  
  // Extract user ID from mock token
  const match = token.match(/mock_token_(\d+)_/);
  if (!match) {
    return res.status(401).json({
      message: 'Token không hợp lệ'
    });
  }

  const userId = match[1];
  const db = router.db;
  const user = db.get('users').find({ id: userId }).value();

  if (!user) {
    return res.status(404).json({
      message: 'Không tìm thấy user'
    });
  }

  const response = {
    user: {
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      avatar_url: user.avatar_url,
      created_at: user.created_at
    },
    access_token: token,
    refresh_token: generateToken(user.id + '_refresh')
  };

  console.log('✅ Get user successful:', user.name);
  res.status(200).json(response);
});

// Custom route: POST /auth/refresh
server.post('/auth/refresh', (req, res) => {
  const { refresh_token } = req.body;

  console.log('📥 Refresh token request');

  if (!refresh_token) {
    return res.status(400).json({
      message: 'Refresh token không được cung cấp'
    });
  }

  // Extract user ID from refresh token
  const match = refresh_token.match(/mock_token_(\d+)_refresh/);
  if (!match) {
    return res.status(401).json({
      message: 'Refresh token không hợp lệ'
    });
  }

  const userId = match[1];

  const response = {
    access_token: generateToken(userId),
    refresh_token: generateToken(userId + '_refresh'),
    expires_at: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()
  };

  console.log('✅ Token refreshed for user:', userId);
  res.status(200).json(response);
});

// Use default router for other routes
server.use('/api/v1', router);

// Start server
const PORT = 3000;
server.listen(PORT, () => {
  console.log('🚀 Mock API Server is running!');
  console.log(`📍 URL: http://localhost:${PORT}`);
  console.log('\n📚 Available endpoints:');
  console.log('  POST   /auth/login');
  console.log('  POST   /auth/register');
  console.log('  POST   /auth/logout');
  console.log('  GET    /auth/me');
  console.log('  POST   /auth/refresh');
  console.log('\n👤 Test credentials:');
  console.log('  Phone: 0123456789');
  console.log('  Password: password123');
  console.log('\n💡 Press Ctrl+C to stop\n');
});
