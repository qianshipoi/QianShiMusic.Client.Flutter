import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  final String descrition;
  const Description({
    Key? key,
    required this.descrition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: SingleChildScrollView(child: Text(descrition)),
      ),
    );
  }
}
