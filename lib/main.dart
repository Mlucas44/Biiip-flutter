import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'utils/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cbixgpgihofmkkterwgo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNiaXhncGdpaG9mbWtrdGVyd2dvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgzNzM2OTUsImV4cCI6MjA0Mzk0OTY5NX0.jwF8DcHLl57Oaw0GSNa8lGVnyjqr-o8IV-LO5EzjDWM',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pourboires',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.accentColor,
          error: AppColors.errorColor,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
