import 'package:precious_gifts/homePage/home_page.dart';
import 'package:precious_gifts/imports/import.dart';

class loginPage extends StatefulWidget {
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                obscureText: _obscureText,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
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
                  loginAuth.loginUserWithEmailAndPassword(
                      emailController.text, passwordController.text, context);
                  print("pressed");
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Homes()),
                  );
                },
                child: const Text("Login"),
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
                  const Text("Don't have an account?"),
                  InkWell(
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
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
