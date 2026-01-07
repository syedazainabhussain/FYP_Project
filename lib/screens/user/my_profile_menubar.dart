import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'homescreen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _profileImage;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? 'User Name';
      _emailController.text = prefs.getString('email') ?? 'user@email.com';
      _cityController.text = prefs.getString('city') ?? 'Karachi';
      _phoneController.text = prefs.getString('phone') ?? '0300XXXXXXX';

      final imagePath = prefs.getString('profileImage');
      if (imagePath != null) _profileImage = File(imagePath);
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('phone', _phoneController.text);

    if (_profileImage != null) {
      await prefs.setString('profileImage', _profileImage!.path);
    }

    setState(() => _editing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
        ),
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            /// PROFILE IMAGE
            Stack(
              children: [
                CircleAvatar(
                  radius: 58,
                  backgroundColor: primaryColor.withOpacity(0.2),
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? Icon(Icons.person, size: 60, color: primaryColor)
                      : null,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _editing ? _pickImage : null,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: primaryColor,
                      child: const Icon(Icons.add,
                          size: 18, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 30),

            _profileField(
              label: "Full Name",
              controller: _nameController,
              enabled: _editing,
              isDark: isDark,
              cardColor: cardColor,
            ),
            _profileField(
              label: "Email Address",
              controller: _emailController,
              enabled: _editing,
              isDark: isDark,
              cardColor: cardColor,
            ),
            _profileField(
              label: "City",
              controller: _cityController,
              enabled: _editing,
              isDark: isDark,
              cardColor: cardColor,
            ),
            _profileField(
              label: "Phone Number",
              controller: _phoneController,
              enabled: _editing,
              isDark: isDark,
              cardColor: cardColor,
            ),

            const SizedBox(height: 35),

            if (_editing)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveProfileData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              TextButton.icon(
                onPressed: () => setState(() => _editing = true),
                icon: Icon(Icons.edit, color: primaryColor),
                label: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(
                      color: primaryColor, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _profileField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required bool isDark,
    required Color cardColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: GoogleFonts.poppins(
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          suffixIcon:
              Icon(Icons.edit, color: enabled ? primaryColor : Colors.grey),
          filled: true,
          fillColor: cardColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: primaryColor.withOpacity(0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                BorderSide(color: primaryColor.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }
}
