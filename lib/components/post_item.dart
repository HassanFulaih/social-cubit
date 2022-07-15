import 'package:flutter/material.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart';

import '../constants.dart';
import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';
import '../models/post_model.dart';

class PostItem extends StatelessWidget {
  PostItem({
    Key? key,
    required this.cubit,
    required this.state,
    required this.post,
    required this.index,
  }) : super(key: key);

  final SocialCubit cubit;
  final SocialStates state;
  final PostModel post;
  final int index;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final likeList = post.interaction.where((i) => i.isLiked).toList();
    final commentList =
        post.interaction.where((i) => i.comment != null).toList();
    final Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (_, constraints) => Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        post.image ?? 'https://i.pravatar.cc/300',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.name,
                                style: const TextStyle(height: 1),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.check_circle, // Icons.verified_user
                                color: defaultColor,
                                size: 16,
                              ),
                            ],
                          ),
                          Text(post.dateTime,
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.expand_more_outlined)),
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                  color: Colors.grey[300],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    post.text,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: Wrap(
                //     children: [
                //       MaterialButton(
                //         onPressed: () {},
                //         height: 5,
                //         minWidth: 1,
                //         padding: const EdgeInsets.symmetric(horizontal: 5),
                //         child: const Text(
                //           '#Softwere',
                //           style: TextStyle(color: defaultColor),
                //         ),
                //       ),
                //       MaterialButton(
                //         onPressed: () {},
                //         height: 5,
                //         minWidth: 1,
                //         padding: const EdgeInsets.symmetric(horizontal: 5),
                //         child: const Text(
                //           '#Flutter',
                //           style: TextStyle(color: defaultColor),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                if (post.postImage != null)
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        post.postImage!,
                        fit: BoxFit.cover,
                        height: 140,
                        width: double.infinity,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showSlideDialog(
                          context: context,
                          child: SizedBox(
                            height: size.height * 0.5,
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemCount: likeList.length,
                              itemBuilder: (context, index) {
                                return BottomSheetItem(
                                  comment: null,
                                  image: likeList[index].image,
                                  name: likeList[index].name,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              post.numOfLikes.toString(),
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        showSlideDialog(
                          context: context,
                          child: SizedBox(
                            height: constraints.minWidth * 0.5,
                           // width: constraints.maxWidth,
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 6),
                              itemCount: commentList.length,
                              itemBuilder: (_, index) {
                                return BottomSheetItem(
                                  comment: commentList[index].comment,
                                  image: commentList[index].image,
                                  name: commentList[index].name,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, top: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.insert_comment_outlined,
                              color: defaultColor,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            state is GetInteractionLoadingStatus
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(
                                    post.numOfComments.toString(),
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 15, thickness: 1, color: Colors.grey[300]),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage:
                                  NetworkImage(cubit.userData!.image),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                cursorColor: defaultColor,
                                autocorrect: true,
                                enableSuggestions: true,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _textController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'write a comment ...',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: _textController.text.trim().isEmpty
                                  ? null
                                  : () {
                                      FocusScope.of(context).unfocus();
                                      cubit.addComment(
                                        post.postId,
                                        _textController.text,
                                        post.interaction.firstWhere((element) =>
                                            element.userId ==
                                            cubit.userData!.uid),
                                      );
                                      _textController.clear();
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => cubit.likePost(
                          post.interaction.firstWhere((element) =>
                              element.userId == cubit.userData!.uid),
                          post.postId),
                      child: Row(
                        children: [
                          Icon(
                            post.interaction.any((element) =>
                                    element.userId == cubit.userData!.uid)
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: Colors.red,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem({
    Key? key,
    required this.image,
    required this.name,
    required this.comment,
  }) : super(key: key);

  final String image;
  final String name;
  final String? comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: comment == null ? 16 : 20,
            backgroundImage: NetworkImage(image),
          ),
          const SizedBox(width: 6),
          comment == null
              ? buildContainer()
              : Expanded(
                  child: buildContainer(),
                ),
        ],
      ),
    );
  }

  Container buildContainer() {
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            comment == null
                ? const SizedBox()
                : Text(
                    comment!,
                    style: const TextStyle(fontSize: 12),
                  ),
          ],
        ),
      ),
    );
  }
}
