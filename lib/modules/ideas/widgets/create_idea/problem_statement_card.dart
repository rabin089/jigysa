import 'package:flutter/material.dart';

class ProblemStatementCard extends StatelessWidget {
  final TextEditingController controller;
  const ProblemStatementCard({super.key, required this.controller});

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
          minLines: 4,
          maxLines: 8,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.segment),
            hintText: 'What problem are you solving? Why now?',
            border: OutlineInputBorder(borderSide: BorderSide.none),
            filled: true,
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Problem statement is required' : null,
        ),
      ),
    );
  }
}
