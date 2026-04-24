// Слой: core | Назначение: точка входа — инициализация BLoC, БД, роутера

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'data/datasources/app_database.dart';
import 'data/datasources/auth_local_datasource.dart';
import 'data/datasources/item_local_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/item_repository_impl.dart';
import 'domain/usecases/check_session_usecase.dart';
import 'domain/usecases/create_item_usecase.dart';
import 'domain/usecases/delete_item_usecase.dart';
import 'domain/usecases/get_all_items_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'domain/usecases/search_items_usecase.dart';
import 'domain/usecases/update_item_usecase.dart';
import 'firebase_options.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/item/item_bloc.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final isFirebaseSupportedPlatform = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  if (isFirebaseSupportedPlatform) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    debugPrint('Firebase initialization skipped on this platform.');
  }

  // Логирование всех BLoC событий и переходов
  Bloc.observer = _AppBlocObserver();

  // Инициализация синглтона базы данных
  final db = AppDatabase.instance;

  // Слой данных
  final authDatasource = AuthLocalDatasource(db);
  final itemDatasource = ItemLocalDatasource(db);

  // Репозитории
  final authRepository = AuthRepositoryImpl(authDatasource);
  final itemRepository = ItemRepositoryImpl(itemDatasource);

  // Use cases авторизации
  final loginUseCase = LoginUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final checkSessionUseCase = CheckSessionUseCase(authRepository);

  // Use cases элементов
  final getAllItems = GetAllItemsUseCase(itemRepository);
  final createItem = CreateItemUseCase(itemRepository);
  final updateItem = UpdateItemUseCase(itemRepository);
  final deleteItem = DeleteItemUseCase(itemRepository);
  final searchItems = SearchItemsUseCase(itemRepository);

  // BLoC
  final authBloc = AuthBloc(
    loginUseCase: loginUseCase,
    registerUseCase: registerUseCase,
    checkSessionUseCase: checkSessionUseCase,
    authRepository: authRepository,
  );

  final itemBloc = ItemBloc(
    getAllItemsUseCase: getAllItems,
    createItemUseCase: createItem,
    updateItemUseCase: updateItem,
    deleteItemUseCase: deleteItem,
    searchItemsUseCase: searchItems,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authBloc),
        BlocProvider.value(value: itemBloc),
      ],
      child: _App(authBloc: authBloc),
    ),
  );
}

class _App extends StatefulWidget {
  const _App({required this.authBloc});

  final AuthBloc authBloc;

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  late GoRouter _router = createRouter(widget.authBloc);

  @override
  void reassemble() {
    super.reassemble();
    // During hot reload, rebuild router so new route entries are picked up.
    _router = createRouter(widget.authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeModeController.notifier,
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          locale: const Locale('ru'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'),
          ],
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// BLoC-наблюдатель: логирует все события, переходы и ошибки
class _AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('[BLoC] ${bloc.runtimeType} → событие: $event');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint(
      '[BLoC] ${bloc.runtimeType} → '
      '${transition.currentState.runtimeType} → '
      '${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('[BLoC] ${bloc.runtimeType} → ошибка: $error');
  }
}
