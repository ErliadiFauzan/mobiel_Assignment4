import 'package:flutter/material.dart';
import '../Controller/Register_controller.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _userRole = 'Pencari';

  final RegisterController _registerController = RegisterController();

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kata sandi tidak cocok')),
        );
        return;
      }
      _registerController.registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        role: _userRole,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('Nama Depan', _firstNameController),
                SizedBox(height: 16.0),
                _buildTextField('Nama Belakang', _lastNameController),
                SizedBox(height: 16.0),
                _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                SizedBox(height: 16.0),
                _buildPasswordField('Kata Sandi', _passwordController, isPasswordVisible: _isPasswordVisible, onToggleVisibility: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }),
                SizedBox(height: 16.0),
                _buildPasswordField('Ulangi Kata Sandi', _confirmPasswordController, isPasswordVisible: _isConfirmPasswordVisible, onToggleVisibility: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),
                SizedBox(height: 16.0),
                _buildRoleDropdown(),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _onRegister,
                  child: Text('Daftar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, {required bool isPasswordVisible, required VoidCallback onToggleVisibility}) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[300],
        suffixIcon: IconButton(
          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _userRole,
      items: ['Pencari', 'Pemilik'].map((role) {
        return DropdownMenuItem<String>(
          value: role,
          child: Text(role),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _userRole = value!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Daftar sebagai',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[300],
      ),
    );
  }
}
