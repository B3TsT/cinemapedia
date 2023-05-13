import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';
import 'src/app.dart';
import 'src/config/constants/environment.dart';

Future<void> main() async {
  await Environment.loadFileName;

  // *Certificado para dispositivos android 7 o inferiores que no cuentan con SSL
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isAndroid) {
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}
