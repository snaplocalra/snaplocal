import 'package:fast_rsa/fast_rsa.dart' as fast_rsa;
import 'package:flutter/services.dart';

class RSAEncryption {
  String keysPath = "assets/keys/rsa_keys";
  late final String publicKeyFile = "$keysPath/public.pem";
  late final String privateKeyFile = "$keysPath/private.pem";

  //Encrypts the data using the public key
  Future<String> encrypt(String payload) async {
  //create the public key as string from the file
    String publicKey = await rootBundle.loadString(publicKeyFile);

    return await fast_rsa.RSA.encryptOAEP(
      payload,
      '',
      fast_rsa.Hash.SHA256,
      publicKey,
    );
  }

  //Decrypts the data using the private key
  Future<String> decrypt(String encryptedPayload) async {
    //create the private key as string from the file
    String privateKey = await rootBundle.loadString(privateKeyFile);

    return await fast_rsa.RSA.decryptOAEP(
      encryptedPayload,
      '',
      fast_rsa.Hash.SHA256,
      privateKey,
    );
  }
}
