import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_controller.dart';
import '../controllers/login_controller.dart';
import '../components/custom_emailtextfield.dart';
import '../components/custom_passwordtextfield.dart';
import '../components/custom_button.dart';
import '../models/newmodels/login_model.dart';
import '../widgets/custom_login_register_container.dart';
import 'register_page.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
   const LoginPage({
    super.key,
    this.onTap,
  });


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final LoginController controller = LoginController();

  @override
  void initState() {
    super.initState();
    // új példány minden oldal betöltéskor
    Get.delete<PasswordController>(force: true);
    Get.put(PasswordController());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(),
      ),
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(22.0),
              child: Text(
                "Étel rendelő alkalmazás",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
              child: CustomLoginRegisterContainer(
                containerContent: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Lottie.asset("lib/images/loaders/Food choose.json"),
                    ),
                    const SizedBox(height: 25),
                    EmailTextField(controller: emailController),
                    const SizedBox(height: 10),
                    PasswordTextField(controller: passwordController),
                    Padding(
                       padding: const EdgeInsets.only(right: 12, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const RegisterPage());
                            },
                            child: Text(
                              "Regisztrálj",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomButton(
                      onTap: () {
                        if (emailController.text.isNotEmpty &&
                            passwordController.text.length >= 6) {
                          LoginModel model = LoginModel(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          controller.loginFunction(loginModelToJson(model));
                        }
                      },
                      text: "Bejelentkezés",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
                    
