import 'package:clipboard/clipboard.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/dashboard/dashboard.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  static String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileBloc>().state;
    if (state is ProfileNoAccount) {
      return provideWalletPage();
    }

    if (state is ProfileInProgress) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is! ProfileSuccess) {
      return Container();
    }

    final account = state.account;
    final seedphrase = state.seedphrase;

    return Container(
      padding: EdgeInsets.all(paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Account address
          Text(
            'Account',
            style: boldTextStyle.copyWith(fontSize: fontSizeMedium),
          ),
          VerticalSpacing(of: marginSizeSmall),
          GestureDetector(
            onTap: () async {
              await FlutterClipboard.copy(account.publicAddress);

              final snackBar = SnackBar(
                content: Text('Algorand address copied to clipboard'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: account.publicAddress,
                    style: regularTextStyle.copyWith(fontSize: fontSizeSmall),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        FeatherIcons.copy,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          VerticalSpacing(of: marginSizeDefault),

          /// Seed phrase
          Text(
            'Word list',
            style: boldTextStyle.copyWith(fontSize: fontSizeMedium),
          ),
          VerticalSpacing(of: marginSizeSmall),
          GestureDetector(
            onTap: () async {
              await FlutterClipboard.copy(seedphrase);

              final snackBar = SnackBar(
                content: Text('Word list copied to clipboard'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: seedphrase,
                    style: regularTextStyle.copyWith(fontSize: fontSizeSmall),
                  ),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        FeatherIcons.copy,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Spacer(),

          /// Fund account
          RoundedButton(
            text: 'Fund account',
            selected: true,
            onPressed: () async {
              await launch(
                'https://bank.testnet.algorand.network/?account=${account.publicAddress}',
                forceWebView: true,
                enableJavaScript: true,
              );
            },
          ),
        ],
      ),
    );
  }
}
