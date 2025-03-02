
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationHelper {
  static AppLocalizations? _localizations;

  static void init(AppLocalizations localizations) {
    _localizations = localizations;
  }

  static AppLocalizations get instance {
    if (_localizations == null) {
      throw Exception('LocalizationHelper chưa được khởi tạo!');
    }
    return _localizations!;
  }
}
