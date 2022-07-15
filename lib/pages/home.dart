import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/social_cubit.dart';
import '../cubit/social_state.dart';
import 'new_post.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: screenWidth > 600
                ? Row(
                    children: <Widget>[
                      NavigationRail(
                        trailing: IconButton(
                          icon: const Icon(Icons.brightness_7_outlined),
                          onPressed: () => cubit.changeThemeMode(),
                        ),
                        selectedIndex: cubit.currentIndex,
                        onDestinationSelected: cubit.changeTab,
                        labelType: NavigationRailLabelType.all,
                        useIndicator: true,
                        elevation: 5,
                        backgroundColor: Colors.grey[200],
                        indicatorColor: Colors.cyan[100],
                        selectedLabelTextStyle: const TextStyle(
                          color: defaultColor,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelTextStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        destinations: const <NavigationRailDestination>[
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Home'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.chat_bubble_outline),
                            selectedIcon: Icon(Icons.chat_bubble),
                            label: Text('Chat'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings_outlined),
                            selectedIcon: Icon(Icons.settings),
                            label: Text('Settings'),
                          ),
                        ],
                      ),
                      const VerticalDivider(thickness: 1, width: 1),
                      Expanded(
                        child: Center(
                          child: cubit.screens[cubit.currentIndex],
                        ),
                      )
                    ],
                  )
                : cubit.screens[cubit.currentIndex],
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => NewPost()),
              ),
              child: const Icon(Icons.add, size: 32), //icon inside button
            ),
            bottomNavigationBar: screenWidth > 600
                ? null
                : BottomNavigationBar(
                    onTap: cubit.changeTab,
                    currentIndex: cubit.currentIndex,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.chat_bubble),
                        label: 'Chats',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
