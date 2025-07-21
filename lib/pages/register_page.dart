import 'package:flutter/material.dart';
import 'package:food_order_app/services/auth/auth_service.dart';
import 'package:food_order_app/widgets/login_register_snackbar.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  // register method
  void register() async {
    // get auth service
    final authService = AuthService();

    // check if passwords match -> create user
    if (passwordController.text == confirmPasswordController.text) {
      // try creating user
      try {
        await authService.registrationFirebase(emailController.text, passwordController.text,);
      }

      // display any errors
      catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    // if passwords don't match -> show error
    else {
      showLoginRegisterSnackbar('A jelszavak nem egyeznek');
    }
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

            // message ("Create your account!")
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

            // confirm password textfield
            MyTextField(
              controller: confirmPasswordController,
              hintText: "Jelszó megerősítése",
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // sign up button
            CustomButton(
              onTap: register,
              text: "Regisztrálás",
            ),

            const SizedBox(height: 25),

            // login button ("Already have an account? Log in here!")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Már van fiókod?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary)
                ),

                const SizedBox(width: 4),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Itt tudsz bejelentkezni!",
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