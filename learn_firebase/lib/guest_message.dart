import 'package:flutter/material.dart';

class GuestMessage extends StatefulWidget {
  const GuestMessage({Key? key, required this.name, required this.message,}) : super(key: key);

  final String name;
  final String message;


  @override
  State<GuestMessage> createState() => _GuestMessageState();
}

class _GuestMessageState extends State<GuestMessage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
