import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../pages/chat_details.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(this.model, {Key? key}) : super(key: key);

  final UserData model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatDetailsPage(model),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(model.image),
            ),
            const SizedBox(width: 16),
            Text(
              model.name,
              style: const TextStyle(height: 1),
            ),
          ],
        ),
      ),
    );
  }
}
