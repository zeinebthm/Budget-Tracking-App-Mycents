// lib/view/login/sign_up_view.dart

import 'package:budgetapp_fl/api_service.dart';
import 'package:budgetapp_fl/common/color_extension.dart';
import 'package:budgetapp_fl/common_widget/primary_button.dart';
import 'package:budgetapp_fl/common_widget/round_textfield.dart';
import 'package:budgetapp_fl/view/login/sign_in_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final ApiService apiService = ApiService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _handleSignUp() async {
    setState(() => isLoading = true);
    
    final result = await apiService.register(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);
    
    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: TColor.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Neues Konto erstellen",
                style: TextStyle(
                    color: TColor.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 40),
            
            RoundTextField(
              title: "Email",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            RoundTextField(
              title: "Passwort",
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 40),
            
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(title: "Registrieren", onPressed: _handleSignUp),
          ],
        ),
      ),
    );
  }
}