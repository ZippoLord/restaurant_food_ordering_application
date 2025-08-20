import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/password_controller.dart';
import '../controllers/register_controller.dart';
import '../components/custom_emailtextfield.dart';
import '../components/custom_passwordtextfield.dart';
import '../components/custom_passwordverfield.dart';
import '../components/custom_button.dart';
import '../models/newmodels/register_model.dart';
import '../widgets/custom_login_register_container.dart';
import 'login_page.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVerificationController = TextEditingController();
  final RegisterController controller = RegisterController();

  @override
  void initState() {
    super.initState();
    Get.delete<PasswordController>(force: true);
    Get.put(PasswordController());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordVerificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // <-- fontos
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Container(),
      ),
      backgroundColor: Colors.red,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // billentyűzet miatt
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(22.0),
                        child: Text(
                          "Étel rendelő alkalmazás",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomLoginRegisterContainer(
                          containerContent: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 250,
                                child: Lottie.asset(
                                  "lib/images/loaders/Food choose.json",
                                ),
                              ),
                              const SizedBox(height: 25),
                              EmailTextField(controller: emailController),
                              const SizedBox(height: 10),
                              PasswordTextField(controller: passwordController),
                              const SizedBox(height: 10),
                              PasswordVerificationTextField(
                                controller: passwordVerificationController,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 12,
                                  bottom: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => const LoginPage());
                                      },
                                      child: Text(
                                        "Bejelentkezés",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomButton(
                                onTap: () {
                                  RegisterModel model = RegisterModel(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    passwordVerification:
                                        passwordVerificationController.text,
                                  );
                                  controller.registerFunction(
                                    registerModelToJson(model),
                                  );
                                },
                                text: "Regisztráció",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
