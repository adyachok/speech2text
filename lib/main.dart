import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler(
        (bool result) => setState(() => _isAvailable = result));
    _speechRecognition.setRecognitionStartedHandler(
        () => setState(() => _isListening = true));
    _speechRecognition.setRecognitionResultHandler(
        (String speech) => setState(() => resultText = speech));
    _speechRecognition.setRecognitionCompleteHandler(
        (() => setState(() => _isListening = false)));

    _speechRecognition
        .activate()
        .then((result) => setState(() => _isAvailable = result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  child: Icon(Icons.cancel),
                  onPressed: () {
                    if (_isListening) {
                      _speechRecognition.cancel().then((result) => setState((){
                        _isListening = result;
                        resultText = "";
                      }));
                    }
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.pink,
                  child: Icon(Icons.mic),
                  onPressed: () {
                    if (_isAvailable && !_isListening) {
                      _speechRecognition.listen(locale: "en_US").then((result) => print("$result"));
                    }
                  },
                ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.stop),
                  onPressed: () {
                    if (_isListening) {
                      _speechRecognition.stop().then((result) => setState(() => _isListening = result));
                    }
                  },
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0)
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0
              ),
              child: Text(
                resultText,
                style: TextStyle(fontSize: 24.0),
                ),
            )
          ],
        ),
      ),
    );
  }
}
