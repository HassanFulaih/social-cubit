import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/chat_item.dart';
import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';

class Chats extends StatelessWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return 
        cubit.users.isEmpty
        //state is GetAllUserLoadingStatus
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: cubit.users.length,
                itemBuilder: (context, index) {
                  return ChatItem(cubit.users[index]);
                },
                separatorBuilder: (context, index) => const Divider(),
              );
      },
    );
  }
}
