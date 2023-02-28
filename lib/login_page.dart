import 'package:flutter/material.dart';
import 'package:untitled2/auth_methods.dart';
import 'package:untitled2/confession_home_page.dart';
import 'package:untitled2/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(255, 241, 241, 241),
                filled: true,
                hintText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
                fillColor: Color.fromARGB(255, 241, 241, 241),
                filled: true,
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            InkWell(
              onTap: () async {
                String res = await _authMethods.LoginUser(
                    _emailController.text, _passwordController.text);
                if (res == 'successfully logged in.') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ConfessionHomePage(),
                    ),
                  );
                }
                print(res);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    color: Colors.blue),
                child: const Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dont have an account?'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                        color: Color.fromARGB(255, 133, 35, 28),
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
