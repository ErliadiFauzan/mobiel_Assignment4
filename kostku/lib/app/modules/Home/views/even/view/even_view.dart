import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PromoDetailView extends StatelessWidget {
  final PromoController promoController = PromoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Promo'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Promo Tahun Baru 2025!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Dapatkan diskon spesial sebesar 40% untuk semua kamar kos di aplikasi Budikost. Berlaku hanya pada 31 Desember 2024!',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Image.asset(
                'assets/Google.png', // Ganti dengan path gambar promo yang valid
                height: 120,  // Smaller image size to fit well in the layout
                width: double.infinity, // Full width of screen
                fit: BoxFit.cover, // Make sure the image doesn't overflow
              ),
              SizedBox(height: 16),
              Text(
                'Syarat dan Ketentuan:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1. Promo berlaku hanya untuk pemesanan pada tanggal 31 Desember 2024.\n'
                    '2. Diskon berlaku untuk semua kamar kos.\n'
                    '3. Promo tidak dapat digabungkan dengan promo lainnya.\n'
                    '4. Pemesanan harus dilakukan melalui aplikasi Budikost.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),

              // Voucher Cards Section
              _buildVoucherCard(context, 'NewYear', 'Voucher Tahun Baru - Claim only on 31 Dec 2024'),
              SizedBox(height: 16),
              _buildVoucherCard(context, 'Christmas', 'Voucher Natal - Claim only in Dec 2024'),
              SizedBox(height: 16),
              _buildVoucherCard(context, 'Free', 'Voucher Bebas - Can be claimed anytime'),
            ],
          ),
        ),
      ),
    );
  }

  // This function builds a consistent and flexible card size for each voucher
  Widget _buildVoucherCard(BuildContext context, String voucherType, String description) {
    return Container(
      width: double.infinity,  // Ensures card takes full width of screen
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Ensures card height adjusts based on content
          children: [
            ListTile(
              title: Text(
                voucherType == 'NewYear' ? 'Voucher Tahun Baru' :
                voucherType == 'Christmas' ? 'Voucher Natal' : 'Voucher Bebas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            // Ensure the image is small, consistent, and responsive
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/Google.png', // Small voucher image path
                height: 50,  // Fixed height for the image
                width: 50,   // Fixed width for the image
                fit: BoxFit.contain, // Ensures it scales and doesn't overflow
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await promoController.claimVoucher(context, voucherType);
              },
              child: Text('Claim Voucher'),
            ),
          ],
        ),
      ),
    );
  }
}

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
