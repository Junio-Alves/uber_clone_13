import 'package:flutter/material.dart';
import 'package:uber_clone_13/widgets/formField_widget.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  login() {
    Navigator.pushNamed(context, "/login");
  }

  cadastrar() {
    if (_formKey.currentState!.validate()) {}
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
          "Cadastro",
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
                  "Cadastro",
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
                  }
                  return null;
                },
              ),
              FormfieldWidget(
                controller: emailController,
                hintText: "E-mail",
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return "Digite um email!";
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
                  onPressed: () => cadastrar(),
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
