import 'package:declarative_navigation/db/auth_repository.dart';
import 'package:declarative_navigation/db/story_repository.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/provider/story_provider.dart';
import 'package:declarative_navigation/routers/router_delegate.dart';
import 'package:declarative_navigation/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const QuotesApp());
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({Key? key}) : super(key: key);

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  late MyRouterDelegate myRouterDelegate;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService();
    final authRepository = AuthRepository(apiService);
    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),

        ProxyProvider<ApiService, AuthRepository>(
          update: (_, api, __) => AuthRepository(api),
        ),

        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (_) => AuthProvider(AuthRepository(ApiService())),
          update: (_, repo, __) => AuthProvider(repo),
        ),

        ChangeNotifierProvider(
          create: (context) => StoryProvider(ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Quotes App',
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
