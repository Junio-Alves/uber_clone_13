import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_13/widgets/formField_widget.dart';
import 'package:uber_clone_13/widgets/popUp_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: "test@gmail.com");
  final senhaController = TextEditingController(text: "123456");
  final _formKey = GlobalKey<FormState>();
  cadastrar() {
    Navigator.pushNamed(context, "/cadastro");
  }

  login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      final auth = FirebaseAuth.instance;
      try {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      } catch (e) {
        if (mounted) {
          popUpDialog(context, "Erro no login!", e.toString(), null);
        }
      }
    }
  }

  verificarLogin() {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*função usada para agendar uma ação que será executada 
    após a construção da interface */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/uber_logo.png",
                width: 400,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FormfieldWidget(
                controller: emailController,
                hintText: "E-mail",
                validator: (email) {
                  final emailExp = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      caseSensitive: false);
                  if (email == null || email.isEmpty) {
                    return "Digite um email!";
                  } else if (!emailExp.hasMatch(email)) {
                    return "E-mail invalido";
                  }
                  return null;
                },
              ),
              FormfieldWidget(
                  controller: senhaController,
                  hintText: "Senha",
                  obscureText: true,
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return "Digite uma senha!";
                    } else if (senha.length < 6) {
                      return "Senha deve conter no mínimo 6 digitos!";
                    }
                    return null;
                  }),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () =>
                      login(emailController.text, senhaController.text),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => cadastrar(),
                child: const Text("Não tem conta? Cadastre-se!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
