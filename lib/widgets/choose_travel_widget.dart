import 'package:flutter/material.dart';

class ChooseTravelWidget extends StatefulWidget {
  final String userName;
  final VoidCallback search;
  const ChooseTravelWidget({
    super.key,
    required this.userName,
    required this.search,
  });

  @override
  State<ChooseTravelWidget> createState() => _ChooseTravelWidgetState();
}

class _ChooseTravelWidgetState extends State<ChooseTravelWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            "Bom dia,${widget.userName}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextFormField(
            onTap: () => widget.search(),
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.search),
              hintText: "Para onde você quer ir?",
              focusColor: Colors.black,
              filled: true,
              fillColor: Colors.grey.shade200,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )
      ],
    );
  }
}
