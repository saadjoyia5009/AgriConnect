import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/voice_assistant_provider.dart';

class VoiceAssistantSheet extends StatefulWidget {
  const VoiceAssistantSheet({
    super.key,
  });

  @override
  State<VoiceAssistantSheet> createState() =>
      _VoiceAssistantSheetState();
}

class _VoiceAssistantSheetState
    extends State<VoiceAssistantSheet> {
  String _language = 'en';

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceAssistantProvider>(
      builder: (
          context,
          voiceProvider,
          child,
          ) {
        final height =
            MediaQuery.of(context).size.height;

        return Container(
          height: height * 0.25,
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
                  borderRadius:
                  BorderRadius.circular(10),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _language,
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'ur',
                          child: Text('اردو'),
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

              const SizedBox(height: 6),

              // -------------------------------------------------
              // Recognized Text
              // -------------------------------------------------

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Center(
                    child: voiceProvider
                        .recognizedText
                        .trim()
                        .isEmpty
                        ? Text(
                      voiceProvider.isListening
                          ? 'Listening...'
                          : 'Press and hold the microphone to speak',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    )
                        : Text(
                      voiceProvider.recognizedText,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow:
                      TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // -------------------------------------------------
              // Microphone
              // -------------------------------------------------

              GestureDetector(
                onLongPressStart: (_) async {
                  await voiceProvider.startListening(
                    language: _language,
                  );
                },
                onLongPressEnd: (_) async {
                  await voiceProvider.stopListening(
                    currentScreen:
                    'farmer_dashboard',
                  );
                },
                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 200),
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