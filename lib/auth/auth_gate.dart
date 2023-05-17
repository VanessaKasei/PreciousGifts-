import 'package:flutterfire_ui/auth.dart';
import 'package:precious_gifts/homePage/home_page.dart';

import '../imports/import.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  get isOnBoarded {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInScreen(
              providerConfigs: [EmailProviderConfiguration()]);
        }

        return const Homes();
      },
    );
  }
}
