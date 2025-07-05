import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SendScreen extends StatelessWidget {
  const SendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Send'),
      ),
      body: const Center(
        child: Text('Send Screen'),
      )
    );
  }
}