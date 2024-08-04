import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:task_list/main.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty_state.svg',
            width: 220,
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            'Your Task List Is Empty!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const CustomCheckBox({super.key, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: value ? null : Border.all(color: secondyTextColor, width: 2),
        ),
        child: value
            ? const Icon(
                Iconsax.tick_circle,
                color: primaryColor,
                size: 26,
              )
            : null,
      ),
    );
  }
}
