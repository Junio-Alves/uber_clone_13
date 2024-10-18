import 'package:flutter/material.dart';

class UnknownPage extends StatefulWidget {
  const UnknownPage({super.key});

  @override
  State<UnknownPage> createState() => _UnknownPageState();
}

class _UnknownPageState extends State<UnknownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Pagina não encontrada!"),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar"),
            )
          ],
        ),
      ),
    );
  }
}
