import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.label,
  });
  final TextEditingController? controller;
  final TextInputType inputType;
  final String label;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

bool _visable = true;

class _PasswordTextFieldState extends State<PasswordTextField> {
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
            obscureText: _visable,
            validator: (value) {
              return (value!.isEmpty) ? 'Password is Required' : null;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.label,
              // labelText: 'Password',
              floatingLabelAlignment: FloatingLabelAlignment.center,
              suffixIcon: IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined),
                onPressed: () {
                  setState(
                    () {
                      _visable = _visable ? false : true;
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
