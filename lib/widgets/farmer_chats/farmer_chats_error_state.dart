import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/language_provider.dart';

class FarmerChatsErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const FarmerChatsErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: darkGreen,
      onRefresh: onRetry,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 100),
          Container(
            height: 80,
            width: 80,
            margin: const EdgeInsets.symmetric(horizontal: 120),
            decoration: const BoxDecoration(
              color: Color(0xffffeeee),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline_rounded, size: 42, color: Colors.red),
          ),
          const SizedBox(height: 18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Center(
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.watch<LanguageProvider>().t('retry')),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
