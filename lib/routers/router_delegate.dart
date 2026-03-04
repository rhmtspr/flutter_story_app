import 'package:declarative_navigation/db/auth_repository.dart';
import 'package:declarative_navigation/screen/add_story_screen.dart';
import 'package:declarative_navigation/screen/detail/story_detail_screen.dart';
import 'package:declarative_navigation/screen/home/story_list_screen.dart';
import 'package:declarative_navigation/screen/login_screen.dart';
import 'package:declarative_navigation/screen/register_screen.dart';
import 'package:declarative_navigation/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  bool isAddingStory = false;

  List<Page> get _splashStack => const [
    MaterialPage(key: ValueKey('SplashPage'), child: SplashScreen()),
  ];

  List<Page> get _loggedOutStack => [
    MaterialPage(
      key: const ValueKey("LoginPage"),
      child: LoginScreen(
        onLogin: () {
          isLoggedIn = true;
          notifyListeners();
        },
        onRegister: () {
          isRegister = true;
          notifyListeners();
        },
      ),
    ),
    if (isRegister == true)
      MaterialPage(
        key: const ValueKey("RegisterPage"),
        child: RegisterScreen(
          onRegister: () {
            isRegister = false;
            notifyListeners();
          },
          onLogin: () {
            isRegister = false;
            notifyListeners();
          },
        ),
      ),
  ];

  List<Page> get _loggedInStack => [
    MaterialPage(
      key: const ValueKey('ListStoryScreen'),
      child: ListStoryScreen(
        onTapped: (String storyId) {
          selectedStory = storyId;
          notifyListeners();
        },
        onLogout: () {
          isLoggedIn = false;
          notifyListeners();
        },
        onAddStory: () {
          isAddingStory = true;
          notifyListeners();
        },
      ),
    ),
    if (selectedStory != null)
      MaterialPage(
        key: ValueKey(selectedStory),
        child: StoryDetailScreen(storyId: selectedStory!),
      ),
    if (isAddingStory)
      const MaterialPage(key: ValueKey('AddStoryPage'), child: AddStoryPage()),
  ];

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onDidRemovePage: (page) {
        if (page.key == ValueKey('StoryDetailPage-$selectedStory')) {
          selectedStory = null;
          notifyListeners();
        }
        if (page.key == const ValueKey('RegisterPage')) {
          isRegister = false;
          notifyListeners();
        }
        if (page.key == const ValueKey('AddStoryPage')) {
          isAddingStory = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
