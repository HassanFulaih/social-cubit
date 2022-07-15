import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';

class NewPost extends StatelessWidget {
  NewPost({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final SocialCubit cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Post'),
            titleSpacing: 0.0,
            actions: [
              TextButton(
                child: const Text('POST'),
                onPressed: () {
                  cubit.createPost(
                    context,
                    dateTime: DateTime.now().toString(),
                    text: _textController.text,
                  );
                  if (state is CreatePostSuccessStatus) {
                    //_textController.clear();
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                if (state is CreatePostLoadingStatus)
                  const LinearProgressIndicator(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(cubit.userData!.image),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hassan Fulaih',
                            style: TextStyle(height: 1),
                          ),
                          Text('Public',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What\'s on your mind?',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Container(
                        height: 170,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: FileImage(cubit.postImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => cubit.removeImage('post'),
                        icon: const CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.close, size: 18),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        onPressed: () =>
                            cubit.pickImage(ImageSource.gallery, 'post'),
                        label: const Text('Add Photo'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        child: const Text('# Tags'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
