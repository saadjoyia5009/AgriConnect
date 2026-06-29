import 'package:flutter/material.dart';
import '../shared/notification_screen.dart';

class BuyerNotificationScreen extends StatelessWidget {
  const BuyerNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationScreen(
      userRole: "buyer",
    );
  }
}