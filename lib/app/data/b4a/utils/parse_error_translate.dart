import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseErrorTranslate {
  static String translate(ParseError parseError) {
    final Map<int, String> appCodes = {
      //1 - Successful request, but no results found - No Results
      //101 - Invalid username/password. - ObjectNotFound
      //101 - Your account is locked due to multiple failed login attempts. Please try again after 5 minute(s) - ObjectNotFound

      101: 'Email ou senha inválidos ou não cadastrados.',
      202: 'Já existe uma conta para este email.',
      205: 'Veja seu email para validar seu cadastro.',
      // 209 - Invalid session token - InvalidSessionToken
      //  111 - schema mismatch for Evolution.event; expected Pointer<Event> but got String - IncorrectType
    };
    return appCodes[parseError.code] ?? 'Sem tradução';
  }
}

/*
class ParseErrorTranslate {
  final ParseError parseError;
  ParseErrorTranslate(
    this.parseError,
  ) {
    decode();
  }
  String code = '';
  String translated = '';
  decode() {
    log('+++ +++ +++', name: 'ParseErrorCodes');
    log('${parseError.code} - ${parseError.message} - ${parseError.type}',
        name: 'ParseErrorCodes');
    log('--- --- ---', name: 'ParseErrorCodes');
    // if (_appCodes.containsKey(parseError.code)) {
    //   code = 'Parse Error: ${parseError.code}';
    //   // translated = _appCodes[parseError.code]!;
    //   // translated = '${_appCodes[parseError.code]!} [${parseError.translated}]';
    //   translated =
    //       '${_appCodes[parseError.code]} [${parseError.code}: ${parseError.translated}]';
    // } else {
    //   code = 'Parse Error: ${parseError.code}';
    //   translated = parseError.translated;
    // }
    String translate = 'Sem tradução';
    if (_appCodes.containsKey(parseError.code)) {
      translate = _appCodes[parseError.code] ?? 'Sem tradução';
    }
    code = 'Parse Error: ${parseError.code}';
    translated = translate;
    // translated = '$translate [${parseError.code}: ${parseError.translated}]';
  }

  final Map<int, String> _appCodes = {
    //1 - Successful request, but no results found - No Results
    //101 - Invalid username/password. - ObjectNotFound
    //101 - Your account is locked due to multiple failed login attempts. Please try again after 5 minute(s) - ObjectNotFound

    101: 'Email ou senha inválidos ou não cadastrados.',
    202: 'Já existe uma conta para este email.',
    205: 'Veja seu email para validar seu cadastro.',
    // 209 - Invalid session token - InvalidSessionToken
    //  111 - schema mismatch for Evolution.event; expected Pointer<Event> but got String - IncorrectType
  };
}
*/