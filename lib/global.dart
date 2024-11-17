import 'package:flutter/material.dart';

// Colors
const Color primaryColor = Color(0xFFBB68AA);
const Color secondaryColor = Color(0xFF73ACAA);
const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[secondaryColor, primaryColor],
    tileMode: TileMode.mirror);

// Style
ButtonStyle outlined = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  foregroundColor: primaryColor,
  side: const BorderSide(color: primaryColor),
  textStyle: const TextStyle(fontSize: 16, fontFamily: 'FiraSans'),
);

ButtonStyle filled = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: Colors.white,
  textStyle: const TextStyle(
      fontSize: 16, fontFamily: 'FiraSans', fontWeight: FontWeight.w700),
);

// Tokens
const String jarvisGuid = "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b";

const String jarvisToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzMzgyYTZkLTMwYmItNGQ1Zi05YzVlLWU5NjlhNWFkYjcyMSIsImVtYWlsIjoicGhhbWNvbmdiYW5nMDNAZ21haWwuY29tIiwiaWF0IjoxNzMxODE1NDk0LCJleHAiOjE3MzE4MTcyOTR9.gmia5-f-4Jj5IEXlfTVvYk1lWNj0GG6e63jTXdH7Ydk";

// URLs
const String baseUrl = 'https://api.jarvis.cx/api';
const String aiChatUrl = '$baseUrl/v1/ai-chat';
const String allConversationsUrl = '$aiChatUrl/conversations';
const String loginUrl = '$baseUrl/v1/auth/login';
const String signUpUrl = '$baseUrl/v1/auth/signup';
const String promptUrl = '$baseUrl/api/v1/prompts';

// Enum
enum PromptCategory {
  business,
  career,
  chatbot,
  coding,
  education,
  fun,
  marketing,
  other,
  productivity,
  seo,
  writing,
}
