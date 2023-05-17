import 'package:precious_gifts/imports/import.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email here'),
              ),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: passwordController,
                obscureText: _obscurePasswordText,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePasswordText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePasswordText = !_obscurePasswordText;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 400,
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: _obscurePasswordText,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm your password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePasswordText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPasswordText =
                            !_obscureConfirmPasswordText;
                      });
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  signUpAuth.createUserWithEmailAndPassword(
                      emailController.text,
                      passwordController.text,
                      confirmPasswordController.text,
                      context);
                  print("pressed");
                },
                child: const Text("Sign Up"),
              ),
            ),
            SizedBox(
              width: 600,
              child: Divider(
                color: Colors.grey[300],
                thickness: 2,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Already have an account?"),
                  InkWell(
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => loginPage()),
                      );
                    },
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
