// ignore_for_file: deprecated_member_use

import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/primary_button.dart';
import 'package:budgetapp_fl/common_widget/round_textfield.dart';
import 'package:budgetapp_fl/common_widget/secondary_boutton.dart';
import 'package:budgetapp_fl/view/login/Sign_in_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpView();
}

class _SignUpView extends State <SignUpView> {

TextEditingController txtEmail = TextEditingController();
TextEditingController txtPassword = TextEditingController();

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
            ), //Hier sollte das Logog eingefügt werden
            const Spacer(),
           
           RoundTextField(
           title: "E-Mail",
           controller: txtEmail,
           keyboardType: TextInputType.emailAddress),

            const SizedBox(
              height: 15,
            ),
            RoundTextField(
           title: "Passwort",
           controller: txtPassword,
           keyboardType: TextInputType.emailAddress,
           obscureText: true,
           ),

            const SizedBox(
              height: 15,
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: TColor.gray70, 
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: TColor.gray70, 
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: TColor.gray70, 
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: TColor.gray70, 
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Mindestens acht Zeichen \nBuchstaben und Zahlen",
                  style: TextStyle(
                    color: TColor.gray50,
                    fontSize: 12
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            PrimaryButton(
              title: "Starte, es ist kostenlos", 
              onPressed: () {},
              ),

             const Spacer(),

              SecondaryButton(
               title: "Habe bereits ein Konto",
               onPressed: () {
                Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const SignInView(),
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



/*
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      "E-Mail eingeben",
      style: TextStyle(
        color: TColor.gray50, 
        fontSize: 14,
      ),
    ),
    const SizedBox(
      height: 4,
    ), 
    Container(
      height: 48,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: TColor.gray60.withOpacity(0.05),
        border: Border.all(color: TColor.gray70),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    ),
  ],
),
*/
