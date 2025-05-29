import 'package:enchere_app/services/Authentification.dart';
import 'package:flutter/material.dart';
import 'package:enchere_app/UI/register.dart';
import "package:enchere_app/UI/ForgetPassword.dart";

class Login extends StatelessWidget {
  Login({super.key});

  // ✅ Step 1: Add controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Login_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 270),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 0, 132, 162),
                  fontWeight: FontWeight.w700,
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 132, 162),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 132, 162),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'mot de passe',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 132, 162),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 132, 162),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 120, 40),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPassword()),
                    );
                  },
                  child: const Text(
                    "mot de passe oublié ?",
                    style: TextStyle(
                      color: Color.fromRGBO(120, 121, 121, 1),
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              // ✅ Use controller.text in the Authentification method
              OutlinedButton(
                onPressed: () async {
                  Authentification.signIn(
                    email: emailController.text,
                    password: passwordController.text,
                    context: context,
                  );
                },
                style: const ButtonStyle(
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Color(0xFF01CEFF),
                      width: 4,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                child: const Text(
                  "Se connecter",
                  style: TextStyle(
                    color: Color(0xFF01CEFF),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vous n'avez pas de compte,",
                      style: TextStyle(
                        color: Color.fromARGB(225, 121, 120, 120),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(
                          color: Color.fromRGBO(16, 44, 227, 1),
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
