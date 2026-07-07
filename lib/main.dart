import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/pantry/presentation/pages/pantry_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AshpazyarApp());
}

class AshpazyarApp extends StatelessWidget {
  const AshpazyarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'آشپزیار',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      locale: const Locale('fa'),
      supportedLocales: const [Locale('fa'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const _SessionGate(),
    );
  }
}

/// Skips straight to Pantry when a session token already exists, otherwise
/// starts at Login.
class _SessionGate extends StatefulWidget {
  const _SessionGate();

  @override
  State<_SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<_SessionGate> {
  final _authRepository = AuthRepository();
  late final Future<bool> _hasSession = _authRepository.hasSession();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSession,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: AppColors.appBackground,
            body: Center(child: CircularProgressIndicator(color: AppColors.turmeric)),
          );
        }
        return snapshot.data!
            ? PantryPage(authRepository: _authRepository)
            : LoginPage(authRepository: _authRepository);
      },
    );
  }
}
