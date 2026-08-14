import 'package:flutter/material.dart';

class AdminSupportScreen extends StatefulWidget {
  const AdminSupportScreen({super.key});

  @override
  State<AdminSupportScreen> createState() =>
      _AdminSupportScreenState();
}

class _AdminSupportScreenState extends State<AdminSupportScreen> {
  static const Color darkGreen = Color(0xFF0E5A3C);
  static const Color lightGreen = Color(0xFF9FF2C1);
  static const Color lightBackground = Color(0xFFF4F8F5);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkCard = Color(0xFF15251E);

  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _requests = [
    {
      'id': 1,
      'name': 'Ahmad',
      'role': 'Farmer',
      'message':
      'Meri crop listing buyer ko show nahi ho rahi.',
      'status': 'Pending',
      'date': '14 Aug 2026',
    },
    {
      'id': 2,
      'name': 'Ali',
      'role': 'Buyer',
      'message':
      'Mujhe farmer se inquiry ka response nahi mila.',
      'status': 'In Progress',
      'date': '14 Aug 2026',
    },
    {
      'id': 3,
      'name': 'Muhammad',
      'role': 'Farmer',
      'message':
      'Weather information update nahi ho rahi.',
      'status': 'Resolved',
      'date': '13 Aug 2026',
    },
    {
      'id': 4,
      'name': 'Usman',
      'role': 'Buyer',
      'message':
      'Crop details mein quantity incorrect show ho rahi hai.',
      'status': 'Pending',
      'date': '13 Aug 2026',
    },
  ];

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get primaryText {
    return isDark ? Colors.white : const Color(0xFF123524);
  }

  Color get secondaryText {
    return isDark ? Colors.white70 : Colors.grey.shade700;
  }

  List<Map<String, dynamic>> get _filteredRequests {
    if (_selectedFilter == 'All') {
      return _requests;
    }

    return _requests.where((request) {
      return request['status'] == _selectedFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      isDark ? darkBackground : lightBackground,
      appBar: AppBar(
        backgroundColor:
        isDark ? darkCard : darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Customer Support',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilters(),
            Expanded(
              child: _buildRequestsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final pendingCount = _requests
        .where((request) => request['status'] == 'Pending')
        .length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.18 : 0.06,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF263B31)
                  : const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: isDark ? lightGreen : darkGreen,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Support Requests',
                  style: TextStyle(
                    color: primaryText,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$pendingCount pending request'
                      '${pendingCount == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    const filters = [
      'All',
      'Pending',
      'In Progress',
      'Resolved',
    ];

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final selected =
              _selectedFilter == filter;

          return ChoiceChip(
            label: Text(filter),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
              });
            },
            selectedColor: isDark
                ? lightGreen
                : darkGreen,
            backgroundColor:
            isDark ? darkCard : Colors.white,
            labelStyle: TextStyle(
              color: selected
                  ? (isDark
                  ? darkGreen
                  : Colors.white)
                  : primaryText,
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide(
              color: isDark
                  ? Colors.white12
                  : Colors.grey.shade300,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestsList() {
    final requests = _filteredRequests;

    if (requests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 70,
                color: isDark
                    ? Colors.white38
                    : Colors.grey.shade400,
              ),
              const SizedBox(height: 14),
              Text(
                'No support requests',
                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'There are no requests in this category.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        30,
      ),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];

        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildRequestCard(
      Map<String, dynamic> request,
      ) {
    final String role = request['role'];
    final String status = request['status'];

    final bool isFarmer = role == 'Farmer';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xFFE3EBE6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.16 : 0.04,
            ),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          _showRequestDetails(request);
        },
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF263B31)
                          : const Color(0xFFE8F5EE),
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isFarmer
                          ? Icons.agriculture_rounded
                          : Icons.shopping_bag_rounded,
                      color: isDark
                          ? lightGreen
                          : darkGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          request['name'],
                          style: TextStyle(
                            color: primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          role,
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                request['message'],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 14.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: secondaryText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    request['date'],
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: secondaryText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color background;
    Color foreground;

    switch (status) {
      case 'Resolved':
        background = Colors.green.withValues(
          alpha: 0.12,
        );
        foreground = Colors.green.shade700;
        break;

      case 'In Progress':
        background = Colors.orange.withValues(
          alpha: 0.12,
        );
        foreground = Colors.orange.shade800;
        break;

      default:
        background = Colors.red.withValues(
          alpha: 0.10,
        );
        foreground = Colors.red.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: foreground,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _showRequestDetails(
      Map<String, dynamic> request,
      ) {
    String selectedStatus = request['status'];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (
              context,
              setSheetState,
              ) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24 +
                    MediaQuery.viewInsetsOf(
                      context,
                    ).bottom,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? darkCard
                    : Colors.white,
                borderRadius:
                const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 45,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white24
                              : Colors.black12,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF263B31)
                                : const Color(0xFFE8F5EE),
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                          child: Icon(
                            request['role'] == 'Farmer'
                                ? Icons.agriculture_rounded
                                : Icons.shopping_bag_rounded,
                            color: isDark
                                ? lightGreen
                                : darkGreen,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                request['name'],
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                request['role'],
                                style: TextStyle(
                                  color: secondaryText,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Request',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1D3027)
                            : const Color(0xFFF4F8F5),
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Text(
                        request['message'],
                        style: TextStyle(
                          color: primaryText,
                          height: 1.5,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Status',
                      style: TextStyle(
                        color: primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1D3027)
                            : const Color(0xFFF4F8F5),
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'In Progress',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'Resolved',
                          child: Text('Resolved'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setSheetState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            request['status'] =
                                selectedStatus;
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Support request status updated.',
                              ),
                              behavior:
                              SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          darkGreen,
                          foregroundColor:
                          Colors.white,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Update Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}