import 'package:bond/shared/styles/styles.dart';
import 'package:flutter/material.dart';

Widget customSearchBar(BuildContext context, Function(dynamic) onSearch) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: const Icon(Icons.search, color: primaryColor),
      ),
      onChanged: (query) => onSearch(query),
    ),
  );
}
