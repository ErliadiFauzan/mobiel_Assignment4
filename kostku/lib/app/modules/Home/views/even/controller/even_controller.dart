import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoController {
  static Map<String, bool> claimedVouchers = {};  // Track voucher claims

  // Check if the user can claim the New Year voucher
  bool canClaimNewYearVoucher() {
    final currentDate = DateTime.now();
    return currentDate.year == 2024 && currentDate.month == 12 && currentDate.day == 31;
  }

  // Check if the user can claim the Christmas voucher
  bool canClaimChristmasVoucher() {
    final currentDate = DateTime.now();
    return currentDate.year == 2024 && currentDate.month == 12;
  }

  // Claim voucher logic (checks if the voucher is already claimed and if the date restrictions are met)
  Future<void> claimVoucher(BuildContext context, String voucherType) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(
        msg: "Please log in to claim the voucher.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    if (claimedVouchers[voucherType] == true) {
      // Show exception with Snackbar if voucher is already claimed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$voucherType has already been claimed."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      switch (voucherType) {
        case 'NewYear':
          if (canClaimNewYearVoucher()) {
            claimedVouchers[voucherType] = true;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('New Year Voucher claimed successfully!'),
              backgroundColor: Colors.green,
            ));
          } else {
            throw Exception("New Year Voucher can only be claimed on December 31, 2024.");
          }
          break;

        case 'Christmas':
          if (canClaimChristmasVoucher()) {
            claimedVouchers[voucherType] = true;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Christmas Voucher claimed successfully!'),
              backgroundColor: Colors.green,
            ));
          } else {
            throw Exception("Christmas Voucher can only be claimed in December 2024.");
          }
          break;

        case 'Free':
          claimedVouchers[voucherType] = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Free Voucher claimed successfully!'),
            backgroundColor: Colors.blue,
          ));
          break;

        default:
          throw Exception("Invalid voucher type.");
      }
    } catch (e) {
      // Display exception message in Snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
}
