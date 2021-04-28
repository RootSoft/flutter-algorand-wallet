import 'package:clipboard/clipboard.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/list_assets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ListAssetPage extends StatelessWidget {
  static String routeName = '/assets';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ListAssetBloc>().state;

    return Container(
      padding: EdgeInsets.all(paddingSizeDefault),
      child: Column(
        children: [
          /// Show search bar
          TextFormField(
            autovalidateMode: AutovalidateMode.always,
            decoration: const InputDecoration(
              icon: Icon(FeatherIcons.search),
              hintText: 'Search for assets',
              focusColor: Palette.accentColor,
              hoverColor: Palette.accentColor,
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

                    final success = await Fluttertoast.showToast(
                      msg: "Asset id copied to clipboard",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16.0,
                    );
                  },
                  child: Text(
                    '${asset.params.name} (${asset.index})',
                    style: boldTextStyle.copyWith(fontSize: fontSizeMedium),
                  ),
                ),
              ),
              RoundedButton(
                text: 'Opt in',
                onPressed: () {},
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
