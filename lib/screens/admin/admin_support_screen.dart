import 'package:flutter/material.dart';
import '../../../services/api_service.dart';


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

  List<Map<String, dynamic>> _requests = [];

  bool _isLoading = false;
  String? _errorMessage;

  bool _isUpdatingStatus = false;

  bool get isDark {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get primaryText {
    return isDark
        ? Colors.white
        : const Color(0xFF123524);
  }

  Color get secondaryText {
    return isDark
        ? Colors.white70
        : Colors.grey.shade700;
  }

  @override
  void initState() {
    super.initState();
    _fetchSupportRequests();
  }

  // =========================================================
  // FETCH SUPPORT REQUESTS
  // =========================================================

  Future<void> _fetchSupportRequests() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.get(
        '/admin/support/',
        auth: true,
      );

      List<dynamic> results = [];

      if (response is List) {
        results = response;
      } else if (response is Map<String, dynamic>) {
        final apiResults = response['results'];

        if (apiResults is List) {
          results = apiResults;
        }
      }

      final parsedRequests = results
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => _mapBackendRequest(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();

      if (!mounted) return;

      setState(() {
        _requests = parsedRequests;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = _cleanError(e);
      });
    }
  }

  // =========================================================
  // BACKEND RESPONSE -> UI MAP
  // =========================================================

  Map<String, dynamic> _mapBackendRequest(
      Map<String, dynamic> json,
      ) {
    final rawStatus =
        json['status']?.toString() ?? 'pending';

    return {
      'id': json['id'],
      'name': json['user_name']?.toString() ?? 'Unknown User',
      'role': _formatRole(
        json['user_role']?.toString(),
      ),
      'message': json['message']?.toString() ?? '',
      'status': _formatStatus(rawStatus),
      'raw_status': rawStatus,
      'date': _formatDate(
        json['created_at']?.toString(),
      ),
      'created_at': json['created_at'],
      'updated_at': json['updated_at'],
      'resolved_at': json['resolved_at'],
    };
  }

  String _formatRole(String? role) {
    if (role == null || role.trim().isEmpty) {
      return 'User';
    }

    switch (role.toLowerCase()) {
      case 'farmer':
        return 'Farmer';

      case 'buyer':
        return 'Buyer';

      case 'admin':
        return 'Admin';

      default:
        return role;
    }
  }

  String _formatStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';

      case 'in_progress':
        return 'In Progress';

      case 'resolved':
        return 'Resolved';

      default:
        return status;
    }
  }

  String _statusToBackend(String status) {
    switch (status) {
      case 'Pending':
        return 'pending';

      case 'In Progress':
        return 'in_progress';

      case 'Resolved':
        return 'resolved';

      default:
        return 'pending';
    }
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _cleanError(Object error) {
    final message = error.toString();

    if (message.startsWith('Exception: ')) {
      return message.substring(11);
    }

    return message;
  }

  // =========================================================
  // FILTER
  // =========================================================

  List<Map<String, dynamic>> get _filteredRequests {
    if (_selectedFilter == 'All') {
      return _requests;
    }

    return _requests.where((request) {
      return request['status'] == _selectedFilter;
    }).toList();
  }

  // =========================================================
  // UPDATE STATUS
  // =========================================================

  Future<bool> _updateRequestStatus({
    required Map<String, dynamic> request,
    required String newStatus,
  }) async {
    final id = request['id'];

    if (id == null) {
      return false;
    }

    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final backendStatus =
      _statusToBackend(newStatus);

      final response = await ApiService.patch(
        '/admin/support/$id/',
        {
          'status': backendStatus,
        },
        auth: true,
      );

      Map<String, dynamic>? updatedData;

      if (response is Map<String, dynamic>) {
        updatedData = response;
      }

      if (!mounted) return false;

      setState(() {
        request['status'] = newStatus;
        request['raw_status'] = backendStatus;

        if (updatedData != null) {
          request['name'] =
              updatedData['user_name']?.toString() ??
                  request['name'];

          request['role'] = _formatRole(
            updatedData['user_role']?.toString(),
          );

          request['message'] =
              updatedData['message']?.toString() ??
                  request['message'];

          request['status'] = _formatStatus(
            updatedData['status']?.toString() ??
                backendStatus,
          );

          request['raw_status'] =
              updatedData['status']?.toString() ??
                  backendStatus;

          request['updated_at'] =
          updatedData['updated_at'];

          request['resolved_at'] =
          updatedData['resolved_at'];
        }

        _isUpdatingStatus = false;
      });

      return true;
    } catch (e) {
      if (!mounted) return false;

      setState(() {
        _isUpdatingStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update status: ${_cleanError(e)}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return false;
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

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

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    final pendingCount = _requests
        .where(
          (request) =>
      request['status'] == 'Pending',
    )
        .length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        12,
      ),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: isDark
            ? darkCard
            : Colors.white,

        borderRadius:
        BorderRadius.circular(22),

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

              borderRadius:
              BorderRadius.circular(16),
            ),

            child: Icon(
              Icons.support_agent_rounded,
              color:
              isDark ? lightGreen : darkGreen,
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

  // =========================================================
  // FILTERS
  // =========================================================

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
        padding:
        const EdgeInsets.symmetric(
          horizontal: 18,
        ),

        scrollDirection:
        Axis.horizontal,

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

            backgroundColor: isDark
                ? darkCard
                : Colors.white,

            labelStyle: TextStyle(
              color: selected
                  ? (isDark
                  ? darkGreen
                  : Colors.white)
                  : primaryText,

              fontWeight:
              FontWeight.w700,
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

  // =========================================================
  // REQUEST LIST
  // =========================================================

  Widget _buildRequestsList() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: darkGreen,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),

          child: Column(
            mainAxisSize:
            MainAxisSize.min,

            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red.shade400,
              ),

              const SizedBox(height: 14),

              Text(
                'Failed to load support requests',

                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color: primaryText,
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _errorMessage!,
                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 18),

              OutlinedButton(
                onPressed:
                _fetchSupportRequests,

                child:
                const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final requests =
        _filteredRequests;

    if (requests.isEmpty) {
      return Center(
        child: Padding(
          padding:
          const EdgeInsets.all(30),

          child: Column(
            mainAxisSize:
            MainAxisSize.min,

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
                  fontWeight:
                  FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'There are no requests in this category.',

                textAlign:
                TextAlign.center,

                style: TextStyle(
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh:
      _fetchSupportRequests,

      child: ListView.builder(
        padding:
        const EdgeInsets.fromLTRB(
          18,
          14,
          18,
          30,
        ),

        itemCount:
        requests.length,

        itemBuilder:
            (context, index) {
          final request =
          requests[index];

          return _buildRequestCard(
            request,
          );
        },
      ),
    );
  }

  // =========================================================
  // REQUEST CARD
  // =========================================================

  Widget _buildRequestCard(
      Map<String, dynamic> request,
      ) {
    final String role =
        request['role'] ?? 'User';

    final String status =
        request['status'] ?? 'Pending';

    final bool isFarmer =
        role == 'Farmer';

    return Container(
      margin:
      const EdgeInsets.only(
        bottom: 14,
      ),

      decoration: BoxDecoration(
        color: isDark
            ? darkCard
            : Colors.white,

        borderRadius:
        BorderRadius.circular(20),

        border: Border.all(
          color: isDark
              ? Colors.white10
              : const Color(0xFFE3EBE6),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha:
              isDark ? 0.16 : 0.04,
            ),
            blurRadius: 14,
            offset:
            const Offset(0, 6),
          ),
        ],
      ),

      child: InkWell(
        borderRadius:
        BorderRadius.circular(20),

        onTap: () {
          _showRequestDetails(
            request,
          );
        },

        child: Padding(
          padding:
          const EdgeInsets.all(17),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,

                    decoration:
                    BoxDecoration(
                      color: isDark
                          ? const Color(
                        0xFF263B31,
                      )
                          : const Color(
                        0xFFE8F5EE,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                    ),

                    child: Icon(
                      isFarmer
                          ? Icons
                          .agriculture_rounded
                          : Icons
                          .shopping_bag_rounded,

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
                          request['name'] ??
                              'Unknown User',

                          style:
                          TextStyle(
                            color:
                            primaryText,
                            fontSize: 16,
                            fontWeight:
                            FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          role,

                          style:
                          TextStyle(
                            color:
                            secondaryText,
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildStatusChip(
                    status,
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                request['message'] ??
                    '',

                maxLines: 3,

                overflow:
                TextOverflow.ellipsis,

                style: TextStyle(
                  color: primaryText,
                  fontSize: 14.5,
                  height: 1.45,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Icon(
                    Icons
                        .calendar_today_outlined,
                    size: 15,
                    color:
                    secondaryText,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    request['date'] ??
                        '-',

                    style:
                    TextStyle(
                      color:
                      secondaryText,
                      fontSize: 12.5,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    size: 14,
                    color:
                    secondaryText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // STATUS CHIP
  // =========================================================

  Widget _buildStatusChip(
      String status,
      ) {
    Color background;
    Color foreground;

    switch (status) {
      case 'Resolved':
        background =
            Colors.green.withValues(
              alpha: 0.12,
            );

        foreground =
            Colors.green.shade700;
        break;

      case 'In Progress':
        background =
            Colors.orange.withValues(
              alpha: 0.12,
            );

        foreground =
            Colors.orange.shade800;
        break;

      default:
        background =
            Colors.red.withValues(
              alpha: 0.10,
            );

        foreground =
            Colors.red.shade700;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style: TextStyle(
          color: foreground,
          fontSize: 11.5,
          fontWeight:
          FontWeight.w800,
        ),
      ),
    );
  }

  // =========================================================
  // REQUEST DETAILS
  // =========================================================

  void _showRequestDetails(
      Map<String, dynamic> request,
      ) {
    String selectedStatus =
        request['status'] ?? 'Pending';

    showModalBottomSheet<void>(
      context: context,

      isScrollControlled: true,

      backgroundColor:
      Colors.transparent,

      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (
              context,
              setSheetState,
              ) {
            return Container(
              padding:
              EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24 +
                    MediaQuery.viewInsetsOf(
                      context,
                    ).bottom,
              ),

              decoration:
              BoxDecoration(
                color: isDark
                    ? darkCard
                    : Colors.white,

                borderRadius:
                const BorderRadius
                    .vertical(
                  top: Radius.circular(28),
                ),
              ),

              child:
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [
                    Center(
                      child: Container(
                        height: 5,
                        width: 45,

                        decoration:
                        BoxDecoration(
                          color: isDark
                              ? Colors.white24
                              : Colors.black12,

                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    // USER
                    Row(
                      children: [
                        Container(
                          height: 48,
                          width: 48,

                          decoration:
                          BoxDecoration(
                            color: isDark
                                ? const Color(
                              0xFF263B31,
                            )
                                : const Color(
                              0xFFE8F5EE,
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),

                          child: Icon(
                            request['role'] ==
                                'Farmer'
                                ? Icons
                                .agriculture_rounded
                                : Icons
                                .shopping_bag_rounded,

                            color: isDark
                                ? lightGreen
                                : darkGreen,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [
                              Text(
                                request['name'] ??
                                    'Unknown User',

                                style:
                                TextStyle(
                                  color:
                                  primaryText,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.w900,
                                ),
                              ),

                              const SizedBox(
                                height: 3,
                              ),

                              Text(
                                request['role'] ??
                                    'User',

                                style:
                                TextStyle(
                                  color:
                                  secondaryText,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    // REQUEST
                    Text(
                      'Request',

                      style: TextStyle(
                        color:
                        primaryText,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      width:
                      double.infinity,

                      padding:
                      const EdgeInsets
                          .all(16),

                      decoration:
                      BoxDecoration(
                        color: isDark
                            ? const Color(
                          0xFF1D3027,
                        )
                            : const Color(
                          0xFFF4F8F5,
                        ),

                        borderRadius:
                        BorderRadius
                            .circular(
                          16,
                        ),
                      ),

                      child: Text(
                        request['message'] ??
                            '',

                        style: TextStyle(
                          color:
                          primaryText,
                          height: 1.5,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    // STATUS
                    Text(
                      'Status',

                      style: TextStyle(
                        color:
                        primaryText,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    DropdownButtonFormField<
                        String>(
                      value:
                      selectedStatus,

                      decoration:
                      InputDecoration(
                        filled: true,

                        fillColor: isDark
                            ? const Color(
                          0xFF1D3027,
                        )
                            : const Color(
                          0xFFF4F8F5,
                        ),

                        border:
                        OutlineInputBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                            14,
                          ),
                        ),
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: 'Pending',
                          child:
                          Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'In Progress',
                          child:
                          Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'Resolved',
                          child:
                          Text('Resolved'),
                        ),
                      ],

                      onChanged:
                      _isUpdatingStatus
                          ? null
                          : (value) {
                        if (value ==
                            null) {
                          return;
                        }

                        setSheetState(
                              () {
                            selectedStatus =
                                value;
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    // UPDATE BUTTON
                    SizedBox(
                      width:
                      double.infinity,

                      height: 52,

                      child:
                      ElevatedButton(
                        onPressed:
                        _isUpdatingStatus
                            ? null
                            : () async {
                          final success =
                          await _updateRequestStatus(
                            request:
                            request,
                            newStatus:
                            selectedStatus,
                          );

                          if (!success) {
                            return;
                          }

                          if (!mounted) {
                            return;
                          }

                          if (sheetContext
                              .mounted) {
                            Navigator.pop(
                              sheetContext,
                            );
                          }

                          ScaffoldMessenger
                              .of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content:
                              Text(
                                'Support request status updated.',
                              ),
                              behavior:
                              SnackBarBehavior
                                  .floating,
                            ),
                          );
                        },

                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          darkGreen,

                          foregroundColor:
                          Colors.white,

                          disabledBackgroundColor:
                          darkGreen
                              .withValues(
                            alpha: 0.5,
                          ),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              14,
                            ),
                          ),
                        ),

                        child:
                        _isUpdatingStatus
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child:
                          CircularProgressIndicator(
                            strokeWidth:
                            2.5,
                            color:
                            Colors.white,
                          ),
                        )
                            : const Text(
                          'Update Status',

                          style:
                          TextStyle(
                            fontSize:
                            16,
                            fontWeight:
                            FontWeight
                                .w800,
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