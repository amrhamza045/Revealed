import 'package:flutter/material.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.label,
  });
  final TextEditingController? controller;
  final TextInputType inputType;
  final String label;
  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.inputType,
            validator: (value) {
              return (value!.isEmpty) ? 'this field is Required' : null;
            },
            decoration: InputDecoration(
                border: InputBorder.none, hintText: widget.label),
          ),
        ),
      ),
    );
  }
}
