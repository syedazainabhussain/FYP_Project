import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../user/auto_assign.dart';
import 'user_session.dart';

class ServiceChatScreen extends StatefulWidget {
  final String serviceType;
  final int id; // Initial parentID

  const ServiceChatScreen({
    super.key,
    required this.serviceType,
    required this.id,
  });

  @override
  State<ServiceChatScreen> createState() => _ServiceChatScreenState();
}

class _ServiceChatScreenState extends State<ServiceChatScreen> {
  final Color primaryColor = const Color(0xFFFB3300); // Deep Orange
  final Color arrowColor = const Color(0xFFFF6600); // Deep Orange for back arrow & icons
  final Color buttonBgColor = const Color(0xFFFB3300); // Deep Orange for Confirm button

  bool isLoading = true;
  bool isSubmitting = false;
  bool isFinished = false; // To show "Welcome" message

  List<Map<String, dynamic>> currentOptions = [];
  List<String> selectionPath = [];
  int? lastSelectedId;

  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOptions(widget.id);
  }

  Future<void> fetchOptions(int parentId) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        "https://mechanicapp-service-621632382478.asia-south1.run.app/api/subproblems/$parentId");

    try {
      final response = await http.get(
        url,
        headers: UserSession().getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        setState(() {
          if (data.isEmpty) {
            isFinished = true;
          } else {
            currentOptions = data
                .map((e) => {
                      "id": e["id"],
                      "text": e["text"],
                    })
                .toList();
          }
          isLoading = false;
        });
      } else {
        throw Exception("API Failed: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("API ERROR: $e");
    }
  }

  void _handleOptionSelect(Map<String, dynamic> option) {
    setState(() {
      selectionPath.add(option["text"]);
      lastSelectedId = option["id"];
    });
    fetchOptions(option["id"]);
  }

  void _resetSelection() {
    setState(() {
      selectionPath = [];
      lastSelectedId = null;
      isFinished = false;
    });
    fetchOptions(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // ================= Theme Colors =================
    final bgColor = isDark ? Colors.black : Colors.grey.shade100;
    final cardColor = isDark ? Colors.grey[850]! : Colors.grey[100]!;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.grey.shade700;
    final noteFieldColor = isDark ? Colors.grey[800]! : Colors.grey.shade200;
    final summaryBgColor = isDark ? Colors.grey[900]! : Colors.orange.shade50;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: arrowColor, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${widget.serviceType} Assistant",
          style:
              TextStyle(color: titleColor, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (selectionPath.isNotEmpty)
            IconButton(
              icon: Icon(Icons.refresh, color: arrowColor),
              onPressed: _resetSelection,
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _questionCard(
                      isFinished ? "Selection Complete" : "Tell us about your problem",
                      isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : isFinished
                              ? _welcomeMessage(cardColor, isDark)
                              : _optionsList(cardColor, textColor, subtitleColor),
                      cardColor,
                      titleColor,
                    ),
                    _questionCard(
                      "Additional details (optional)",
                      _noteField(noteFieldColor, textColor),
                      cardColor,
                      titleColor,
                    ),
                    const SizedBox(height: 16),
                    _summaryCard(summaryBgColor, textColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12), // Lift confirm button slightly
            _confirmButton(),
            const SizedBox(height: 6), // Extra padding from bottom
          ],
        ),
      ),
    );
  }

  // ================= Widgets =================

  Widget _optionsList(Color cardColor, Color textColor, Color subtitleColor) {
    if (currentOptions.isEmpty) {
      return Text("No options available", style: TextStyle(color: textColor));
    }

    return Column(
      children: currentOptions.map((option) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: cardColor,
              alignment: Alignment.centerLeft,
            ),
            onPressed: () => _handleOptionSelect(option),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                      Text(option["text"], style: TextStyle(color: textColor, fontSize: 15)),
                ),
                Icon(Icons.chevron_right, color: subtitleColor, size: 20),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _welcomeMessage(Color cardColor, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 12),
          Text(
            "Welcome!",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            "We have all the details we need.",
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          ),
          TextButton(
            onPressed: _resetSelection,
            child: Text(
              "Change Selection",
              style: TextStyle(color: arrowColor),
            ),
          )
        ],
      ),
    );
  }

  Widget _questionCard(String title, Widget child, Color cardColor, Color titleColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: titleColor)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _noteField(Color bgColor, Color textColor) {
    return TextField(
      controller: noteController,
      maxLines: 3,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: "Type here...",
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (v) => setState(() {}),
    );
  }

  Widget _summaryCard(Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          Divider(color: primaryColor),
          _summaryRow("Service", widget.serviceType, textColor),
          if (selectionPath.isNotEmpty)
            _summaryRow("Selection", selectionPath.join(" > "), textColor),
          _summaryRow(
              "Notes", noteController.text.isEmpty ? "-" : noteController.text, textColor),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Text("$label:", style: TextStyle(fontWeight: FontWeight.w600, color: textColor))),
          Expanded(flex: 3, child: Text(value, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }

  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBgColor, // Deep orange background
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: isSubmitting || (!isFinished && selectionPath.isEmpty)
            ? null
            : () async {
                setState(() => isSubmitting = true);
                await Future.delayed(const Duration(seconds: 1));
                setState(() => isSubmitting = false);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AutoAssignScreen()),
                );
              },
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Confirm & Find Mechanic",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Text white
              ),
      ),
    );
  }
}
