import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/post_item.dart';
import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';

class Feeds extends StatelessWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final SocialCubit cubit = SocialCubit.get(context);
        return RefreshIndicator(
          onRefresh: () async {
            cubit.getPosts();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: 6,
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.network(
                          'https://img.freepik.com/free-psd/desktop-screen-with-website-presentation-mockup-isolated_359791-182.jpg?t=st=1657026725~exp=1657027325~hmac=7d7112ed3c6847491c215f97d96d753dcdb2a8759201c1f6ee3a5020e09232c0&w=900',
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: Text(
                            'Communicate with your colleagues',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (cubit.posts.isEmpty ||
                cubit.posts.isEmpty || cubit.userData == null
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cubit.posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PostItem(
                            cubit: cubit,
                            state: state,
                            post: cubit.posts[index],
                            index: index,
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                      ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
