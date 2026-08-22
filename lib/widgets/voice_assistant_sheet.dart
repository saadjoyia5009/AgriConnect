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

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            final action = voiceProvider.consumeAction();

            if (action == null) return;

            debugPrint('VOICE SHEET ACTION: $action');

            widget.onAction?.call(action);
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
                    currentScreen: voiceProvider.currentScreen,
                  );
                },

                onLongPressEnd: (_) async {
                  await voiceProvider.stopListening();
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