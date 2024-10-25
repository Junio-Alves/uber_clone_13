import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_clone_13/models/user_model.dart';
import 'package:uber_clone_13/provider/user_provider.dart';
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
  final store = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  cadastrar() {
    Navigator.pushNamed(context, "/cadastro");
  }

  login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        getUserData();
        isUserOrIsDriver();
      } catch (e) {
        if (mounted) {
          popUpDialog(context, "Erro no login!", e.toString(), null);
        }
      }
    }
  }

  //Verifica se o usuario é um motorista ou usuario, e redireciona para suas respectivas telas!
  isUserOrIsDriver() async {
    final userId = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> usuario =
        await store.collection("usuarios").doc(userId).get();
    if (usuario.data() != null) {
      if (mounted) Navigator.pushReplacementNamed(context, "/home");
    } else {
      if (mounted) Navigator.pushReplacementNamed(context, "/driver_home");
    }

    /*
    DocumentSnapshot<Map<String, dynamic>> motorista =
        await store.collection("Motoristas").doc(userId).get();
    if (motorista.data() != null) {
      if (mounted) Navigator.pushReplacementNamed(context, "/driver_home");
    }
     */
  }

  verificarLogin() {
    if (auth.currentUser != null) {
      isUserOrIsDriver();
    }
  }

  getUserData() async {
    Profile usuario = await Profile.getUserData();
    userProvider.updateUser(usuario);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*função usada para agendar uma ação que será executada 
    após a construção da interface */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarLogin();
      userProvider = Provider.of<UserProvider>(context, listen: false);
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
