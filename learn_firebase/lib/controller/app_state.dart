import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase/firebase_options.dart';
import 'dart:async';
import 'package:learn_firebase/guest_book.dart';

import '../guest_message.dart';

// import 'firebase-options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _guestbookSubscription;
  List<GuestMessage> _guestBookMessage = [];
  List<GuestMessage> get guestBookMessage => _guestBookMessage;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _guestbookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((event) {
          _guestBookMessage = [];
          for (final document in event.docs) {
            _guestBookMessage.add(GuestMessage(
              message: document.data()['text'] as String,
              name: document.data()['name'] as String,
            ));
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addMessageToCollection(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged In');
    }
    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'timeStamp': DateTime.now().microsecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid
    });
  }
}
