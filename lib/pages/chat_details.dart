import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../cubit/social_cubit.dart';
import '../models/user_model.dart';

class ChatDetailsPage extends StatefulWidget {
  const ChatDetailsPage(this.model, {Key? key}) : super(key: key);

  final UserData model;

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _textController = TextEditingController();
  String _enteredMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.model.image),
            ),
            const SizedBox(width: 16),
            Text(
              widget.model.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('chats')
                      .doc(widget.model.uid)
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final docs = snapshot.data!.docs;
                    final user = FirebaseAuth.instance.currentUser;
                    return Expanded(
                      child: ListView.separated(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: docs.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 8);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return buildMessage(
                            docs[index]['senderId'] == user!.uid,
                            docs[index]['message'],
                          );
                        },
                      ),
                    );
                  }),
              Container(
                margin: const EdgeInsets.only(top: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          onChanged: (val) =>
                              setState(() => _enteredMessage = val),
                          cursorColor: Theme.of(context).primaryColor,
                          autocorrect: true,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: defaultColor,
                      child: MaterialButton(
                        onPressed: _enteredMessage.trim().isEmpty
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                SocialCubit.get(context).sendMessage(
                                  dateTime: DateTime.now().toString(),
                                  text: _textController.text,
                                  receiverId: widget.model.uid,
                                );
                                _textController.clear();
                              },
                        minWidth: 1,
                        child: const Icon(
                          Icons.send,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //   },
    // );
  }

  Align buildMessage(bool isMe, String text) {
    return Align(
      alignment: isMe
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isMe ? defaultColor.withOpacity(0.6) : Colors.grey[300],
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(10),
            topEnd: const Radius.circular(10),
            bottomEnd: Radius.circular(isMe ? 0 : 10),
            bottomStart: Radius.circular(isMe ? 10 : 0),
          ),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
