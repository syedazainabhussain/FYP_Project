import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicEarningsScreen extends StatefulWidget {
  const MechanicEarningsScreen({super.key});

  @override
  State<MechanicEarningsScreen> createState() =>
      _MechanicEarningsScreenState();
}

class _MechanicEarningsScreenState extends State<MechanicEarningsScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  // Dummy data for completed bookings
  List<Map<String, dynamic>> completedBookings = [
    {
      'userName': 'Ali Khan',
      'amount': 1200,
      'date': '12 Jan 2026',
    },
    {
      'userName': 'Sarah Ahmed',
      'amount': 2500,
      'date': '13 Jan 2026',
    },
    {
      'userName': 'Usman Ali',
      'amount': 3000,
      'date': '13 Jan 2026',
    },
  ];

  // Dummy pending bookings count
  int pendingBookings = 2;

  String today = '13 Jan 2026'; // example today date

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.grey;
    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black12;

    int totalEarnings = completedBookings.fold(
        0, (sum, b) => sum + (b['amount'] as int));
    int todaysEarnings = completedBookings
        .where((b) => b['date'] == today)
        .fold(0, (sum, b) => sum + (b['amount'] as int));
    int completedCount = completedBookings.length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          'Earnings',
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryCard('Total Earnings', 'PKR $totalEarnings', Colors.green, cardColor, shadowColor, textColor),
                _summaryCard('Today', 'PKR $todaysEarnings', Colors.blue, cardColor, shadowColor, textColor),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryCard('Completed', '$completedCount', Colors.green, cardColor, shadowColor, textColor),
                _summaryCard('Pending', '$pendingBookings', Colors.orange, cardColor, shadowColor, textColor),
              ],
            ),
            const SizedBox(height: 20),

            // Completed Bookings List Header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Completed Bookings',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Completed Bookings List
            Expanded(
              child: completedBookings.isEmpty
                  ? Center(
                      child: Text(
                        'No completed bookings',
                        style: GoogleFonts.poppins(fontSize: 16, color: subTextColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: completedBookings.length,
                      itemBuilder: (context, index) {
                        final b = completedBookings[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: shadowColor,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar with initials
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: primaryColor.withOpacity(0.2),
                                child: Text(
                                  b['userName']
                                      .toString()
                                      .split(' ')
                                      .map((e) => e[0])
                                      .take(2)
                                      .join(),
                                  style: GoogleFonts.poppins(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(b['userName'],
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: textColor)),
                                    const SizedBox(height: 4),
                                    Text('PKR ${b['amount']}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green)),
                                    const SizedBox(height: 2),
                                    Text(b['date'],
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: subTextColor)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Summary Card Widget
  Widget _summaryCard(String title, String value, Color valueColor, Color bgColor, Color shadowColor, Color textColor) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: shadowColor, blurRadius: 8)],
      ),
      child: Column(
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}
