import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/components/custom_textfield.dart';
import 'package:food_order_app/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
    // get instance of auth service
    final _authService = AuthService();

    // try logging in
    try {
      await _authService.signInWithEmailPassword(emailController.text, passwordController.text,);
    }

    // display any errors
    catch (e) {
      showDialog(
        context: context,
        builder:(context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  void forgotPw() {
    showDialog(
      context: context,
      builder:(context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("User tapped forgot password"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.restaurant_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 25),

            // message, app slogan or something like that
            Text(
              "Étel rendelő alkalmazás",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 25),

            // email textfield
            MyTextField(
              controller: emailController,
              hintText: "Email cím",
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              controller: passwordController,
              hintText: "Jelszó",
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // sign in button
            CustomButton(
              onTap: login,
              text: "Bejelentkezés",
            ),

            const SizedBox(height: 25),

            // register button ("Not a member? Register here!")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Még nincs fiókod?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary)
                ),

                const SizedBox(width: 4),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Itt regisztrálhatsz!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ), 
      ),
    );
  }
}