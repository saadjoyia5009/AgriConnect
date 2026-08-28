import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/inquiry_model.dart';
import '../../providers/inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/farmer_inquiry_detail/farmer_inquiry_detail_header.dart';
import '../../widgets/farmer_inquiry_detail/farmer_inquiry_buyer_card.dart';
import '../../widgets/farmer_inquiry_detail/farmer_inquiry_crop_card.dart';
import '../../widgets/farmer_inquiry_detail/farmer_inquiry_message_section.dart';
import '../../widgets/farmer_inquiry_detail/farmer_inquiry_action_button.dart';
import '../chat/chat_detail_screen.dart';

class FarmerInquiryDetailScreen extends StatelessWidget {
  final String inquiryId;

  const FarmerInquiryDetailScreen({
    super.key,
    required this.inquiryId,
  });

  static const Color darkGreen = Color(0xff075739);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InquiryProvider>(context);
    final lang = context.watch<LanguageProvider>();
    final InquiryModel? inquiry = provider.getInquiryById(inquiryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (inquiry == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: Text(
              lang.t("inquiryNotFound"),
              style: TextStyle(
                color: isDark ? Colors.white : darkGreen,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }

    final bool isPending =
        inquiry.status.toLowerCase() == "pending";

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff101512)
          : const Color(0xfff7fbf8),
      body: SafeArea(
        child: Column(
          children: [
            FarmerInquiryDetailHeader(
              title: lang.t("inquiryDetails"),
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FarmerInquiryBuyerCard(inquiry: inquiry),
                    const SizedBox(height: 18),
                    FarmerInquiryCropCard(inquiry: inquiry),
                    const SizedBox(height: 26),
                    FarmerInquiryMessageSection(
                      message: inquiry.message,
                      title: lang.t("message"),
                    ),
                    const SizedBox(height: 24),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark
                          ? Colors.white12
                          : const Color(0xffdfe9e3),
                    ),
                    const SizedBox(height: 18),

                    if (isPending) ...[
                      FarmerInquiryActionButton(
                        title: lang.t("acceptInquiry"),
                        icon: Icons.check_circle_outline_rounded,
                        backgroundColor: darkGreen,
                        textColor: Colors.white,
                        onTap: () async {
                          await provider.acceptInquiry(inquiry.id);

                          if (!context.mounted) return;

                          _showSnack(
                            context,
                            lang.t("inquiryAcceptedSuccessfully"),
                          );

                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 10),
                      FarmerInquiryActionButton(
                        title: lang.t("decline"),
                        icon: Icons.cancel_outlined,
                        backgroundColor: isDark
                            ? Theme.of(context).cardColor
                            : Colors.white,
                        textColor: isDark
                            ? Colors.white
                            : darkGreen,
                        borderColor: isDark
                            ? Colors.white24
                            : const Color(0xff49c982),
                        onTap: () async {
                          await provider.rejectInquiry(inquiry.id);

                          if (!context.mounted) return;

                          _showSnack(
                            context,
                            lang.t("inquiryDeclined"),
                          );

                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],

                    FarmerInquiryActionButton(
                      title: lang.t("messageBuyer"),
                      icon: Icons.chat_bubble_outline_rounded,
                      backgroundColor: isPending
                          ? (isDark
                          ? Theme.of(context).cardColor
                          : const Color(0xffe7eee9))
                          : darkGreen,
                      textColor: isPending
                          ? (isDark
                          ? Colors.white
                          : const Color(0xff222222))
                          : Colors.white,
                      borderColor: isPending
                          ? (isDark
                          ? Colors.white12
                          : const Color(0xffdce7df))
                          : darkGreen,
                      onTap: () {
                        if (inquiry.status.toLowerCase() == "accepted") {
                          final currentUserId = context
                              .read<AuthProvider>()
                              .userId
                              ?.toString() ??
                              '';

                          if (currentUserId.isEmpty) {
                            _showSnack(
                              context,
                              context
                                  .read<LanguageProvider>()
                                  .t("loginInformationNotFound"),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(
                                conversationId: inquiry.conversationId,
                                inquiryId: inquiry.id,
                                currentUserId: currentUserId,
                                otherUserId: inquiry.buyerId,
                                otherUserName: inquiry.buyerName,
                                cropName: inquiry.cropName,
                                cropImageUrl: inquiry.cropImage,
                                quantity: inquiry.requestedQuantity,
                                offeredPrice: inquiry.proposedPrice,
                                cropUnit: inquiry.cropUnit,
                                status: inquiry.status,
                              ),
                            ),
                          );
                        } else {
                          _showSnack(
                            context,
                            context
                                .read<LanguageProvider>()
                                .t("chatAcceptedOnly"),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
