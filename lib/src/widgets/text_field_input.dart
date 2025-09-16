import 'dart:math';
import 'package:doubles/src/themes/colors.dart';
import 'package:doubles/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class TextFieldInput extends StatefulWidget {
  final String label;
  final bool? isPasswordField;
  final bool textarea;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? enable;
  final bool? passwordGenerator;

  // Dropdown support
  final List<String>? dropdownItems;
  final String? value;
  final void Function(String?)? onChanged;

  // Phone field support
  final bool isPhoneField;
  final String initialCountryCode;
  final void Function(String)? onPhoneChanged;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const TextFieldInput({
    super.key,
    required this.label,
    this.isPasswordField = false,
    this.textarea = false,
    this.hintText,
    this.controller,
    this.validator,
    this.dropdownItems,
    this.value,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.isPhoneField = false,
    this.initialCountryCode = "GH",
    this.onPhoneChanged,
    this.enable = true,
    this.passwordGenerator = false,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    bool isDropdown = widget.dropdownItems != null;
    bool isPhone = widget.isPhoneField;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        if (isDropdown)
          DropdownButtonFormField<String>(
            value: widget.dropdownItems!.contains(widget.value)
                ? widget.value
                : null,
            items: widget.dropdownItems!
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
            onChanged: widget.onChanged,
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction, // ✅ Added
            decoration: _inputDecoration(widget.hintText ?? 'Select an option'),
          )
        else if (isPhone)
          IntlPhoneField(
            controller: widget.controller,
            initialCountryCode: widget.initialCountryCode,
            decoration: _inputDecoration(widget.hintText ?? "Phone Number"),
            enabled: widget.enable!,
            autovalidateMode: AutovalidateMode.onUserInteraction, // ✅ Added
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onChanged: (phone) {
              widget.onPhoneChanged?.call(phone.completeNumber);
            },
            validator: (value) {
              if (value == null || value.number.isEmpty) {
                return 'Phone Number is required';
              }
              if (value.number.length < 9) {
                return 'Enter a valid phone number';
              }
              return null;
            },
          )
        else
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText:
            widget.isPasswordField == true ? _obscureText : false,
            autovalidateMode: AutovalidateMode.onUserInteraction, // ✅ Added
            cursorColor: Colors.black,
            enabled: widget.enable,
            maxLines: widget.isPasswordField == false
                ? (widget.textarea == true ? 5 : 1)
                : 1,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            decoration: _inputDecoration(widget.hintText).copyWith(
              suffixIcon: widget.isPasswordField == true
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Password generator button
                  widget.passwordGenerator! ?Button(
                    text: "Generate",
                    width: 70,
                    fontSize: 10,
                    height: 30,
                    radius: 4,
                    color: AppColors.primaryBtn,
                    onTap: () {
                      final newPassword = _generatePassword();
                      widget.controller?.text = newPassword;
                      setState(() {
                        _obscureText =
                        false; // Show password after generation
                      });
                    },
                  ) : Container(),
                  // Visibility toggle
                  IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.primaryBtn,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ],
              )
                  : null,
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 2,
        ),
      ),
    );
  }

  /// Secure random password generator with required constraints
  String _generatePassword({int length = 12}) {
    const lower = 'abcdefghijklmnopqrstuvwxyz';
    const upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';
    const special = '!@#\$%^&*()_-+=<>?';

    final rand = Random.secure();

    // Ensure at least 1 from each category
    String password = '';
    password += upper[rand.nextInt(upper.length)];
    password += numbers[rand.nextInt(numbers.length)];
    password += special[rand.nextInt(special.length)];
    password += lower[rand.nextInt(lower.length)];

    // Fill remaining with all possible chars
    const all = lower + upper + numbers + special;
    for (int i = password.length; i < length; i++) {
      password += all[rand.nextInt(all.length)];
    }

    // Shuffle password to randomize order
    List<String> chars = password.split('')..shuffle(rand);
    return chars.join();
  }
}
