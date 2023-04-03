import 'package:ai_chatbot/widgets/circle_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SiriScreen extends StatefulWidget {
  @override
  State<SiriScreen> createState() => _SiriScreenState();
}

class _SiriScreenState extends State<SiriScreen> with TickerProviderStateMixin {
  final siriController = SiriWaveController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double confidence = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    siriController.speed = 0.1;

    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.black,
        leading: Icon(
          CupertinoIcons.left_chevron,
          color: Colors.white,
        ),
        middle: Text(
          'Speaking to Ai bot',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: Icon(
          CupertinoIcons.ellipsis,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.maxFinite,
            margin: EdgeInsets.only(
              top: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Go ahead im listening',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: SiriWave(
                    controller: siriController,
                    options: SiriWaveOptions(height: 300, width: 300),
                    style: SiriWaveStyle.ios_7,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 150,
              child: Text(
                _text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          Spacer(),
          CustomPaint(
            painter: CirclePainter(
              _controller,
              color: Colors.red,
            ),
            child: SizedBox(
                width: 40,
                height: 40,
                child: ElevatedButton(
                  child: Icon(Icons.mic),
                  onPressed: () {},
                )),
          ),
          Spacer(),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
