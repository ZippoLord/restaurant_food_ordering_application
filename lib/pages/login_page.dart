import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/components/custom_button.dart';
import 'package:food_order_app/components/custom_emailtextfield.dart';
import 'package:food_order_app/components/custom_passwordtextfield.dart';
import 'package:food_order_app/components/custom_textfield.dart';
import 'package:food_order_app/controllers/login_controller.dart';
import 'package:food_order_app/models/newmodels/login_model.dart';
import 'package:food_order_app/pages/main_screen.dart';
import 'package:food_order_app/services/auth/auth_service.dart';
import 'package:food_order_app/widgets/custom_container.dart';
import 'package:food_order_app/widgets/custom_login_register_container.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController controller = LoginController();
  final FocusNode passwordFocusNode = FocusNode(); 

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
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
      backgroundColor: Colors.red,
      body: SafeArea(
        child:  CustomLoginRegisterContainer(
          containerContent: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Étel rendelő alkalmazás",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            // logo
            SizedBox(
              height: 250,
              child: Lottie.asset("lib/images/loaders/Food choose.json")),

            const SizedBox(height: 25),

            EmailTextField(controller: emailController),
            const SizedBox(height: 10), 
            PasswordTextField(controller: passwordController),
            const SizedBox(height: 22),

            // sign in button
            CustomButton(
              onTap: (){
                if(emailController.text.isNotEmpty && passwordController.text.length >= 6){
                  LoginModel model = LoginModel(email: emailController.text, password: passwordController.text);
                  String data = loginModelToJson(model);
                  controller.LoginFunction(data);
                }
              },
              text: "Bejelentkezés",
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Regisztrálj",
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
      )
      ),
    );
  }
}