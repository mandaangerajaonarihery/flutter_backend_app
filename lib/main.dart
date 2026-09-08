import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/network/dio_client.dart';
import 'core/storage/local_storage.dart';
import 'core/storage/token_storage.dart';
import 'data/datasources/local/product_local_data_source.dart';
import 'data/datasources/remote/auth_remote_data_source.dart';
import 'data/datasources/remote/product_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/controllers/app_controller.dart';
import 'presentation/controllers/app_scope.dart';
import 'router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox<dynamic>(AppConstants.productsBox);
  final tokenStorage = SecureTokenStorage();
  final client = DioClient(tokenStorage);
  final productRepository = ProductRepositoryImpl(
    ProductRemoteDataSource(client),
    ProductLocalDataSource(LocalStorage(box)),
  );
  final authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(client),
    tokenStorage,
  );
  final controller = AppController(authRepository, productRepository);
  final router = createAppRouter(controller);
  runApp(
    AppScope(
      notifier: controller,
      child: BackendApp(router: router),
    ),
  );
  controller.restoreSession();
}

class BackendApp extends StatelessWidget {
  const BackendApp({super.key, required this.router});
  final RouterConfig<Object> router;

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF286A6C),
    );
    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF83D8D4),
      brightness: Brightness.dark,
    );
    return MaterialApp.router(
      title: 'Flutter Backend App',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [AppLocalizations.delegate],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: lightScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8F7),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      ),
      darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
