import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/buttons/rounded_button.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareAddressScreen extends StatelessWidget {
  static String routeName = '/share/address/:address';

  final String address;

  ShareAddressScreen({required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share QR and Address'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Center(
                child: QrImage(
                  data: address,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              Spacer(),
              RoundedButton(
                text: 'Share QR',
                selected: true,
                onPressed: () async {
                  final data = await QrPainter(
                    data: address,
                    version: QrVersions.auto,
                  ).toImageData(200);

                  if (data == null) return;

                  if (kIsWeb) {
                    await showOkCancelAlertDialog(
                      context: context,
                      title: 'Export QR code',
                      message: 'We can\'t export the QR code for web yet.',
                    );

                    return;
                  }

                  final file = await saveImage(data, 'temp.jpg');
                  Share.shareFiles([file.path],
                      subject: 'Here is my Algorand address');
                },
              ),
              Spacer(),
              _buildAddressBox(context),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressBox(BuildContext context) {
    return InkWell(
      onTap: () async {
        await FlutterClipboard.copy(address);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Address copied to clipboard')));
      },
      child: Container(
        padding: EdgeInsets.all(paddingSizeDefault),
        decoration: BoxDecoration(
          color: Palette.primaryLightColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            Text(
              'Account Address',
              style: boldTextStyle.copyWith(fontSize: fontSizeMedium),
            ),
            VerticalSpacing(of: marginSizeSmall),
            Text(
              address,
              style: regularTextStyle,
              textAlign: TextAlign.center,
            ),
            VerticalSpacing(of: marginSizeSmall),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        FeatherIcons.copy,
                        size: 20,
                        color: Palette.accentColor,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Copy address',
                    style: boldTextStyle.copyWith(
                      color: Palette.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> saveImage(ByteData data, String name) async {
    //retrieve local path for device
    var path = await _localPath; //<-- see below function

    final buffer = data.buffer;
    return new File('$path/$name.png').writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}
