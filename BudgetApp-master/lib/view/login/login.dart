// lib/view/login/login.dart

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/primary_button.dart';
import 'package:budgetapp_fl/common_widget/secondary_boutton.dart';
import 'package:budgetapp_fl/view/login/sign_in_view.dart';
import 'package:budgetapp_fl/view/login/sign_up_view.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

            SecondaryButton(
              title: "Erstellen Sie ein Konto per E-Mail",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                const SignUpView()),
                );
              },
            ),
            const SizedBox(height: 15),

            PrimaryButton( 
              title: "Ich habe bereits ein Konto (Anmelden)",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                const SignInView()),
                );
              }
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}