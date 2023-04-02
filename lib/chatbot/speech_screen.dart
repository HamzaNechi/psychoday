import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/chatbot/api_services.dart';
import 'package:psychoday/chatbot/chat_model.dart';
import 'package:psychoday/chatbot/colors.dart';
import 'package:psychoday/chatbot/tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();

  var text = "Hold the button and start speaking";
  var isListening = false;
  var isButtonDisabled = true;
  var initialMessage = false;
  var askedQuestion = "";

  final List<ChatMessage> messages = [];

  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  var manic_symptoms = {
    "elevated mood for more than one week": -1,
    "elevated mood nearly everyday": -1,
    "Inflated self-esteem or grandiosity": -1,
    "Decreased need for sleep": -1,
    "More talkative than usual or pressure to keep talking": -1,
    "Flight of ideas or subjective experience that thoughts are racing": -1,
    "Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)":
        -1,
    "Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation":
        -1,
    "Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments).":
        -1,
    "The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features.":
        -1,
    "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition.":
        -1
  };
  var welcome_msg2 = "whatever";
  var welcome_msg =
      "Hello! Before we begin, I want to assure you that all of our conversations are confidential. Anything you share with me will be kept private and will not be shared with anyone else. My purpose is to help you identify and manage any manic symptoms you may be experiencing. So please feel free to share openly and honestly with me. I am here to help you.";

  void initState() {
    super.initState();
    // Add welcome message to messages list when app is started

    messages.add(ChatMessage(text: welcome_msg, type: ChatMessageType.bot));

    // Speak the welcome message

    Future.delayed(const Duration(milliseconds: 500), () {
      print("start ");
      print(isButtonDisabled);

      print("start 2 ");
      print(isButtonDisabled);
      Future.delayed(const Duration(milliseconds: 500), () {
        TextToSpeech.speaks(welcome_msg).whenComplete(() {
          print("midair");
          print(isButtonDisabled);

          setState(() {
            isButtonDisabled = false;
          });
          print("after");
          print(isButtonDisabled);
        });
      });
      /*  TextToSpeech.speak(welcome_msg).whenComplete(() {
        
      });*/
      print("start ");
      print(isButtonDisabled);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    var welcome_msg =
        "Hello! Before we begin, I want to assure you that all of our conversations are confidential. Anything you share with me will be kept private and will not be shared with anyone else. My purpose is to help you identify and manage any manic symptoms you may be experiencing. So please feel free to share openly and honestly with me. I am here to help you.";
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(milliseconds: 2000),
        glowColor: bgColor,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: isButtonDisabled
              ? null
              : (details) async {
                  print("tap down");
                  if (!isListening) {
                    print(initialMessage);

                    /*
                      initialMessage = true;
                      messages.add(ChatMessage(
                          text: welcome_msg, type: ChatMessageType.bot));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        TextToSpeech.speak(welcome_msg);
                      });
                      setState(() {
                        initialMessage = true;
                      });*/

                    var available = await speechToText.initialize();
                    if (available) {
                      setState(() {
                        isListening = true;

                        speechToText.listen(
                          onResult: (result) {
                            setState(() {
                              text = result.recognizedWords;
                            });
                            print("done recording");
                            print(text);
                          },
                        );
                      });
                    }
                  }
                },
          onTapUp: isButtonDisabled
              ? null
              : (details) async {
                  print("tap up");
                  setState(() {
                    isListening = false;
                  });

                  await speechToText.stop();

                  if (text.isNotEmpty &&
                      text != "Hold the buttom and start speaking") {
                    if (askedQuestion == "") {
                      print("asked question is empty");
                      var prompt = 'analyse this text "' +
                          text +
                          '" and change the values of this json from -1 to 1 if the symptoms are present in the text or keep them -1 if you can not confirm if the symptoms are present (return the JSON only)  {"elevated mood for more than one week": -1,"elevated mood nearly everyday": -1,"Inflated self-esteem or grandiosity": -1,"Decreased need for sleep": -1,"More talkative than usual or pressure to keep talking": -1,"Flight of ideas or subjective experience that thoughts are racing": -1,"Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)":    -1,"Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation":-1,"Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments).":-1,"The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features.":-1,"The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition.":-1 } \n';
                      var msg = await ApiServices.sendMessage(prompt);
                      // msg = msg.trim();
                      Map<String, int> jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John

                      String jsonString = jsonEncode(jsonMap);
                      if (jsonMap["elevated mood for more than one week"] ==
                          -1) {
                        //askedQuestion takes "For how long have you been dealing with this mood?";
                        setState(() {
                          askedQuestion =
                              "For how long have you been dealing with this mood?";
                        });
                      }

                      setState(() {
                        messages.add(ChatMessage(
                            text: askedQuestion, type: ChatMessageType.bot));
                      });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        TextToSpeech.speak(askedQuestion);
                      });
                    }

                    if (manic_symptoms[
                            'elevated mood for more than one week'] ==
                        -1) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        TextToSpeech.speak(
                            "has the patient been in an elevated mood for more than one week?");
                      });
                    }
                    /*
                    messages.add(
                        ChatMessage(text: text, type: ChatMessageType.user));

                    var prompt = "";
                    var msg = await ApiServices.sendMessage(prompt);
                    msg = msg.trim();
                    Map<String, dynamic> jsonMap = jsonDecode(msg);
                    print(jsonMap["manic symptoms"]); // Output: John
                    var second = jsonMap["manic symptoms"];
                    String jsonString = jsonEncode(second);

                    setState(() {
                      messages.add(ChatMessage(
                          text: jsonString, type: ChatMessageType.bot));
                    });
                    Future.delayed(const Duration(milliseconds: 500), () {
                      TextToSpeech.speak(jsonString);
                    });*/
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Failed to process. Try again")));
                  }
                },
          child: CircleAvatar(
            backgroundColor: isButtonDisabled ? Colors.grey : bgColor,
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white),
          ),
        ),
      ),
      appBar: AppBar(
        leading: const Icon(
          Icons.sort_rounded,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0.0,
        title: const Text(
          'Voice assistance',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          children: [
            Image.asset(
              'assets/Psychoday.gif',
              width: 100,
              height: 100,
            ),
            const Text(
              'Psychoday',
              style: TextStyle(
                color: Color.fromARGB(255, 2, 82, 148),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: chatBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var chat = messages[index];

                  return chatBubble(chattext: chat.text, type: chat.type);
                },
              ),
            )),
            const SizedBox(height: 12),
            const Text(
              "",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required chattext, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: textColor,
          child: type == ChatMessageType.bot
              ? Image.asset('assets/psychoday.png')
              : const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: type == ChatMessageType.bot ? bgColor : Colors.blue,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Text(
              "$chattext",
              style: TextStyle(
                color: type == ChatMessageType.bot ? textColor : chatBgColor,
                fontWeight: type == ChatMessageType.bot
                    ? FontWeight.w600
                    : FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
