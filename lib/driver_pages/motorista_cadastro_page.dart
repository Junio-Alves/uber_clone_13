import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone_13/models/driver_model.dart';
import 'package:uber_clone_13/widgets/formField_widget.dart';
import 'package:uber_clone_13/widgets/popUp_widget.dart';

class CadastroDriverPage extends StatefulWidget {
  const CadastroDriverPage({super.key});

  @override
  State<CadastroDriverPage> createState() => _CadastroDriverPageState();
}

class _CadastroDriverPageState extends State<CadastroDriverPage> {
  final nomeController = TextEditingController(text: "driver_test");
  final emailController = TextEditingController(text: "driver_test@gmail.com");
  final senhaController = TextEditingController(text: "123456");
  final carroController = TextEditingController(text: "Palio 2004");
  final placaController = TextEditingController(text: "PCH-1234");
  final _formKey = GlobalKey<FormState>();

  login() {
    Navigator.pushNamed(context, "/login");
  }

  cadastrarMotorista(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      final auth = FirebaseAuth.instance;
      try {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        salvarDadosMotorista();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/driver_home", (_) => false);
        }
      } catch (e) {
        if (mounted) {
          popUpDialog(context, "Erro no Cadastro", e.toString(), null);
        }
      }
    }
  }

  salvarDadosMotorista() async {
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    final driveId = auth.currentUser!.uid;
    final motorista = Motorista(
      driverUid: driveId,
      nome: nomeController.text,
      email: emailController.text,
      profileUrl: "",
      carroModelo: carroController.text,
      placa: placaController.text,
      driverLoc: null,
    );
    await store.collection("Motoristas").doc(driveId).set(motorista.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Cadastro Motorista",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
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
                  "Cadastro Motorista",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FormfieldWidget(
                controller: nomeController,
                hintText: "Nome",
                validator: (nome) {
                  if (nome == null || nome.isEmpty) {
                    return "Digite um nome!";
                  } else if (nome.length < 3) {
                    return "Nome muito pequeno!";
                  }
                  return null;
                },
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
                  controller: carroController,
                  hintText: "Modelo do Veículo",
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return "Digite o modelo do veículo!";
                    }
                    return null;
                  }),
              FormfieldWidget(
                  controller: placaController,
                  hintText: "Placa do Veículo",
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return "Digite a placa do Veículo!";
                    }
                    return null;
                  }),
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () => cadastrarMotorista(
                      emailController.text, senhaController.text),
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => login(),
                child: const Text("Já tem conta? Faça o login!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
