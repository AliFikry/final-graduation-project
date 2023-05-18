import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_example/commands.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  List<String> commandLogs = [];
  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      print(_lastWords);
      commandLogs[commandLogs.length - 1] = _lastWords;

      detectIfTextContainsOpenOrClose();
    });
    print(commandLogs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Recognition'),
      ),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: ListView(
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Commands Logs",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
            ),
            // Expanded(
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     child: Text(_lastWords),
            //     // child: Text(
            //     //   // If listening is active show the recognized words
            //     //   _speechToText.isListening
            //     //       ? '$_lastWords'
            //     //       // If listening isn't active but could be tell the user
            //     //       // how to start it, otherwise indicate that speech
            //     //       // recognition is not yet ready or not supported on
            //     //       // the target device
            //     //       : _speechEnabled
            //     //           ? 'Tap the microphone to start listening...'
            //     //           : 'Speech not available',
            //     // ),
            //   ),
            // ),
            commandLogs.length == 0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "No Logs have been recorded",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: ListView.separated(
                      // physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: commandLogs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          horizontalTitleGap: 5,
                          leading: commandLogs[index]
                                  .toString()
                                  .toLowerCase()
                                  .contains("open")
                              ? Icon(
                                  Icons.lightbulb,
                                  color: Colors.yellow,
                                )
                              : commandLogs[index]
                                      .toString()
                                      .toLowerCase()
                                      .contains("close")
                                  ? Icon(
                                      Icons.lightbulb,
                                      color: Colors.black,
                                    )
                                  : Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                          title: Text(
                            commandLogs[index],
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: commandLogs[index]
                                  .toString()
                                  .toLowerCase()
                                  .contains("open")
                              ? Text(
                                  "this command will open the light",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                )
                              : commandLogs[index]
                                      .toString()
                                      .toLowerCase()
                                      .contains("close")
                                  ? Text(
                                      "this command will open the light",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    )
                                  : SizedBox(),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                commandLogs.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 50.0,
        duration: const Duration(milliseconds: 2000),
        // shape: BoxShape.rectangle,
        glowColor: Theme.of(context).primaryColor,
        animate: _speechToText.isListening ? true : false,
        child: FloatingActionButton(
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.all(Radius.circular(16.0))),
          // onPressed:
          //     _speechToText.isNotListening ? _startListening : _stopListening
          // ,
          onPressed: () async {
            if (_speechToText.isNotListening) {
              commandLogs.add("");

              _startListening();
            } else {
              _stopListening();
            }
            // detectIfTextContainsOpenOrClose();
          },
          tooltip: 'Listen',
          child: Icon(
            !_speechToText.isNotListening ? Icons.mic_off : Icons.mic,
            size: 30,
          ),
        ),
      ),
    );
  }

  detectIfTextContainsOpenOrClose() {
    if (_lastWords.contains("open")) {
      if (_lastWords.contains("one") ||
          _lastWords.contains("1") ||
          _lastWords.contains("first")) {
        print("open one");
      } else if (_lastWords.contains("two") ||
          _lastWords.contains("2") ||
          _lastWords.contains("second") ||
          _lastWords.contains("to")) {
        print("open two");
      } else if (_lastWords.contains("three") ||
          _lastWords.contains("3") ||
          _lastWords.contains("third")) {
        print("open three");
      } else if (_lastWords.contains("four") ||
          _lastWords.contains("4") ||
          _lastWords.contains("fourth") ||
          _lastWords.contains("for")) {
        print("open four");
      }
    }
    if (_lastWords.contains("close")) {
      if (_lastWords.contains("one") ||
          _lastWords.contains("1") ||
          _lastWords.contains("first")) {
        print("close one");
      } else if (_lastWords.contains("two") ||
          _lastWords.contains("2") ||
          _lastWords.contains("second") ||
          _lastWords.contains("to")) {
        print("close two");
      } else if (_lastWords.contains("three") ||
          _lastWords.contains("3") ||
          _lastWords.contains("third")) {
        print("close three");
      } else if (_lastWords.contains("four") ||
          _lastWords.contains("4") ||
          _lastWords.contains("fourth") ||
          _lastWords.contains("for")) {
        print("close four");
      }
    }
  }
}
