import 'package:flutter/material.dart';

class RegistrationDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register for Event"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Your Name"),
          ),
          // You can add more fields here
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle form submission logic here
            print("Registered Name: ${_nameController.text}");
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text("Submit"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
