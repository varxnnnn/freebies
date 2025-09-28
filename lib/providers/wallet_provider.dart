// lib/providers/wallet_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletProvider with ChangeNotifier {
  int _walletAmount = 0; // We keep this name for UI clarity ("wallet" = points)
  bool _isLoading = true;

  int get walletAmount => _walletAmount;
  bool get isLoading => _isLoading;

  Future<void> fetchWalletAmount() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          // 🔥 Fetch 'points' from Firestore (not 'wallet')
          _walletAmount = doc.data()?['points'] ?? 0;
        } else {
          _walletAmount = 0;
        }
      } else {
        _walletAmount = 0;
      }
    } catch (e) {
      _walletAmount = 0;
    }

    _isLoading = false;
    notifyListeners();
  }
}