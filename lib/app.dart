import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'shared/widgets/custom_toast/custom_toast_widget.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'OhMyUniversity!',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,

      // Navigation
      routerConfig: router,

      // Toast overlay — rendered above all routes
      builder: (context, child) => Stack(
        children: [
          child ?? const SizedBox.shrink(),
          const ToastContainerWidget(),
        ],
      ),
    );
  }
}