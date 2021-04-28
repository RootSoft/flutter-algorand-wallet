import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/list_asset_page.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/list_assets.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/dashboard/bloc/dashboard_bloc.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/dashboard/dashboard_page.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/wallets/wallet.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/wallets/wallet_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'bloc/dashboard_bloc.dart';
export 'bloc/dashboard_event.dart';
export 'bloc/dashboard_state.dart';
export 'dashboard_page.dart';

/// Inject & provide the dashboard
Widget provideDashboardPage() {
  return BlocProvider<DashboardBloc>(
    create: (_) => DashboardBloc(accountRepository: accountRepository)..start(),
    child: DashboardPage(),
  );
}

/// Inject & provide the wallet screen
Widget provideWalletPage() {
  return BlocProvider(
    create: (_) => WalletBloc(accountRepository: accountRepository)..start(),
    child: WalletPage(),
  );
}

/// Inject & provide the list assets screen
Widget provideAssetPage() {
  return BlocProvider<ListAssetBloc>(
    create: (_) => ListAssetBloc(accountRepository: accountRepository)..start(),
    child: ListAssetPage(),
  );
}
