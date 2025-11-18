import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({super.key, required this.message, required this.color, required this.icons});
  final String message;
  final Color color;
  final IconData icons;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(icons),
          const SizedBox(width: 10,),
          Text(
            message,
            style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
