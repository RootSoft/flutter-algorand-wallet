import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/create/asset_form.dart';
import 'package:flutter_algorand_wallet/utils/number_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AssetFormScreen extends StatefulWidget {
  static String routeName = '/asset/create';

  @override
  _AssetFormScreenState createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends State<AssetFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final assetNameController = TextEditingController();

  final unitNameController = TextEditingController();

  final totalAmountController = TextEditingController();

  final decimalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create asset'),
      ),
      body: SafeArea(
        child: BlocListener<AssetFormBloc, AssetFormState>(
          listener: (_, state) async {
            if (state is AssetFormSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Asset created')));

              router.pop(context);
            }

            if (state is AssetFormFailure) {
              final cause = state.exception.cause;
              final errorMessage = cause is DioError
                  ? cause.response?.data['message']
                  : state.exception.message;

              await showOkAlertDialog(
                context: context,
                title: 'Unable to create asset',
                message: errorMessage,
              );
            }
          },
          child: Builder(
            builder: (context) {
              final state = context.watch<AssetFormBloc>().state;
              if (state is AssetFormInProgress) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Container(
                padding: EdgeInsets.all(paddingSizeDefault),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Asset name',
                          style:
                              boldTextStyle.copyWith(fontSize: fontSizeMedium),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Algorand',
                          ),
                          controller: assetNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid asset name';
                            }
                            return null;
                          },
                        ),
                        VerticalSpacing(of: paddingSizeDefault),
                        Text(
                          'Unit name',
                          style:
                              boldTextStyle.copyWith(fontSize: fontSizeMedium),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Algo',
                          ),
                          controller: unitNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid unit name';
                            }
                            return null;
                          },
                        ),
                        VerticalSpacing(of: paddingSizeDefault),
                        Text(
                          'Number of coins to create?',
                          style:
                              boldTextStyle.copyWith(fontSize: fontSizeMedium),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '100',
                          ),
                          controller: totalAmountController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !isInt(value)) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                        VerticalSpacing(of: paddingSizeDefault),
                        Text(
                          'Decimals',
                          style:
                              boldTextStyle.copyWith(fontSize: fontSizeMedium),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: '0',
                          ),
                          controller: decimalController,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !isInt(value)) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                        VerticalSpacing(of: paddingSizeDefault),
                        RoundedButton(
                          text: 'Create',
                          selected: true,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final assetName = assetNameController.text;
                              final unitName = unitNameController.text;
                              final amount = totalAmountController.text;
                              final decimals = decimalController.text;

                              /// Create the asset
                              context.read<AssetFormBloc>().createAsset(
                                    assetName: assetName,
                                    unitName: unitName,
                                    amount: int.tryParse(amount) ?? 0,
                                    decimals: int.tryParse(decimals) ?? 0,
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
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
    assetNameController.dispose();
    unitNameController.dispose();
    totalAmountController.dispose();
    decimalController.dispose();
    super.dispose();
  }
}
