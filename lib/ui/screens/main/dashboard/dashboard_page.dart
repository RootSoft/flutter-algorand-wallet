import 'package:algorand_dart/algorand_dart.dart';
import 'package:clipboard/clipboard.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_algorand_wallet/models/transaction_event.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/algorand/algorand_balance.dart';
import 'package:flutter_algorand_wallet/ui/components/algorand/crypto_card.dart';
import 'package:flutter_algorand_wallet/ui/components/algorand/transaction_tile.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/transfer/asset_transfer_screen.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/dashboard/dashboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  CustomPopupMenuController _menuController = CustomPopupMenuController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<DashboardBloc>(context, listen: false).reload();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    _menuController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardBloc>().state;

    if (state is DashboardNoAccount) {
      return provideWalletPage();
    }

    if (state is! DashboardSuccess) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final account = state.account;
    final accountInformation = state.information;
    final assets = state.assets;
    final transactions = state.transactions;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          VerticalSpacing(of: paddingSizeDefault),
          _buildTotalBalance(
            context,
            accountInformation.amountWithoutPendingRewards,
            accountInformation.pendingRewards,
            account,
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(paddingSizeDefault),
              shrinkWrap: true,
              itemCount: assets.length,
              itemBuilder: (widget, index) => CryptoCard(
                selected: assets[index] == state.selectedAsset,
                asset: assets[index],
                image: Image.asset(
                  "assets/images/algo_icon.png",
                ),
                onTapped: (asset) =>
                    context.read<DashboardBloc>().setSelectedAsset(asset),
                onLongPress: (asset) async {
                  await FlutterClipboard.copy('${asset.id}');

                  final snackBar = SnackBar(
                    content: Text('Asset id copied to clipboard'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: paddingSizeNormal);
              },
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: new Container(
                padding: EdgeInsets.all(paddingSizeDefault),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 8,
                          child: _buildSendButton(context),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 8,
                          child: _buildReceiveButton(
                              context, accountInformation.address),
                        ),
                        Spacer(),
                        Expanded(
                          flex: 8,
                          child: _buildCompoundButton(context),
                        ),
                      ],
                    ),

                    VerticalSpacing(of: paddingSizeDefault),

                    /// Transactions
                    Text(
                      'Transactions',
                      style: Theme.of(context).textTheme.headline6?.copyWith(),
                    ),

                    /// Build the transactions
                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (state.isFetchingTransactions) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.transactions.isEmpty) {
                            return Center(child: Text('No transactions found'));
                          }

                          return ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: transactions.length,
                            itemBuilder: (widget, index) => CustomPopupMenu(
                              controller: _menuController,
                              barrierColor: Colors.transparent,
                              pressType: PressType.singleClick,
                              arrowColor: Palette.accentColor,
                              menuBuilder: () {
                                return _buildTransactionMenu(
                                  transactions[index],
                                );
                              },
                              child: TransactionTile(
                                transaction: transactions[index],
                                onTap: (transaction) async {},
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(color: Palette.activeColor);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the total balance
  Widget _buildTotalBalance(
      BuildContext context, int amount, int pendingRewards, Account account) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total balance',
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Palette.subtitleColor,
                    ),
              ),
            ],
          ),
          VerticalSpacing(of: marginSizeSmall),
          AlgorandBalance(
            balance: Algo.fromMicroAlgos(amount).toString(),
          ),
          VerticalSpacing(of: marginSizeDefault),
          Text(
            'Pending Rewards',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Palette.subtitleColor,
                ),
          ),
          VerticalSpacing(of: marginSizeSmall),
          AlgorandBalance(
            balance: Algo.fromMicroAlgos(pendingRewards).toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionMenu(TransactionEvent transaction) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 300,
        color: Palette.accentColor,
        child: GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          crossAxisCount: 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            IconButton(
              icon: Icon(
                FeatherIcons.eye,
                color: Colors.white,
              ),
              onPressed: () async {
                await launch(
                    'https://testnet.algoexplorer.io/tx/${transaction.id}');

                _menuController.hideMenu();
              },
            ),
            IconButton(
              icon: Icon(
                FeatherIcons.copy,
                color: Colors.white,
              ),
              onPressed: () async {
                await FlutterClipboard.copy('${transaction.id}');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied transaction id to clipboard')),
                );

                _menuController.hideMenu();
              },
            ),
            IconButton(
              icon: Icon(
                FeatherIcons.user,
                color: Colors.white,
              ),
              onPressed: () async {
                router.navigateTo(
                    context, '/share/address/${transaction.receiver}');

                _menuController.hideMenu();
              },
            ),
            IconButton(
              icon: Icon(
                FeatherIcons.xCircle,
                color: Colors.white,
              ),
              onPressed: () {
                _menuController.hideMenu();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return RoundedButton(
      text: 'Send',
      selected: true,
      onPressed: () {
        final state = context.read<DashboardBloc>().state;
        if (state is DashboardSuccess && state.selectedAsset != null) {
          router.navigateTo(
            context,
            AssetTransferScreen.routeName,
            routeSettings: RouteSettings(
              arguments: state.selectedAsset,
            ),
          );
        }
      },
    );
  }

  Widget _buildReceiveButton(BuildContext context, String address) {
    return RoundedButton(
      text: 'Receive',
      onPressed: () {
        router.navigateTo(context, '/share/address/$address');
      },
    );
  }

  Widget _buildCompoundButton(BuildContext context) {
    return RoundedButton(
      text: 'Compound',
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Compound"),
              content: Text(
                  "This will send a transaction with a minimum fee in order to collect your rewards."),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(); // dismiss dialog
                  },
                ),
                TextButton(
                  child: Text("Continue"),
                  onPressed: () {
                    context.read<DashboardBloc>().compound();
                    Navigator.of(context).pop(); // dismiss dialog
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
