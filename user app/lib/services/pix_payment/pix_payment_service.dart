import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../component/cached_image_widget.dart';
import '../../component/loader_widget.dart';

class PixPayDialog extends StatefulWidget {
  final String reference;
  final int bookingId;
  final num amount;
  final Function(Map<String, dynamic>) onComplete;

  const PixPayDialog({
    super.key,
    required this.onComplete,
    required this.reference,
    required this.bookingId,
    required this.amount,
  });

  @override
  State<PixPayDialog> createState() => _PixPayDialogState();
}

class _PixPayDialogState extends State<PixPayDialog> {
  bool isTxnInProgress = false;
  bool isSuccess = false;
  bool isFailToGenerateReq = false;
  String responseCode = "";

  var query;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  /// As informações solicitadas a seguir estão disponíveis no seu PSP ou instituição financeira.
  PixFlutter pixFlutter = PixFlutter(
      api: Api(
          baseUrl: 'https://api.hm.bb.com.br/pix/v1',
          authUrl: 'https://oauth.hm.bb.com.br/oauth/token',
          certificate:
              'Basic ZXlKcFpDSTZJbUU1TW1Jek0yWXRNVGMxTmkwMElpd2lZMjlrYVdkdlVIVmliR2xqWVdSdmNpSTZNQ3dpWTI5a2FXZHZVMjltZEhkaGNtVWlPakUzTURjMUxDSnpaWEYxWlc1amFXRnNTVzV6ZEdGc1lXTmhieUk2TVgwOmV5SnBaQ0k2SWpSa09XUTBPREl0TlRVNU5DMDBaVE5sTFRnd01UY3RZbVZsT1RrME5EWmxObUpsWkROaU9HTXdOV1F0SWl3aVkyOWthV2R2VUhWaWJHbGpZV1J2Y2lJNk1Dd2lZMjlrYVdkdlUyOW1kSGRoY21VaU9qRTNNRGMxTENKelpYRjFaVzVqYVdGc1NXNXpkR0ZzWVdOaGJ5STZNU3dpYzJWeGRXVnVZMmxoYkVOeVpXUmxibU5wWVd3aU9qRXNJbUZ0WW1sbGJuUmxJam9pYUc5dGIyeHZaMkZqWVc4aUxDSnBZWFFpT2pFMk1qTTFNRGt4TWpJeE16Tjk=',
          appKey: 'd27b377903ffabc01368e17d80050c56b931a5bf',
          permissions: [PixPermissions.cobRead, PixPermissions.cobWrite, PixPermissions.pixRead, PixPermissions.pixWrite],
          // Lista das permissoes, use PixPermissions,
          isBancoDoBrasil: true // Use true se estiver usando API do BB,
          // Se voce estiver usando um certificado P12, utilize desta forma:
          // certificatePath:
          // e inclua o destino para o arquivo ;)
          ),

      // Essas informações a seguir somente são necessárias se você deseja utilizar o QR Code Estático
      payload: Payload(
          pixKey: 'SUA_CHAVE_PIX',

          /// Há um erro no API que impede o uso de descrição, ela não será inserida. Assim que o bug for consertado, o código voltará ao funcionamento completo.
          description: 'DESCRIÇÃO_DA_COMPRA',
          merchantName: 'MERCHANT_NAME',
          merchantCity: 'CITY_NAME',
          txid: 'TXID',
          // Até 25 caracteres para o QR Code estático
          amount: 'AMOUNT'));

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: context.width(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isFailToGenerateReq
                  ? Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                          child: const Icon(Icons.close_sharp, color: Colors.white),
                        ),
                        10.height,
                        Text(language.somethingWentWrong, style: boldTextStyle()),
                      ],
                    ).paddingAll(16)
                  : isSuccess
                      ? Column(
                          children: [
                            CachedImageWidget(url: ic_verified, height: 60),
                            10.height,
                            Text(language.paymentSuccess, style: boldTextStyle()),
                            16.height,
                            Text(language.redirectingToBookings, textAlign: TextAlign.center, style: secondaryTextStyle()),
                          ],
                        ).paddingAll(16)
                      : isTxnInProgress
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 255,
                                  width: 255,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black, width: 5),
                                  ),
                                  child: query != null
                                      ? QrImageView(
                                          data: query,
                                          version: QrVersions.auto,
                                          size: 250.0,
                                        )
                                      : const Center(
                                          child: Text(
                                            'Crie uma compra para que o QR apareça aqui',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        ),
                                ),
                              ),
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 255,
                                  width: 255,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black, width: 5),
                                  ),
                                  child: query != null
                                      ? QrImageView(
                                          data: query,
                                          version: QrVersions.auto,
                                          size: 250.0,
                                        )
                                      : const Center(
                                          child: Text(
                                            'Crie uma compra para que o QR apareça aqui',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        ),
                                ),
                              ),
                            )
            ],
          ),
        ),
        Observer(
          builder: (context) => LoaderWidget().withSize(height: 80, width: 80).visible(appStore.isLoading && !isTxnInProgress),
        )
      ],
    );
  }

  void _handleClick() async {
    var request = {
      "calendario": {"expiracao": "36000"},
      "devedor": {"cpf": "12345678909", "nome": "Francisco da Silva"},
      "valor": {"original": "130.44"},
      "chave": "7f6844d0-de89-47e5-9ef7-e0a35a681615",
      "solicitacaoPagador": "Cobrança dos serviços prestados."
    };

    query = await pixFlutter.createCobTxid(txid: "dgkjsdhgkjshddgsdggjjuliano", request: request);

    var payloadDinamico = PixFlutter(
        payload: Payload(
      merchantName: "A",
      merchantCity: "BRASILIA",
      txid: "***",
      url: "qrcodepix-h.bb.com.br/pix/v2/a1bfb8af-3485-4509-8b75-bfc6b7749de9",
      isUniquePayment: true,
    ));

    query = payloadDinamico.getQRCode();
  }
}
