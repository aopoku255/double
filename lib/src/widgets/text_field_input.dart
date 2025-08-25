import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final String label;
  final bool? isPasswordField;
  final bool textarea;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  // Dropdown support
  final List<String>? dropdownItems;
  final String? value;
  final void Function(String?)? onChanged;

  const TextFieldInput({
    super.key,
    required this.label,
    this.isPasswordField = false,
    this.hintText,
    this.textarea = false,
    this.controller,
    this.validator,
    this.dropdownItems,
    this.value,
    this.onChanged,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    bool isDropdown = widget.dropdownItems != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        isDropdown
            ? DropdownButtonFormField<String>(
          value: widget.dropdownItems!.contains(widget.value) ? widget.value : null,
          items: widget.dropdownItems!
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Select an option',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        )
            : TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: widget.isPasswordField == true ? _obscureText : false,
          cursorColor: Colors.black,
          maxLines: widget.isPasswordField == false
              ? (widget.textarea == true ? 5 : 1)
              : 1,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            suffixIcon: widget.isPasswordField == true
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}
