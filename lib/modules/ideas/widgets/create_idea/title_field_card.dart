import 'package:flutter/material.dart';

class TitleFieldCard extends StatelessWidget {
  final TextEditingController controller;
  const TitleFieldCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.title),
            hintText: 'Give your idea a clear, concise title',
            border: OutlineInputBorder(borderSide: BorderSide.none),
            filled: true,
          ),
          textInputAction: TextInputAction.next,
          maxLength: 120,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
        ),
      ),
    );
  }
}
