import 'package:flutter_algorand_wallet/models/algorand_standard_asset_model.dart';
import 'package:flutter_algorand_wallet/models/navigation/navigation_bloc.dart';
import 'package:flutter_algorand_wallet/routes/routes.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/create/asset_form.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/transfer/asset_transfer.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/bloc/main_bloc.dart';
import 'package:flutter_algorand_wallet/ui/screens/screens.dart';
import 'package:flutter_algorand_wallet/ui/screens/share/share_address_screen.dart';
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

var assetFormHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return BlocProvider<AssetFormBloc>(
      create: (_) => AssetFormBloc(accountRepository: accountRepository),
      child: AssetFormScreen(),
    );
  },
);

var shareAddressHandler = Handler(
  handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    final address = params['address']?[0] ?? '';

    return BlocProvider<AssetFormBloc>(
      create: (_) => AssetFormBloc(accountRepository: accountRepository),
      child: ShareAddressScreen(
        address: address,
      ),
    );
  },
);
