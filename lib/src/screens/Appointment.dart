import 'package:doubles/src/widgets/button.dart';
import 'package:doubles/src/widgets/main_text.dart';
import 'package:doubles/src/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _pickTime() async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitAppointment() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      final appointmentDate = DateFormat.yMMMd().format(_selectedDate!);
      final appointmentTime = _selectedTime!.format(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Appointment booked on $appointmentDate at $appointmentTime'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields'),
      ));
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MainText(
          text: "Book Appointment",
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Date Picker
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : DateFormat.yMMMd().format(_selectedDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 10),

              // Time Picker
              ListTile(
                title: Text(_selectedTime == null
                    ? 'Select Time'
                    : _selectedTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              const SizedBox(height: 10),

              // Reason for Appointment using your custom TextFieldInput
              TextFieldInput(
                label: 'Reason for Appointment',
                hintText: 'Type your reason here...',
                controller: _reasonController,
                textarea: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reason';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Button(text: "Book Appointment", onTap: _submitAppointment,)
            ],
          ),
        ),
      ),
    );
  }
}
