// ignore_for_file: deprecated_member_use

import 'package:budgetapp_fl/api_service.dart';
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/primary_button.dart';
import 'package:budgetapp_fl/common_widget/round_textfield.dart';
import 'package:budgetapp_fl/common_widget/secondary_boutton.dart';
import 'package:budgetapp_fl/view/login/sign_up_view.dart';
import 'package:budgetapp_fl/view/main_tabview/main_tab_view.dart';
import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  final ApiService apiService = ApiService();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isRemember = false;
  bool isLoading = false;

  void _handleLogin() async {

    setState(() => isLoading = true);


    bool success = await apiService.login(
      txtEmail.text,
      txtPassword.text,
    );


    setState(() => isLoading = false);


    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Échec de la connexion. Vérifiez vos identifiants.")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: TColor.gray80,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/logo1.png",
              width: media.width * 0.5,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            RoundTextField(
              title: "Einloggen",
              controller: txtEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            RoundTextField(
              title: "Passwort",
              controller: txtPassword,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isRemember = !isRemember;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRemember
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        size: 25,
                        color: TColor.gray50,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Angemeldet bleiben",
                        style: TextStyle(
                          color: TColor.gray50,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                  },
                  child: Text(
                    "Erinnern",
                    style: TextStyle(
                      color: TColor.gray50,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              PrimaryButton(
                title: "Einloggen",
                onPressed: _handleLogin,
              ),


            const Spacer(),
            SecondaryButton(

              title: "Noch kein Konto? Registrieren",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}