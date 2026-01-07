// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicSettingsScreen extends StatefulWidget {
  const MechanicSettingsScreen({super.key, required bool isDarkMode, required Null Function(dynamic val) onThemeChanged});

  @override
  State<MechanicSettingsScreen> createState() => _MechanicSettingsScreenState();
}

class _MechanicSettingsScreenState extends State<MechanicSettingsScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  bool notificationsEnabled = true;

  final TextEditingController emailController =
      TextEditingController(text: 'mechanic@example.com');
  final TextEditingController phoneController =
      TextEditingController(text: '0301-1234567');

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey[700];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ACCOUNT INFO
            Text('Account',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 15),
            _inputField('Email', emailController, textColor),
            const SizedBox(height: 10),
            _inputField('Phone Number', phoneController, textColor),
            const SizedBox(height: 20),

            // CHANGE PASSWORD
            Text('Change Password',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 15),
            _passwordField('New Password', newPasswordController, textColor),
            const SizedBox(height: 10),
            _passwordField('Confirm New Password', confirmPasswordController, textColor),
            const SizedBox(height: 20),

            // PREFERENCES
            Text('Preferences',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 15),
            SwitchListTile(
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
              },
              title:
                  Text('Enable Notifications', style: GoogleFonts.poppins(color: textColor)),
              activeColor: primaryColor,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 20),

            // SERVICE PREFERENCES
            Text('Service Preferences',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 15),
            _checkboxOption('Car Services', textColor),
            _checkboxOption('Bike Services', textColor),
            _checkboxOption('Puncher Services', textColor),
            const SizedBox(height: 30),

            // SAVE CHANGES BUTTON
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings saved!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Save Changes',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),

            // DELETE ACCOUNT BUTTON
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteAccountDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Delete Account',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ------------------- INPUT FIELD -------------------
  Widget _inputField(String label, TextEditingController controller, Color textColor) {
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: textColor.withOpacity(0.6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }

  // ------------------- PASSWORD FIELD -------------------
  Widget _passwordField(
      String label, TextEditingController controller, Color textColor) {
    bool _obscure = true;
    return StatefulBuilder(
      builder: (context, setStateSB) {
        return TextField(
          controller: controller,
          obscureText: _obscure,
          style: GoogleFonts.poppins(color: textColor),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(color: textColor.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                  color: primaryColor),
              onPressed: () {
                setStateSB(() {
                  _obscure = !_obscure;
                });
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        );
      },
    );
  }

  // ------------------- CHECKBOX OPTION -------------------
  Widget _checkboxOption(String title, Color textColor) {
    bool checked = false;
    return StatefulBuilder(
      builder: (context, setStateSB) {
        return CheckboxListTile(
          value: checked,
          onChanged: (val) {
            setStateSB(() {
              checked = val!;
            });
          },
          title: Text(title, style: GoogleFonts.poppins(color: textColor)),
          activeColor: primaryColor,
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }

  // ------------------- DELETE ACCOUNT DIALOG -------------------
  void _showDeleteAccountDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Account',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Text('Do you really want to delete your account?',
                style: GoogleFonts.poppins()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',
                      style: GoogleFonts.poppins(color: primaryColor))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteAccount();
                  },
                  child: Text('Yes',
                      style: GoogleFonts.poppins(color: Colors.red))),
            ],
          );
        });
  }

  void _deleteAccount() {
    // Account deletion logic here
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Account deleted!')));
    // After deletion, you may redirect user to login or another screen
  }
}
