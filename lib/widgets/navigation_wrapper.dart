import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:only_shef/provider/profile_state_provider.dart';
import 'package:only_shef/widgets/custome_nav_bar.dart';
import 'package:only_shef/widgets/chef_nav_bar.dart';

class NavigationWrapper extends StatelessWidget {
  final Widget child;

  const NavigationWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileState = Provider.of<ProfileStateProvider>(context);

    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: profileState.isChefProfile
              ? ChefNavigationBar(currentIndex: 0, onTap: (index) {})
              : CustomNavigationBar(
                  currentIndex: 0,
                  onTap: (index) {
                    
                  },
              ),
        ),
      ],
    );
  }
}
