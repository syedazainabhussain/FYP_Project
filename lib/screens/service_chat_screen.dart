import 'package:flutter/material.dart';
import 'auto_assign.dart';

class ServiceChatScreen extends StatefulWidget {
  final String serviceType;

  const ServiceChatScreen({super.key, required this.serviceType});

  @override
  State<ServiceChatScreen> createState() => _ServiceChatScreenState();
}

class _ServiceChatScreenState extends State<ServiceChatScreen> {
  final Color primaryColor = const Color(0xFFFB3300);

  String? selectedProblem;
  String? vehicleMoving;
  String urgency = "Normal";
  bool isSubmitting = false;

  final TextEditingController noteController = TextEditingController();

  final Map<String, List<String>> problemOptions = {
    "Car Mechanic": [
      "Engine Issue",
      "AC Not Working",
      "Battery Problem",
      "Brake Issue",
    ],
    "Bike Mechanic": [
      "Self Start Problem",
      "Chain Issue",
      "Engine Noise",
    ],
    "Puncher": [
      "Flat Tyre",
      "Air Leakage",
      "Rim Issue",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "${widget.serviceType} Assistant",
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _botBubble("Tell us your problem"),
            _problemDropdown(),

            const SizedBox(height: 20),

            _botBubble("Is your vehicle moving?"),
            _yesNoButtons(),

            const SizedBox(height: 20),

            _botBubble("How urgent is this?"),
            _urgencyDropdown(),

            const SizedBox(height: 20),

            _botBubble("Additional details (optional)"),
            _noteField(),

            const SizedBox(height: 24),

            _summaryCard(),

            const SizedBox(height: 24),

            _confirmButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _botBubble(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _problemDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text("Select problem"),
          value: selectedProblem,
          isExpanded: true,
          items: problemOptions[widget.serviceType]!
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() => selectedProblem = value);
          },
        ),
      ),
    );
  }

  Widget _yesNoButtons() {
    return Row(
      children: [
        _choiceButton("Yes"),
        const SizedBox(width: 12),
        _choiceButton("No"),
      ],
    );
  }

  Widget _choiceButton(String value) {
    final bool selected = vehicleMoving == value;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => vehicleMoving = value);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _urgencyDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: urgency,
          isExpanded: true,
          items: ["Normal", "Urgent", "Emergency"]
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() => urgency = value!);
          },
        ),
      ),
    );
  }

  Widget _noteField() {
    return TextField(
      controller: noteController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Type here...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Summary",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text("Service: ${widget.serviceType}"),
          Text("Problem: ${selectedProblem ?? "-"}"),
          Text("Vehicle Moving: ${vehicleMoving ?? "-"}"),
          Text("Urgency: $urgency"),
          Text(
            "Notes: ${noteController.text.isEmpty ? "-" : noteController.text}",
          ),
        ],
      ),
    );
  }

  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isSubmitting
            ? null
            : () async {
                if (selectedProblem == null || vehicleMoving == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please complete required fields"),
                    ),
                  );
                  return;
                }

                setState(() => isSubmitting = true);

                // 🔴 API CALL FUTURE MEIN YAHAN ADD KAROGI

                await Future.delayed(const Duration(seconds: 1));

                setState(() => isSubmitting = false);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AutoAssignScreen(),
                  ),
                );
              },
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Confirm & Find Mechanic",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}