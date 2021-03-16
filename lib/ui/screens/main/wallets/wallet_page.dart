import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/components/wallet_card.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/wallets/wallet.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatelessWidget {
  static String routeName = '/wallet';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallets',
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontSize: fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
          ),
          VerticalSpacing(of: paddingSizeNormal),
          Text(
            'Create or import a wallet to start sending and receiving digital currency',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(),
          ),
          Spacer(),
          WalletCard(
            title: 'Create',
            subtitle: 'a new wallet',
            onTapped: () async {
              final result = await showOkCancelAlertDialog(
                context: context,
                title: 'Create new account',
                message:
                    'This will remove your existing account. Make sure you backed up the passphrase before continuing or you will lose your account.',
              );

              if (result == OkCancelResult.ok) {
                context.read<WalletBloc>().createWallet();
              }
            },
          ),
          VerticalSpacing(of: paddingSizeNormal),
          WalletCard(
            title: 'Import',
            subtitle: 'an existing wallet',
            textColor: Palette.white,
            backgroundColor: Palette.accentColor,
            onTapped: () async {
              final result = await showOkCancelAlertDialog(
                context: context,
                title: 'Recover from Passphrase',
                message:
                    'This will remove your existing account. Make sure you backed up the passphrase before continuing or you will lose your account.',
              );

              if (result == OkCancelResult.ok) {
                final input = await showTextInputDialog(
                  textFields: [DialogTextField()],
                  context: context,
                  title: 'Recover from Passphrase',
                  message: 'Recover an account with a 25-word passphrase.',
                );

                if (input != null && input.length > 0) {
                  context.read<WalletBloc>().importWallet(input[0]);
                }
              }
            },
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}
