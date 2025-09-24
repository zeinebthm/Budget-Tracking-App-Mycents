// ignore_for_file: deprecated_member_use

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/primary_button.dart';
import 'package:budgetapp_fl/common_widget/secondary_boutton.dart';
import 'package:budgetapp_fl/view/login/Sign_in_view.dart';
import 'package:budgetapp_fl/view/login/login.dart';
import 'package:budgetapp_fl/view/login/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.08,
            vertical: media.height * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: media.height * 0.05),

              // Überschrift / Begrüßung
              Text(
                "MyCents",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColor.white,
                  fontSize: media.width * 0.045,
                ),
              ),

              const Spacer(),

              // Registrieren Button
              PrimaryButton(
                title: "Registrieren",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );
                },
              ),

              SizedBox(height: media.height * 0.03),

              // Anmelden Button
              SecondaryButton(
                title: "Anmelden",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
