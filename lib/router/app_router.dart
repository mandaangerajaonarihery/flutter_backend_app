import 'package:go_router/go_router.dart';

import '../presentation/controllers/app_controller.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/detail/detail_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/widgets/app_shell.dart';

GoRouter createAppRouter(AppController controller) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: controller,
    redirect: (context, state) {
      if (controller.isStarting) return '/login';
      final isAuthRoute = state.uri.path == '/login' || state.uri.path == '/register';
      if (!controller.isAuthenticated && !isAuthRoute) return '/login';
      if (controller.isAuthenticated && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
      GoRoute(path: '/detail/:id', builder: (context, state) => DetailScreen(productId: int.parse(state.pathParameters['id']!))),
    ],
  );
}
