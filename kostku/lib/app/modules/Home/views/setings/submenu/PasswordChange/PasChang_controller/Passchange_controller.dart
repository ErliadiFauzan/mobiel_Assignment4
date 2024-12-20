import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Pastikan untuk mengimpor GetX

class ChangePasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // Verifikasi bahwa password baru dan konfirmasi password sama
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password baru dan konfirmasi password tidak cocok')),
        );
        return;
      }

      // Ambil pengguna yang sedang login
      User? user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengguna tidak ditemukan')),
        );
        return;
      }

      // Verifikasi password saat ini
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Re-authenticate pengguna untuk mengubah password
      await user.reauthenticateWithCredential(credential);

      // Ubah password
      await user.updatePassword(newPassword);

      // Beri tahu pengguna bahwa password berhasil diubah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password berhasil diubah')),
      );

      // Logout dan arahkan ke halaman login
      await _auth.signOut();
      Get.offNamed('/login'); // Pastikan rute '/login' sesuai dengan pengaturan rute Anda
    } catch (e) {
      // Tangani error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }
}
