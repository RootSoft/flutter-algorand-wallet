import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/profile/bloc/profile_bloc.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/profile/profile_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'bloc/profile_bloc.dart';
export 'bloc/profile_event.dart';
export 'bloc/profile_state.dart';
export 'profile_page.dart';

/// Inject & provide the profile
Widget provideProfilePage() {
  return BlocProvider<ProfileBloc>(
    create: (_) => ProfileBloc(accountRepository: accountRepository)..start(),
    child: ProfilePage(),
  );
}
