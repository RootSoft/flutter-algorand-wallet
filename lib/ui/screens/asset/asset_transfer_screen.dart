import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/asset_transfer.dart';
import 'package:flutter_algorand_wallet/utils/crypto_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/material.dart';

class AssetTransferScreen extends StatefulWidget {
  static String routeName = '/asset/:assetId/transfer';

  @override
  _AssetTransferScreenState createState() => _AssetTransferScreenState();
}

class _AssetTransferScreenState extends State<AssetTransferScreen> {
  double amount = 0;
  final _formKey = GlobalKey<FormState>();
  final recipientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New transaction'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(paddingSizeDefault),
          child: BlocConsumer<AssetTransferBloc, AssetTransferState>(
            listener: (context, state) {
              if (state is AssetTransferSentSuccess) {
                router.pop(context);
              }
            },
            builder: (context, state) {
              if (state is! AssetTransferSuccess) {
                return Container();
              }

              final asset = state.asset;

              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${CryptoUtils.format(asset.amount, asset.decimals)} ${asset.name}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Palette.textColor),
                    ),
                    VerticalSpacing(of: paddingSizeLarge),
                    Text(
                      'Amount',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Palette.textColor),
                    ),
                    VerticalSpacing(of: paddingSizeDefault),
                    SpinBox(
                      min: 1,
                      max: double.infinity,
                      value: 0,
                      onChanged: (value) {
                        amount = value;
                      },
                      cursorColor: Palette.accentColor,
                      decimals: asset.decimals,
                    ),
                    VerticalSpacing(of: 60),
                    Text(
                      'Recipient wallet',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Palette.textColor),
                    ),
                    TextFormField(
                      controller: recipientController,
                      validator: (String? v) {
                        final value = v ?? '';
                        if (!Address.isAlgorandAddress(value)) {
                          return 'Invalid Algorand address';
                        }

                        return null;
                      },
                    ),
                    Spacer(),
                    RoundedButton(
                      text: 'Send Payment',
                      selected: true,
                      onPressed: () {
                        final isValid =
                            _formKey.currentState?.validate() ?? false;
                        if (isValid) {
                          context.read<AssetTransferBloc>().sendPayment(
                              amount: amount,
                              recipientAddress: recipientController.text);
                        }
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    recipientController.dispose();
    super.dispose();
  }
}
