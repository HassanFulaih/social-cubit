import 'package:flutter/material.dart';

void showSnakBar(ctx, String message, color) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 20,
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: color,
      ),
    );
  }