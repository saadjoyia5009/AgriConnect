import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voice_assistant_provider.dart';

class VoiceAssistantSheet extends StatefulWidget {
  final void Function(
      Map<String, dynamic> action,
      )? onAction;
  final ValueChanged<bool>? onMinimizedChanged;

  const VoiceAssistantSheet({
    super.key,
    this.onAction,
    this.onMinimizedChanged,
  });

  @override
  State<VoiceAssistantSheet> createState() =>
      _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState
    extends State<VoiceAssistantSheet> {
  static const Color darkGreen = Color(0xff075739);

  String _language = 'en';

  final DraggableScrollableController _sheetController =
  DraggableScrollableController();
  bool _isMinimized = false;

  // =========================================================
  // SHEET SIZES
  // =========================================================

  static const double _initialSize = 0.35;
  static const double _minSize = 0.08;
  static const double _maxSize = 0.65;

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      if (!_sheetController.isAttached) {
        return;
      }

      final minimized =
          _sheetController.size <= (_minSize + 0.01);

      if (_isMinimized != minimized) {
        setState(() {
          _isMinimized = minimized;
        });

        widget.onMinimizedChanged?.call(minimized);
      }
    });
  }

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  // =========================================================
  // ACTION HANDLING
  // =========================================================

  void _handleAction(
      VoiceAssistantProvider voiceProvider,
      ) {
    final action = voiceProvider.consumeAction();

    debugPrint(
      '[VOICE-SHEET] consumed action: $action',
    );

    if (action == null) {
      return;
    }

    debugPrint(
      '[VOICE-SHEET] forwarding action to dashboard',
    );

    widget.onAction?.call(action);
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceAssistantProvider>(
      builder: (
          context,
          voiceProvider,
          child,
          ) {
        // -----------------------------------------------------
        // Handle navigation/action outside build
        // -----------------------------------------------------

        if (voiceProvider.action != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }

            _handleAction(voiceProvider);
          });
        }

        return DraggableScrollableSheet(
          controller: _sheetController,
          initialChildSize: _initialSize,
          minChildSize: _minSize,
          maxChildSize: _maxSize,
          snap: true,
          snapSizes: const [
            _minSize,
            _initialSize,
            _maxSize,
          ],
          expand: false,

          builder: (
              context,
              scrollController,
              ) {
            return _buildSheet(
              context,
              voiceProvider,
              scrollController,
            );
          },
        );
      },
    );
  }

  // =========================================================
  // SHEET
  // =========================================================

  Widget _buildSheet(
      BuildContext context,
      VoiceAssistantProvider voiceProvider,
      ScrollController scrollController,
      ) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 18,
              offset: Offset(
                0,
                -4,
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildDragHandle(context),

            if (!_isMinimized) ...[
              _buildHeader(),
              const SizedBox(height: 6),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    8,
                    20,
                    12,
                  ),
                  children: [
                    _buildVoiceContent(voiceProvider),
                    const SizedBox(height: 10),
                    _buildMicrophone(voiceProvider),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DRAG HANDLE
  // =========================================================

  Widget _buildDragHandle(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (!_sheetController.isAttached) {
          return;
        }

        final screenHeight = MediaQuery.of(context).size.height;

        if (screenHeight <= 0) {
          return;
        }

        final delta = details.primaryDelta ?? 0;

        final nextSize =
        (_sheetController.size - (delta / screenHeight))
            .clamp(
          _minSize,
          _maxSize,
        );

        _sheetController.jumpTo(nextSize);
      },
      onVerticalDragEnd: (details) {
        if (!_sheetController.isAttached) {
          return;
        }

        final velocity = details.primaryVelocity ?? 0;

        // Fast downward swipe → minimize
        if (velocity > 500) {
          _sheetController.animateTo(
            _minSize,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
          );
          return;
        }

        // Fast upward swipe → expand
        if (velocity < -500) {
          _sheetController.animateTo(
            _maxSize,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
          );
          return;
        }

        // Otherwise snap to nearest useful state.
        final currentSize = _sheetController.size;

        if (currentSize <= (_initialSize + _minSize) / 2) {
          _sheetController.animateTo(
            _minSize,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        } else if (currentSize <= (_maxSize + _initialSize) / 2) {
          _sheetController.animateTo(
            _initialSize,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        } else {
          _sheetController.animateTo(
            _maxSize,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 8,
        ),
        child: Center(
          child: Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome,
            color: darkGreen,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Voice Assistant',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _language,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'ur',
                  child: Text(
                    'اردو',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _language = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CONTENT
  // =========================================================

  Widget _buildVoiceContent(
      VoiceAssistantProvider voiceProvider,
      ) {
    String statusText;

    if (voiceProvider.isListening) {
      statusText = 'Listening...';
    } else if (voiceProvider.isProcessing) {
      statusText = 'Processing your request...';
    } else if (voiceProvider.recognizedText
        .trim()
        .isEmpty) {
      statusText =
      'Press and hold the microphone to speak';
    } else {
      statusText = voiceProvider.recognizedText;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // -----------------------------------------------------
        // RECOGNIZED TEXT / STATUS
        // -----------------------------------------------------

        Text(
          statusText,
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: voiceProvider.isListening
                ? darkGreen
                : Colors.black54,
            fontSize: 15,
            fontWeight:
            voiceProvider.isListening
                ? FontWeight.w600
                : FontWeight.w500,
          ),
        ),

        // -----------------------------------------------------
        // AI RESPONSE
        // -----------------------------------------------------

        if (voiceProvider.responseText
            .trim()
            .isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              voiceProvider.responseText,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // -----------------------------------------------------
        // ERROR
        // -----------------------------------------------------

        if (voiceProvider.error != null)
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              voiceProvider.error!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  // =========================================================
  // MICROPHONE
  // =========================================================

  Widget _buildMicrophone(
      VoiceAssistantProvider voiceProvider,
      ) {
    final isListening =
        voiceProvider.isListening;

    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        // -----------------------------------------------------
        // START
        // -----------------------------------------------------

        onLongPressStart: (_) async {
          debugPrint(
            '[VOICE-SHEET] microphone pressed',
          );

          await voiceProvider.startListening(
            language: _language,
            currentScreen:
            voiceProvider.currentScreen ??
                'farmer_dashboard',
          );
        },

        // -----------------------------------------------------
        // STOP
        // -----------------------------------------------------

        onLongPressEnd: (_) async {
          debugPrint(
            '[VOICE-SHEET] microphone released',
          );

          await voiceProvider.stopListening();

          debugPrint(
            '========== MIC STOP HANDLER FINISHED ==========',
          );
        },

        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isListening
                ? Colors.redAccent
                : darkGreen,
            boxShadow: [
              BoxShadow(
                color: isListening
                    ? Colors.redAccent
                    .withOpacity(0.25)
                    : darkGreen.withOpacity(0.20),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            isListening
                ? Icons.mic
                : Icons.mic_none,
            color: Colors.white,
            size: 29,
          ),
        ),
      ),
    );
  }
}