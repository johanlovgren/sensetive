import 'dart:convert';
import 'package:flutter/material.dart';

class DecodedJwt {
  String _uid;
  String _iat;
  DateTime _exp;
  String _access;
  bool _valid;
  String get uid => _uid;
  String get iat => _iat;
  DateTime get ext => _exp;
  String get access => _access;
  bool get valid => _valid;

  DecodedJwt({@required String jwt}) {
    try {
      Map<String, dynamic> payload = _decode(jwt);
      _uid = payload['sub'];
      _iat = payload['iat'];
      _exp = DateTime.parse(payload['exp']);
      _access = payload['Access'];
      _valid = _exp.isAfter(DateTime.now());
    } catch(e) {
      _valid = false;
    }
  }

  Map<String, dynamic> _decode(String jwt) {
    List<String> splitJwt = jwt.split('.');
    if (splitJwt.length != 3)
      throw(Exception('Not valid JWT'));
    String data = splitJwt[1];
    while (data.length % 4 != 0)
      data += '=';
    return json.decode(utf8.decode(base64Url.decode(data)));
  }
}