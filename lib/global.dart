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
const String jarvisGuid = "659d242b-fa8a-4acc-a79b-0df3089d497a";

const String jarvisToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1OWQyNDJiLWZhOGEtNGFjYy1hNzliLTBkZjMwODlkNDk3YSIsImVtYWlsIjoiZHVja2R6dW5nQGdtYWlsLmNvbSIsImlhdCI6MTczNTA5NTI2NiwiZXhwIjoxNzM1MTgxNjY2fQ.djR9Akr_APEnJG-hlYeoHEfcozgm4JwYQIYvJ0iW3KM";

const String refreshToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzMzgyYTZkLTMwYmItNGQ1Zi05YzVlLWU5NjlhNWFkYjcyMSIsImVtYWlsIjoicGhhbWNvbmdiYW5nMDNAZ21haWwuY29tIiwiaWF0IjoxNzMyMTIwNzY2LCJleHAiOjE3NjM2NTY3NjZ9.Rl3CvHYxmH-Reuy1GCejlTQcw3O8jDAALV9uAtOSymI";

// URLs
const String baseUrl = 'https://api.jarvis.cx/api';
const String aiChatUrl = '$baseUrl/v1/ai-chat/messages';
const String allConversationsUrl = '$baseUrl/v1/ai-chat/conversations';
const String loginUrl = '$baseUrl/v1/auth/sign-in';
const String signUpUrl = '$baseUrl/v1/auth/sign-up';
const String promptUrl = '$baseUrl/v1/prompts';
const String subscribeUrl = '$baseUrl/v1/subscriptions/subscribe';
const String aiEmailUrl = '$baseUrl/v1/ai-email';
