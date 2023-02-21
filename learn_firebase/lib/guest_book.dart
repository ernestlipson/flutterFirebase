import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learn_firebase/widgets.dart';

import 'guest_message.dart';

class GuestBook extends StatefulWidget {
  const GuestBook({Key? key, required this.addMessage, required this.messages}) : super(key: key);

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestMessage> messages;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Leave A Message'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to Continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                       Text('Send'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var message in widget.messages) Paragraph('${message.name} : ${message.message}'),
        const SizedBox(height: 8),
      ],
    );
  }
}
