import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:social_media/colors/colors.dart';
import 'package:social_media/screens/auth/loginScreen.dart';
import 'package:social_media/services/auth.dart';
import 'package:social_media/widgets/PawPrintBackground.dart';
import 'package:social_media/widgets/textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController displayNameCon = TextEditingController();
  TextEditingController userNameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  register() async {
    String response = await AuthMethods().register(
        email: emailCon.text,
        password: passwordCon.text,
        userName: userNameCon.text,
        displayName: displayNameCon.text);
    if (response == "Success") {
      print("Done");
    } else {
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PawPrintBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with decoration
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Gap(10),
                  Text(
                    "Ghaim",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: kPrimaryColor, 
                      fontFamily: "Montserrat", 
                    ),
                  ),
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Gap(30),
                  CustomTextField(
                    controller: displayNameCon,
                    hintText: "Display Name",
                    prefixIcon: Icons.person_2_outlined,
                  ),
                  Gap(10),
                  CustomTextField(
                    controller: userNameCon,
                    hintText: "User Name",
                    prefixIcon: Icons.alternate_email_outlined,
                  ),
                  Gap(10),
                  CustomTextField(
                    controller: emailCon,
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                  ),
                  Gap(10),
                  CustomTextField(
                    controller: passwordCon,
                    hintText: "Password",
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        child: Text(
                          "Register".toUpperCase(),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: kWhiteColor,
                            padding: EdgeInsets.all(14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9))),
                      ))
                    ],
                  ),
                  Gap(60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account? "),
                      Gap(10),
                      GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen())),
                          child: Text(
                            "Login now",
                            style: TextStyle(color: kPrimaryColor),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
