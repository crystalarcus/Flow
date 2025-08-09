import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:redesigned/core/navigation/router.dart';
import 'package:redesigned/core/services/auth_service.dart';
import 'package:redesigned/core/services/navigation_service.dart';
import 'package:redesigned/core/services/user_data_service.dart';
import 'package:redesigned/data/local/local_user_data_source.dart';
import 'package:redesigned/data/repositories/user_repository.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key, required this.child});
  final Widget child;

  /// User ID to pass to [UserDataService]
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider<UserDataService>(
          create: (_) => UserDataService(UserRepository(
            LocalUserDataSource(),
          )),
        ),
        Provider<NavigationService>(
          create: (_) => NavigationService(
            context.read<GoRouter>(),
          ),
        )
      ],
      child: child,
    );
  }
}
