import 'package:algorand_dart/algorand_dart.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_algorand_wallet/models/navigation/navigation_bloc.dart';
import 'package:flutter_algorand_wallet/models/navigation/navigation_tab.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/bloc/main_bloc.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/dashboard/dashboard.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/profile/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

final tabHandlers = <NavigationTab, Widget>{
  NavigationTab(label: 'Dashboard', icon: FeatherIcons.barChart2):
      provideDashboardPage(),
  NavigationTab(label: 'Wallet', icon: FeatherIcons.pocket):
      provideWalletPage(),
  NavigationTab(label: 'Transactions', icon: FeatherIcons.globe):
      Container(color: Palette.accentColor),
  NavigationTab(label: 'Profile', icon: FeatherIcons.user):
      provideProfilePage(),
};

final tabs = tabHandlers.keys.toList();

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<MainBloc, Account?>(
          listener: (context, state) {
            context.read<NavigationBloc>().changeTab(tabs[0]);
          },
          child: Builder(
            builder: (BuildContext context) {
              final navigationTab = context.watch<NavigationBloc>().currentTab;
              final index = tabs.indexOf(navigationTab);
              return IndexedStack(
                index: index,
                children: tabHandlers.values.toList(),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final navigationTab = context.watch<NavigationBloc>().currentTab;
          final index = tabs.indexOf(navigationTab);

          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Palette.activeColor,
            unselectedItemColor: Palette.inactiveColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: index,
            onTap: (index) =>
                context.read<NavigationBloc>().changeTab(tabs[index]),
            items: List.generate(
              tabs.length,
              (index) => BottomNavigationBarItem(
                label: tabs[index].label,
                icon: Icon(tabs[index].icon),
              ),
            ),
          );
        },
      ),
    );
  }
}
