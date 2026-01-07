import 'package:flutter/material.dart';
import 'package:mech_app/main.dart';
import 'homescreen.dart';
import '../authentication/map_screen.dart';

class AutoAssignScreen extends StatelessWidget {
  const AutoAssignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = themeNotifier.value == ThemeMode.dark;

    // Show bottom sheet after frame build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAutoAssignOptions(context, isDark);
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: isDark
            ? Colors.black.withOpacity(0.6)
            : Colors.white, // Changed to full white for light mode default
        body: const SizedBox.shrink(),
      ),
    );
  }

  void _showAutoAssignOptions(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: isDark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                // drag handle
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  "Choose Service",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  "We will auto assign nearest mechanic",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),

                // Service options
                _serviceCard(
                  context,
                  title: "Bike Mechanic",
                  icon: Icons.motorcycle,
                  service: "Bike",
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _serviceCard(
                  context,
                  title: "Car Mechanic",
                  icon: Icons.directions_car,
                  service: "Car",
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
                _serviceCard(
                  context,
                  title: "Puncture Service",
                  icon: Icons.build_circle,
                  service: "Puncture",
                  isDark: isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _serviceCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String service,
    required bool isDark,
  }) {
    final Color primaryColor = const Color(0xFFFB3300); // Deep orange

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MapScreen(serviceType: service),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          boxShadow: [
            if (!isDark)
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: primaryColor.withOpacity(0.15),
              child: Icon(icon, color: primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: isDark ? Colors.white70 : Colors.grey),
          ],
        ),
      ),
    );
  }
}