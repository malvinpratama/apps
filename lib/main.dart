import 'package:flutter/material.dart';
import 'package:di_service/di_service.dart';
import 'package:database_service/database_service.dart' as db_service;
import 'package:logger_service/logger_service.dart' as logger_service;
import 'package:route_service/route_service.dart' as route_service;
import 'package:theme_service/theme_service.dart' as theme_service;
import 'package:shared/shared.dart' as shared;
import 'package:shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupApp();

  final loggerService = GetIt.instance<logger_service.LoggerService>();

  if (kDebugMode) {
    Bloc.observer = loggerService.getBlocObserver(
      settings: TalkerBlocLoggerSettings(
        printChanges: true,
        printCreations: true,
        printClosings: true,
      ),
    );
  }
  runApp(MyApp());
}

setupApp() {
  DIService.init([
    db_service.configureDependencies(),
    logger_service.configureDependencies(),
    route_service.configureDependencies(),
    shared.configureDependencies(),
    theme_service.configureDependencies(),
  ]);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final themeService = GetIt.instance<theme_service.ThemeService>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    switch (themeService.getThemeMode()) {
      case ViewStatus.success:
        return shared.ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: GetIt.instance<shared.Env>().appName,
            );
          },
        );
      default:
        return SizedBox.shrink();
    }
  }
}
