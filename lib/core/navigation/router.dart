import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/Components/Utils/classes.dart';
import 'package:redesigned/core/navigation/root_view.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';
import 'package:redesigned/core/services/user_data_service.dart';
import 'package:redesigned/core/utils/screen_transitions.dart';
import 'package:redesigned/data/repositories/profile_repository.dart';
import 'package:redesigned/follow_screen.dart';
import 'package:redesigned/notification_screen.dart';
import 'package:redesigned/screens/auth_screens/sign_in/sign_in_view.dart';
import 'package:redesigned/screens/auth_screens/sign_in/sign_in_view_model.dart';
import 'package:redesigned/screens/auth_screens/sign_up/sign_up_view.dart';
import 'package:redesigned/screens/auth_screens/sign_up/sign_up_view_model.dart';
import 'package:redesigned/screens/home/home_view.dart';
import 'package:redesigned/screens/home/home_view_model.dart';
import 'package:redesigned/screens/profile/profile_view.dart';
import 'package:redesigned/message_screen.dart';
import 'package:redesigned/screens/profile/profile_view_model.dart';
import 'package:redesigned/settings_screen.dart';
import 'package:redesigned/stories_screen.dart';
import 'package:redesigned/story_view_screen.dart';

final router = GoRouter(
    initialLocation: '/home',
    // Redirect User to Sign-in screen if user is not signed in
    // or if user logs out
    redirect: (context, state) async {
      final authService = context.read<AuthService>();
      final bool loggedIn = await authService.isLoggedIn();
      final bool tryingToSignIn = state.matchedLocation == '/signin';

      // If the user is NOT logged in AND they are not already trying to sign in,
      // redirect them to the sign-in page.
      if (!loggedIn && !tryingToSignIn) {
        print(loggedIn);
        return '/signin';
      }
      return null;
    },
    routes: [
      ShellRoute(
          pageBuilder: (context, state, child) =>
              NoTransitionPage(child: RootView(child: child)),
          routes: [
            GoRoute(
                name: 'home',
                path: '/home',
                pageBuilder: (context, state) => SlideBottomTransitionPage(
                    child: ChangeNotifierProvider<HomeViewModel>(
                      create: (_) => HomeViewModel(),
                      child: const HomeScreen(),
                    ),
                    state: state)),
            GoRoute(
                path: '/notification',
                pageBuilder: (context, state) {
                  return SlideBottomTransitionPage(
                      child: const NotificationScreen(), state: state);
                }),
            GoRoute(
                path: '/messages',
                pageBuilder: (context, state) => SlideBottomTransitionPage(
                    child: const MessageScreen(), state: state)),
            GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => SlideBottomTransitionPage(
                    child: const SettingsScreen(), state: state)),
          ]),
      // GoRoute(
      //     path: '/reels',
      //     pageBuilder: (context, state) {
      //       return SlideBottomTransitionPage(
      //           child: const ReelsScreen(), state: state);
      //     }),
      GoRoute(
        path: '/signin',
        builder: (context, state) => ChangeNotifierProvider<SignInViewModel>(
          create: (_) => SignInViewModel(
              Provider.of<AuthService>(context),
              context.read<NavigationService>(),
              context.read<UserDataService>()),
          child: const SignInView(),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => ChangeNotifierProvider<SignUpViewModel>(
          create: (_) => SignUpViewModel(Provider.of<AuthService>(context)),
          child: const SignUpView(),
        ),
      ),

      GoRoute(
          path: '/stories',
          pageBuilder: ((context, state) =>
              SlideTransitionPage(state: state, child: const StoriesScreen()))),
      GoRoute(
        path: '/profile/:userID',
        pageBuilder: ((context, state) => SlideTransitionPage(
              state: state,
              child: ChangeNotifierProvider<ProfileViewModel>(
                create: (_) => ProfileViewModel(ProfileRepository(
                    state.pathParameters['userID'] as String)),
                child: const ProfileView(),
              ),
            )),
      ),
      GoRoute(
          path: '/follow/:name',
          pageBuilder: ((context, state) {
            // var extra = state.extra as List;
            // Person person = extra[0] as Person;
            // List<FollowPerson> followers = extra[1] as List<FollowPerson>? ?? [];
            String name = state.pathParameters['name'] ?? '';
            return SlideTransitionPage(
                state: state, child: FollowScreen(name: name));
          })),
      GoRoute(
          path: '/storyview',
          pageBuilder: ((context, state) {
            var storyGroup = state.extra as StoryGroup;
            // String name = state.pathParameters['name'] ?? '';
            return SlideTransitionPage(
                state: state, child: StoryView(story: storyGroup));
          })),
    ]);
