import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voice_assistant_provider.dart';

class VoiceAssistantSheet extends StatefulWidget {
  final void Function(
    Map<String, dynamic> action,
  )? onAction;

  const VoiceAssistantSheet({
    super.key,
    this.onAction,
  });

  @override
  State<VoiceAssistantSheet> createState() => _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState extends State<VoiceAssistantSheet> {
  String _language = 'en';
  bool _actionHandled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceAssistantProvider>(
      builder: (
        context,
        voiceProvider,
        child,
      ) {
        if (voiceProvider.action != null && !_actionHandled) {
          _actionHandled = true;

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // [TRACE-1] action received in post-frame callback
            debugPrint('[NAV-TRACE-1] postFrameCallback fired, mounted=$mounted');
            if (!mounted) {
              debugPrint('[NAV-TRACE-1b] ABORT: sheet already unmounted before action');
              return;
            }

            final action = voiceProvider.consumeAction();
            // [TRACE-1c] action value
            debugPrint('[NAV-TRACE-1c] action from consumeAction: $action');

            if (action == null) {
              debugPrint('[NAV-TRACE-1d] ABORT: action is null after consumeAction');
              return;
            }

            debugPrint('VOICE SHEET ACTION: $action');

            // Capture the root navigator BEFORE dismissing the sheet so
            // we still have a valid reference after the sheet's context is gone.
            final rootNav = Navigator.of(context, rootNavigator: true);
            debugPrint('[NAV-TRACE-2] rootNavigator obtained: $rootNav');
            debugPrint('[NAV-TRACE-2b] rootNav.canPop() = ${rootNav.canPop()}');

            // [TRACE-3] sheet dismissal started
            debugPrint('[NAV-TRACE-3] sheet dismissal STARTED (maybePop)');
            await rootNav.maybePop();
            // [TRACE-4] sheet dismissal completed
            debugPrint('[NAV-TRACE-4] sheet dismissal COMPLETED');

            // [TRACE-5] about to call onAction
            debugPrint('[NAV-TRACE-5] calling widget.onAction with action=$action');
            widget.onAction?.call(action);
            // [TRACE-6] onAction returned
            debugPrint('[NAV-TRACE-6] widget.onAction call returned');
          });
        }

        final height = MediaQuery.of(context).size.height;

        return Container(
          height: height * 0.35, // Increased slightly to comfortably accommodate responses/errors
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // -------------------------------------------------
              // Handle
              // -------------------------------------------------
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 10),

              // -------------------------------------------------
              // Header
              // -------------------------------------------------
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xff075739),
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
                              fontSize: 14,
                            ),
                          ),
                        ),

                        DropdownMenuItem(
                          value: 'ur',
                          child: Text(
                            'اردو',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],

                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          _language = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // -------------------------------------------------
              // Content Area (Recognized Text, Status, Error)
              // -------------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Recognized / Prompt Text
                        if (voiceProvider.recognizedText.trim().isEmpty)
                          Text(
                            voiceProvider.isListening
                                ? 'Listening...'
                                : 'Press and hold the microphone to speak',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          )
                        else
                          Text(
                            voiceProvider.recognizedText,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        // Processing Status
                        if (voiceProvider.isProcessing)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Processing your request...',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        // Response Text
                        if (voiceProvider.responseText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              voiceProvider.responseText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                        // Error Message
                        if (voiceProvider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              voiceProvider.error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // -------------------------------------------------
              // Microphone Button
              // -------------------------------------------------
              GestureDetector(
                onLongPressStart: (_) async {
  await voiceProvider.startListening(
    language: _language,
    currentScreen: voiceProvider.currentScreen ?? 'farmer_dashboard',
  );
},
                onLongPressEnd: (_) async {
            

                  await voiceProvider.stopListening();

                  debugPrint('========== MIC STOP HANDLER FINISHED ==========');
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: voiceProvider.isListening
                        ? Colors.redAccent
                        : const Color(0xff075739),
                  ),
                  child: Icon(
                    voiceProvider.isListening
                        ? Icons.mic
                        : Icons.mic_none,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
