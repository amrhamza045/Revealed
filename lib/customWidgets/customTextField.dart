import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.label,
  });
  final TextEditingController? controller;
  final TextInputType inputType;
  final String label;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.inputType,
            validator: (value) {
              return (value!.isEmpty) ? '${widget.label} is Required' : null;
            },
            enableInteractiveSelection: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.label,
              //alignLabelWithHint: false,
            ),
          ),
        ),
      ),
    );
  }
}
