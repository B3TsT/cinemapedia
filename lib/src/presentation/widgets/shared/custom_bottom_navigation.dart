import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({super.key, required this.currentIndex});
  final int currentIndex;

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
      default:
        context.go('/home/0');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    return NavigationBar(
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: size.height * 0.1,
      backgroundColor: colors.background,
      shadowColor: Colors.amber,
      selectedIndex: currentIndex,
      onDestinationSelected: (value) => onItemTapped(context, value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_max),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.thumbs_up_down_outlined),
          label: 'Categorias',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_outline),
          label: 'Favoritos',
        ),
      ],
    );
  }
}
