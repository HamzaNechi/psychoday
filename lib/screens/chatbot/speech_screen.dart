import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/chatbot/api_services.dart';
import 'package:psychoday/screens/chatbot/chat_model.dart';
import 'package:psychoday/screens/chatbot/tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:convert';

import 'code_color/colors.dart';

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
  var SymptomsJson;
  var symptomIndex = 0;
  var FirstAnswer = false;

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
                    setState(() {
                      messages.add(
                          ChatMessage(text: text, type: ChatMessageType.user));
                    });
                    if (FirstAnswer == false) {
                      print("asked question is empty");
                      var prompt = 'analyse this text "' +
                          text +
                          '" and change the values of this json from -1 to 1 if the symptoms are present in the text or keep them -1 if you can not confirm if the symptoms are present (return the JSON only)  {"elevated mood for more than one week": -1,"elevated mood nearly everyday": -1,"Inflated self-esteem or grandiosity": -1,"Decreased need for sleep": -1,"More talkative than usual or pressure to keep talking": -1,"Flight of ideas or subjective experience that thoughts are racing": -1,"Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)":    -1,"Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation":-1,"Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments).":-1,"The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features.":-1,"The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition.":-1 } \n';
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      // msg = msg.trim();
                      var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                      setState(() {
                        FirstAnswer = true;
                      });
                    } else if (symptomIndex == 1) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  either it says a period of time that is more than a week or not, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["elevated mood for more than one week"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 2) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify   if the person has an elevated mood for most of the day or not , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["elevated mood nearly everyday"] = int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 3) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he has inflated self-esteem or grandiosity , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, considering this answer  :"' +
                              text +
                              "'";
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      print("trimed msg");

                      print(msg);
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Inflated self-esteem or grandiosity"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 4) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he has less need for sleep than the average person , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Decreased need for sleep"] = int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 5) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he is more talktive than usual or pressure to keep talking , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["More talkative than usual or pressure to keep talking"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 6) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  it he has flight of ideas or subjective experience that thoughts are racing, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Flight of ideas or subjective experience that thoughts are racing"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } /*else if (symptomIndex == 7) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  *****, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } */
                    else if (symptomIndex == 8) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  any increase in goal-directed activity (either socially, at work or school, or sexually), analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation"] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } else if (symptomIndex == 9) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  any Excessive involvement in activities that have a high potential for painful consequences, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments)."] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    } /* else if (symptomIndex == 10) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  *****, analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);
msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features."] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    }*/
                    else if (symptomIndex == 11) {
                      //askedQuestion takes "For how long have you been dealing with this mood?";
                      var prompt =
                          'a person who could potentialy be in a manic episode got asked this question : "' +
                              askedQuestion +
                              '" trying to identify  if the episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition , analyse the answer and answer by "0" if you couldn t identify the symptom or by "1" if you could identify the symptom or "-1" if you can not confirm nor deny ,only answer by 1 or 0 or -1, here is the answer :' +
                              text;
                      var msg = await ApiServices.sendMessage(prompt);
                      print("msg");
                      print(msg);

                      msg = msg.trim();
                      var jsonMap;
                      jsonMap = SymptomsJson;
                      jsonMap["The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."] =
                          int.parse(msg);

                      // msg = msg.trim();
                      // var jsonMap = jsonDecode(msg);
                      print(jsonMap); // Output: John
                      setState(() {
                        SymptomsJson = jsonMap;
                      });
                      print("after");
                      print(SymptomsJson);
                    }
                    // Index attribute is used to keep track of the symptoms

                    if (SymptomsJson["elevated mood for more than one week"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 1;
                      });
                      List<String> questions = [
                        "For how long have you been dealing with this mood?",
                        "How long have you been feeling excessively energetic, excited, or euphoric?",
                        "How long has it been since you first noticed these symptoms of mania in your life?",
                        "Can you recall any specific periods in your life when you experienced manic symptoms for an extended period of time?",
                        "How long have you been experiencing symptoms such as racing thoughts, decreased need for sleep, or grandiosity?",
                        "Can you describe the longest period of time you have experienced manic symptoms, and how long ago was that?",
                        "How long have you been feeling irritable or agitated?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson["elevated mood nearly everyday"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 2;
                      });
                      List<String> questions = [
                        "Can you describe how you feel on an average day, in terms of your mood and energy level?",
                        "Do you feel like your mood is consistently elevated, or does it fluctuate throughout the day?",
                        "Have you noticed any triggers or patterns to your elevated moods, such as particular times of day or certain situations?",
                        "Do you feel abnormally upbeat or happy for most of the day, nearly every day?",
                        "On average, how many hours each day do you feel like you are in an elevated mood?",
                        "How often do you feel overly happy or elated during the day?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Inflated self-esteem or grandiosity"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 3;
                      });
                      List<String> questions = [
                        "How do you feel about yourself compared to others around you?",
                        "Have you been feeling more confident or empowered than usual lately?",
                        "Can you describe a recent experience where you felt particularly powerful or invincible?",
                        "What are your thoughts on your own intelligence or abilities?",
                        "How have your goals or aspirations changed recently?",
                        "How have people been reacting to your ideas or plans lately?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson["Decreased need for sleep"] == -1) {
                      setState(() {
                        symptomIndex = 4;
                      });
                      List<String> questions = [
                        "Have you been having trouble falling asleep at night? Or are you finding that you need less sleep than usual?",
                        "Have you been experiencing any racing thoughts or ideas lately? Do you find that your mind is racing at night when you're trying to sleep?",
                        "Have you noticed any changes in your sleep patterns, such as sleeping less or experiencing insomnia?",
                        "How many hours of sleep did you get last night?",
                        "Have you had any trouble falling or staying asleep?",
                        "Do you feel like you could function well without much sleep?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "More talkative than usual or pressure to keep talking"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 5;
                      });
                      List<String> questions = [
                        "Do you find it hard to stop talking?",
                        "Have you friends or family commented on the way you are talking?",
                        "Do you find yourself talking more than usual?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Flight of ideas or subjective experience that thoughts are racing"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 6;
                      });
                      List<String> questions = [
                        "Do you find your thoughts racing?",
                        "Do you find it difficult to keep track of your thought?",
                        "Do your thoughts jump from place to place that makes it difficult for you to keep track of them?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } /*else if (SymptomsJson[
                            "Distractibility (i.e., attention too easily drawn to unimportant or irrelevant external stimuli)"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 7;
                      });
                      List<String> questions = [];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    }*/
                    else if (SymptomsJson[
                            "Increase in goal-directed activity (either socially, at work or school, or sexually) or psychomotor agitation"] ==
                        -1) {
                      setState(() {
                        symptomIndex = 8;
                      });
                      List<String> questions = [
                        "Have you taken on any new activities lately?",
                        "Have you come across any brilliant ideas lately?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } else if (SymptomsJson[
                            "Excessive involvement in activities that have a high potential for painful consequences (e.g., engaging in unrestrained buying sprees, sexual indiscretions, or foolish business investments)."] ==
                        -1) {
                      setState(() {
                        symptomIndex = 9;
                      });
                      List<String> questions = [
                        "Have you been doing things that are out of character for you ?",
                        "Have you done things that were unusual for you or that other people might have thought were excessive, foolish, or risky?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } /* else if (SymptomsJson[
                            "The mood disturbance is sufficiently severe to cause marked impairment in social or occupational functioning or to necessitate hospitalization to prevent harm to self or others, or there are psychotic features."] ==
                        -1) {
                      setState(() {
                        symptomIndex = 10;
                      });
                      List<String> questions = [];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    } */
                    else if (SymptomsJson[
                            "The episode is not attributable to the direct physiological effects of a substance (e.g., a drug of abuse, a medication, or other treatment) or another medical condition."] ==
                        -1) {
                      setState(() {
                        symptomIndex = 11;
                      });
                      List<String> questions = [
                        "Have you used any drugs or alcohol lately?",
                        "Have you been diagnosed with any medical conditions that could be causing these symptoms?"
                      ];

                      var random = new Random();
                      String randomQuestion =
                          questions[random.nextInt(questions.length)];
                      setState(() {
                        askedQuestion = randomQuestion;
                      });
                      print("index");
                      print(symptomIndex);
                    }

                    setState(() {
                      messages.add(ChatMessage(
                          text: askedQuestion, type: ChatMessageType.bot));
                    });
                    Future.delayed(const Duration(milliseconds: 500), () {
                      TextToSpeech.speak(askedQuestion);
                    });
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
