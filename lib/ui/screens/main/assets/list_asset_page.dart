import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/create/asset_form.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/list_assets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ListAssetPage extends StatelessWidget {
  static String routeName = '/assets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ListAssetBloc, ListAssetState>(
        listener: (_, state) async {
          if (state is ListAssetOptInSuccess) {
            final snackBar = SnackBar(
              content:
                  Text('You can now send & receive ${state.asset.params.name}'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          if (state is ListAssetFailure) {
            await showOkAlertDialog(
              context: context,
              title: 'Unable to opt in to asset',
              message: state.exception.message,
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingSizeDefault),
          child: Column(
            children: [
              /// Show search bar
              TextFormField(
                autovalidateMode: AutovalidateMode.always,
                decoration: const InputDecoration(
                  icon: Icon(FeatherIcons.search),
                  hintText: 'Search for assets',
                  border: InputBorder.none,
                ),
                cursorColor: Palette.accentColor,
                onFieldSubmitted: (input) {
                  context.read<ListAssetBloc>().search(input);
                },
              ),

              VerticalSpacing(of: paddingSizeDefault),

              /// Display list of assets
              Expanded(
                child: _buildAssetList(context),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          FeatherIcons.edit2,
          color: Colors.white,
        ),
        onPressed: () {
          router.navigateTo(
            context,
            AssetFormScreen.routeName,
          );
        },
      ),
    );
  }

  Widget _buildAssetList(BuildContext context) {
    final state = context.watch<ListAssetBloc>().state;
    if (state is ListAssetInProgress) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is! ListAssetSuccess) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final assets = state.assets;

    return ListView.separated(
      shrinkWrap: true,
      itemCount: assets.length,
      itemBuilder: (widget, index) {
        final asset = assets[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: paddingSizeSmall),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    await FlutterClipboard.copy('${asset.index}');

                    final snackBar = SnackBar(
                      content: Text('Asset id copied to clipboard'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text(
                    '${asset.params.name} (${asset.index})',
                    style: boldTextStyle.copyWith(fontSize: fontSizeMedium),
                  ),
                ),
              ),
              RoundedButton(
                text: 'Opt in',
                onPressed: () {
                  context.read<ListAssetBloc>().optIn(asset);
                },
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(width: paddingSizeNormal);
      },
    );
  }
}
