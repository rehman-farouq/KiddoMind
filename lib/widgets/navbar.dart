import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kids_learning_app/cubit/index_cubit.dart';

class BottomNavBar extends StatefulWidget {
  final PageController pageController;

  const BottomNavBar({Key? key, required this.pageController})
    : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexCubit, int>(
      builder: (context, currentIndex) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3), Color(0xFFFFF3E0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 3,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: GNav(
                selectedIndex: currentIndex,
                backgroundColor: Colors.transparent,

                /// 🎨 FUN EFFECTS
                rippleColor: Colors.white,
                hoverColor: Colors.white,

                gap: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),

                duration: const Duration(milliseconds: 350),
                tabBorderRadius: 25,

                /// 🌈 ACTIVE TAB STYLE
                tabBackgroundColor: const Color(0xFF4DD0E1).withOpacity(0.3),

                color: Colors.grey.shade600,
                activeColor: const Color(0xFF00838F),

                iconSize: 28,

                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),

                onTabChange: (index) {
                  widget.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );

                  context.read<IndexCubit>().changeIndex(index);
                },

                tabs: const [
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home 🏠',
                    iconActiveColor: Colors.redAccent,
                  ),
                  GButton(
                    icon: Icons.explore_rounded,
                    text: 'Explore 🌍',
                    iconActiveColor: Colors.blueAccent,
                  ),
                  GButton(
                    icon: Icons.person_rounded,
                    text: 'About 👦',
                    iconActiveColor: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
