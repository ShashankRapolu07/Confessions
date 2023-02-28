import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled2/auth_methods.dart';
import 'package:untitled2/confession_home_page.dart';
import 'package:untitled2/login_page.dart';
import 'package:untitled2/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    final AuthMethods authMethods = AuthMethods();

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    void _selectImage() async {
      Uint8List? im = await pickImage(ImageSource.gallery);
      setState(
        () => _image = im,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sign Up'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 53.0,
                      child: _image != null
                          ? CircleAvatar(
                              radius: 50.0,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 50.0,
                              backgroundImage: AssetImage(
                                  'assets/images/default_avatar.jpg'),
                            ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 5.0,
                      child: InkWell(
                        onTap: () => _selectImage(),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Color.fromARGB(255, 23, 104, 171),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Enter your password',
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                InkWell(
                  onTap: () async {
                    String res = await authMethods.SignUpUser(
                        _emailController.text,
                        _passwordController.text,
                        _image);
                    if (res == 'successfully signed up!') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ConfessionHomePage(),
                        ),
                      );
                    }
                    print(res);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      color: Colors.blue,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                      child: const Text(
                        'LogIn',
                        style: TextStyle(
                            color: Color.fromARGB(255, 133, 35, 28),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
