import 'package:flutter_algorand_wallet/models/algorand_standard_asset_model.dart';
import 'package:flutter_algorand_wallet/models/navigation/navigation_bloc.dart';
import 'package:flutter_algorand_wallet/routes/routes.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/asset_transfer.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/bloc/main_bloc.dart';
import 'package:flutter_algorand_wallet/ui/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var rootHandler = Handler(
  type: HandlerType.route,
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          create: (_) => MainBloc(accountRepository: accountRepository),
        ),
        BlocProvider<NavigationBloc>(
          create: (_) => NavigationBloc(tabs[0]),
        ),
      ],
      child: MainScreen(),
    );
  },
);

var assetTransferHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    final asset = context?.settings?.arguments;
    if (asset is! AlgorandStandardAsset) return null;

    return BlocProvider(
      create: (_) =>
          AssetTransferBloc(accountRepository: accountRepository)..start(asset),
      child: AssetTransferScreen(),
    );
  },
);
