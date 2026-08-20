import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/support_provider.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() =>
      _CustomerSupportScreenState();
}

class _CustomerSupportScreenState
    extends State<CustomerSupportScreen> {
  final TextEditingController _messageController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<SupportProvider>().fetchMyRequests();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<SupportProvider>();

    final success = await provider.submitRequest(
      message: _messageController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your request has been submitted successfully.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'Failed to submit your request.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Support'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return context
                .read<SupportProvider>()
                .fetchMyRequests();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildMessageField(context),
                  const SizedBox(height: 20),
                  _buildSubmitButton(context),
                  const SizedBox(height: 32),
                  _buildPreviousRequests(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'How can we help you?',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Write your complaint, question, or request '
                      'and our support team will review it.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageField(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Your Message',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _messageController,
          maxLines: 6,
          maxLength: 1000,
          textInputAction:
          TextInputAction.newline,
          decoration: InputDecoration(
            hintText:
            'Describe your issue or request...',
            alignLabelWithHint: true,
            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 8,
                bottom: 75,
              ),
              child: Icon(
                Icons.message_outlined,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .primary,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context)
                .colorScheme
                .surface,
          ),
          validator: (value) {
            final message =
                value?.trim() ?? '';

            if (message.isEmpty) {
              return 'Please enter your message.';
            }

            if (message.length < 10) {
              return 'Please describe your issue in more detail.';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(
      BuildContext context) {
    return Consumer<SupportProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: provider.isSubmitting
                ? null
                : _submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(14),
              ),
            ),
            child: provider.isSubmitting
                ? const SizedBox(
              height: 22,
              width: 22,
              child:
              CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : const Text(
              'Submit Request',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviousRequests(
      BuildContext context) {
    return Consumer<SupportProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.errorMessage != null &&
            provider.requests.isEmpty) {
          return _buildErrorState(
            context,
            provider,
          );
        }

        if (provider.requests.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'My Previous Requests',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.requests.map(
                  (request) {
                return Container(
                  width: double.infinity,
                  margin:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),
                  padding:
                  const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                      Colors.grey.shade300,
                    ),
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStatusChip(
                            context,
                            request.status,
                          ),
                          const Spacer(),
                          if (request.createdAt !=
                              null)
                            Text(
                              _formatDate(
                                request.createdAt!,
                              ),
                              style:
                              Theme.of(
                                context,
                              )
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: Colors
                                    .grey
                                    .shade600,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
        ),
        child: Column(
          children: [
            Icon(
              Icons.support_agent_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            Text(
              'No previous requests',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your submitted support requests '
                  'will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
      BuildContext context,
      SupportProvider provider,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.red.withValues(
          alpha: 0.06,
        ),
        borderRadius:
        BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 34,
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage ??
                'Failed to load support requests.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: provider.isLoading
                ? null
                : provider.fetchMyRequests,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
      BuildContext context,
      String status,
      ) {
    String label;

    switch (status.toLowerCase()) {
      case 'in_progress':
        label = 'In Progress';
        break;

      case 'resolved':
        label = 'Resolved';
        break;

      default:
        label = 'Pending';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withValues(alpha: 0.10),
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }
}