import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'Sabitler.dart';

class SesiMetneDonustur extends StatefulWidget {
  const SesiMetneDonustur({super.key});

  @override
  State<SesiMetneDonustur> createState() => _SesiMetneDonusturState();
}

class _SesiMetneDonusturState extends State<SesiMetneDonustur> {

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  stt.SpeechToText speech = stt.SpeechToText();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initSpeech();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speech.stop();
  }
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "tr-TR"
    );
  }
  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      Sabitler.metnedonusenses = _lastWords;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      backgroundColor: Colors.orange,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(3),
            child: const Text(
              'Tanınan Kelimeler:',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                // If listening is active show the recognized words
                _speechToText.isListening
                    ? _lastWords
                // If listening isn't active but could be tell the user
                // how to start it, otherwise indicate that speech
                // recognition is not yet ready or not supported on
                // the target device
                    : _speechEnabled
                    ? 'Dinlemeye başlamak için mikrofona dokun...'
                    : 'Konuşma kullanılamıyor.',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon:  Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                tooltip: '',
                onPressed:
                // If not yet listening for speech start, otherwise stop
                _speechToText.isNotListening ? _startListening : _stopListening,
              ),
              ElevatedButton.icon(
                onPressed: (){
                  setState(() {
                    _lastWords = "";
                  });
                },
                icon: const Icon(Icons.cleaning_services_sharp),  //icon data for elevated button
                label: const Text("Temizle"), //label text
              ),
              ElevatedButton.icon(
                onPressed: (){
                  Navigator.of(context).pop(true);
                },
                icon: const Icon(Icons.exit_to_app),  //icon data for elevated button
                label: const Text("Çıkış"), //label text
              )
            ],
          ),
        ],
      ),
    );
  }
}
