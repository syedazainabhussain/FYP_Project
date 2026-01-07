import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  // Profile info
  String userName = 'Ali Khan';
  String profession = 'Car & Bike Mechanic';
  String email = 'ali.khan@example.com';
  String phone = '0301-1234567';
  String location = 'Lahore, Pakistan';
  String skills = 'Car Repair, Bike Repair';

  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  // Pick Image
  Future<void> _pickImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  // Open Edit Profile Modal
  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: userName);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController locationController =
        TextEditingController(text: location);
    TextEditingController skillsController = TextEditingController(text: skills);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : Colors.black;
        final hintColor = isDark ? Colors.white70 : Colors.black54;
        final fillColor = isDark ? Colors.grey.shade900 : Colors.grey.shade100;

        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Profile',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textColor)),
                  const SizedBox(height: 20),
                  _editTextField('Name', nameController, fillColor, textColor, hintColor),
                  _editTextField('Email', emailController, fillColor, textColor, hintColor),
                  _editTextField('Phone', phoneController, fillColor, textColor, hintColor),
                  _editTextField('Location', locationController, fillColor, textColor, hintColor),
                  _editTextField('Skills', skillsController, fillColor, textColor, hintColor),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        userName = nameController.text;
                        email = emailController.text;
                        phone = phoneController.text;
                        location = locationController.text;
                        skills = skillsController.text;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Save Changes',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _editTextField(String label, TextEditingController controller, Color fillColor, Color textColor, Color hintColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14, color: textColor),
          filled: true,
          fillColor: fillColor,
          hintStyle: TextStyle(color: hintColor),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5), // ✅ Deep Orange
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2), // ✅ Deep Orange
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    // ignore: unused_local_variable
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final iconBgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade100;
    final iconColor = isDark ? Colors.white70 : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 1,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!) as ImageProvider
                              : const AssetImage('assets/profile.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.camera_alt,
                                color: primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profession,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Profile Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _profileInfoRow(Icons.person, userName, iconBgColor, iconColor, textColor),
                    _divider(isDark),
                    _profileInfoRow(Icons.email, email, iconBgColor, iconColor, textColor),
                    _divider(isDark),
                    _profileInfoRow(Icons.phone, phone, iconBgColor, iconColor, textColor),
                    _divider(isDark),
                    _profileInfoRow(Icons.location_on, location, iconBgColor, iconColor, textColor),
                    _divider(isDark),
                    _profileInfoRow(Icons.build, skills, iconBgColor, iconColor, textColor),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Edit Profile Button
              ElevatedButton.icon(
                onPressed: _editProfile,
                icon: Icon(Icons.edit, size: 18),
                label: Text('Edit Profile',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: primaryColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Info Row
  Widget _profileInfoRow(IconData icon, String text, Color iconBgColor, Color iconColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(bool isDark) {
    return Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300, thickness: 1);
  }
}
