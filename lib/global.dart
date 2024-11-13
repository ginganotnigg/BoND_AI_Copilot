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
  textStyle: const TextStyle(fontSize: 16, fontFamily: 'Arya'),
);

ButtonStyle filled = ElevatedButton.styleFrom(
  backgroundColor: primaryColor,
  foregroundColor: Colors.white,
  textStyle: const TextStyle(
      fontSize: 16, fontFamily: 'Arya', fontWeight: FontWeight.w700),
);

// Tokens
const String jarvisToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU5YWY1NWRjLTNlOWMtNDNhYi1hMWIyLTA5NTY4ZjQ0OTBjMyIsImVtYWlsIjoiYWxleGllOTkxMUBnbWFpbC5jb20iLCJpYXQiOjE3MzEyMjkzMjAsImV4cCI6MTczMTIzMTEyMH0.VfY0D6OB88wnZMjXkGJuQ62c_uCAs9q8Hs-ircYDZC4";

const String jarvisGuid = "361331f8-fc9b-4dfe-a3f7-6d9a1e8b289b";

// URLs
const String baseUrl = 'https://api.jarvis.cx/api';
const String aiChatUrl = '$baseUrl/v1/ai-chat';
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
