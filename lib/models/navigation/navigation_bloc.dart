import 'package:flutter_algorand_wallet/blocs/navigation/navigation_event.dart';
import 'package:flutter_algorand_wallet/models/navigation/navigation_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationTab> {
  NavigationBloc(NavigationTab tab) : super(tab);

  void changeTab(NavigationTab tab) {
    add(NavigationTabChanged(tab: tab));
  }

  @override
  Stream<NavigationTab> mapEventToState(NavigationEvent event) async* {
    if (event is NavigationTabChanged) {
      yield event.tab;
    }
  }

  NavigationTab get currentTab => state;
}
