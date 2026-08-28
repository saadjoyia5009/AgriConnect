import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../providers/inquiry_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/farmer_bottom_navbar.dart';
import '../../widgets/farmer_inquiries/farmer_inquiry_card.dart';
import '../../widgets/farmer_inquiries/farmer_inquiry_empty_state.dart';
import '../../widgets/farmer_inquiries/farmer_inquiry_error_state.dart';
import '../../widgets/farmer_inquiries/farmer_inquiry_filter_row.dart';
import '../../widgets/farmer_inquiries/farmer_inquiries_header.dart';
import '../../widgets/farmer_inquiries/farmer_inquiries_hero.dart';
import 'farmer_inquiry_detail_screen.dart';

class FarmerInquiriesScreen extends StatefulWidget {
  const FarmerInquiriesScreen({super.key});

  @override
  State<FarmerInquiriesScreen> createState() =>
      _FarmerInquiriesScreenState();
}

class _FarmerInquiriesScreenState extends State<FarmerInquiriesScreen> {
  static const Color darkGreen = Color(0xff075739);

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<InquiryProvider>().fetchFarmerInquiries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff0d1511)
          : const Color(0xfff5faf7),
      bottomNavigationBar: const FarmerBottomNavbar(
        currentIndex: 3,
      ),
      body: Column(
        children: [
          FarmerInquiriesHeader(
            title: lang.t("inquiries"),
          ),
          Expanded(
            child: Consumer<InquiryProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: darkGreen,
                    ),
                  );
                }

                if (provider.errorMessage != null) {
                  return FarmerInquiryErrorState(
                    message: provider.errorMessage!,
                    onRetry: provider.fetchFarmerInquiries,
                  );
                }

                return RefreshIndicator(
                  color: darkGreen,
                  onRefresh: provider.fetchFarmerInquiries,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FarmerInquiriesHero(
                          title: lang.t("receivedInquiries"),
                          subtitle: lang.t("receivedInquiriesSubtitle"),
                        ),
                        const SizedBox(height: 20),
                        FarmerInquiryFilterRow(
                          selectedFilter: provider.selectedFilter,
                          onFilterChanged: provider.changeFilter,
                        ),
                        const SizedBox(height: 13),
                        Text(
                          "${lang.t("inquiries")}: ${provider.filteredInquiries.length}",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xff202622),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (provider.filteredInquiries.isEmpty)
                          const FarmerInquiryEmptyState()
                        else
                          ListView.builder(
                            itemCount: provider.filteredInquiries.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final inquiry =
                              provider.filteredInquiries[index];

                              return FarmerInquiryCard(
                                inquiry: inquiry,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          FarmerInquiryDetailScreen(
                                            inquiryId: inquiry.id,
                                          ),
                                    ),
                                  );
                                },
                                onReject: () async {
                                  await provider.rejectInquiry(inquiry.id);
                                },
                                onAccept: () async {
                                  await provider.acceptInquiry(inquiry.id);

                                  if (!context.mounted) return;

                                  if (provider.errorMessage == null) {
                                    await context
                                        .read<ChatProvider>()
                                        .fetchConversations(
                                      showLoading: false,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
