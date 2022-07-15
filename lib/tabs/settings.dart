import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';
import '../helpers/cache.dart';
import '../pages/edit_profile.dart';
import '../pages/register.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final SocialCubit cubit = SocialCubit.get(context);
        return cubit.userData == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 210,
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.topCenter,
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                  child: Image.network(
                                    cubit.userData!.cover,
                                    fit: BoxFit.cover,
                                    height: 170,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              radius: 64,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(
                                  cubit.userData!.image,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(cubit.userData!.name,
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 5),
                      Text(cubit.userData!.bio ?? 'Write your bio here...',
                          style: Theme.of(context).textTheme.caption),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => {},
                                child: Column(
                                  children: [
                                    Text(100.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    const SizedBox(height: 5),
                                    Text('Posts',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => {},
                                child: Column(
                                  children: [
                                    Text('302',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    const SizedBox(height: 5),
                                    Text('Photos',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => {},
                                child: Column(
                                  children: [
                                    Text('172',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    const SizedBox(height: 5),
                                    Text('Followers',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => {},
                                child: Column(
                                  children: [
                                    Text('72',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    const SizedBox(height: 5),
                                    Text('Following',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                CacheHelper.logout().then(
                                  (value) {
                                    if (value)
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(),
                                        ),
                                      );
                                  },
                                );
                              },
                              child: const Text(
                                'LOGOUT',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            },
                            child: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: OutlinedButton(
                      //         onPressed: () async {
                      //           FirebaseMessaging.instance
                      //               .subscribeToTopic('announcements');
                      //           FirebaseMessaging.instance.requestPermission(
                      //             announcement: true,
                      //           );
                      //         },
                      //         child: const Text(
                      //           'Subscribe',
                      //           style: TextStyle(fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     Expanded(
                      //       child: OutlinedButton(
                      //         onPressed: () {
                      //           FirebaseMessaging.instance
                      //               .unsubscribeFromTopic('announcements');
                      //         },
                      //         child: const Text(
                      //           'Unsubscribe',
                      //           style: TextStyle(fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      if (state is SocialUserDataErrorStatus)
                        const Center(child: Text('An error occurred')),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
