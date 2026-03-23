import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/theme/app_theme.dart';
import 'package:features/auth/presentation/pages/login_page.dart';
import 'package:features/auth/presentation/bloc/auth_bloc.dart';
import 'di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await initializeDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide AuthBloc to the entire app
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp(
        title: 'Mindful Curator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginPage(),
      ),
    );
  }
}
