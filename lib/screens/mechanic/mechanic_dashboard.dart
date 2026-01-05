import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicDashboardScreen extends StatefulWidget {
  const MechanicDashboardScreen({super.key});

  @override
  State<MechanicDashboardScreen> createState() =>
      _MechanicDashboardScreenState();
}

class _MechanicDashboardScreenState extends State<MechanicDashboardScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  List<Map<String, dynamic>> requests = [
    {
      'user': 'Ali Khan',
      'service': 'Car Mechanic',
      'status': 'Pending',
      'distance': 2.5,
      'earnings': 1200,
      'timer': 60,
    },
    {
      'user': 'Sarah Ahmed',
      'service': 'Bike Mechanic',
      'status': 'Pending',
      'distance': 3.2,
      'earnings': 800,
      'timer': 60,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double totalEarnings =
        requests.fold(0, (sum, r) => sum + r['earnings']);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Mechanic Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active_outlined,
                color: primaryColor),
            onPressed: _openNotifications,
          ),
        ],
      ),

      /// 🔥 UPDATED DRAWER (PROFILE KE NEECHE OPTIONS)
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: primaryColor.withOpacity(0.15),
                      child: Icon(Icons.build,
                          size: 34, color: primaryColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mechanic Panel',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(),

              /// MAIN OPTIONS
              _drawerItem(Icons.dashboard_outlined, 'Dashboard'),
              _drawerItem(Icons.receipt_long_outlined, 'Booking Requests'), // ✅ Updated icon
              _drawerItem(Icons.payment_outlined, 'Earnings'),
              _drawerItem(Icons.person_outline, 'Profile'),

              /// 🔻 LINE PROFILE KE FORAN BAAD
              const Divider(),

              /// SETTINGS + LOGOUT
              _drawerItem(Icons.settings_outlined, 'Settings'),
              _drawerItem(Icons.logout, 'Logout'),

              /// SWITCH MODE BUTTON
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(
                      'Switch to User Mode',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      /// BODY (UNCHANGED)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [primaryColor, Colors.deepOrange],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Earnings',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'PKR ${totalEarnings.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// NOTIFICATIONS
  void _openNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        Timer? timer;
        return StatefulBuilder(
          builder: (context, setModalState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (_) {
              setModalState(() {
                for (var r in requests) {
                  if (r['status'] == 'Pending' && r['timer'] > 0) {
                    r['timer']--;
                  }
                }
              });
            });

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: requests.map((r) {
                  return ListTile(
                    title: Text(r['user'],
                        style: GoogleFonts.poppins()),
                    subtitle: Text(
                        '${r['service']} • ${r['distance']} km'),
                    trailing: Text(
                      '${r['timer']}s',
                      style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(title, style: GoogleFonts.poppins()),
      onTap: () => Navigator.pop(context),
    );
  }
}
