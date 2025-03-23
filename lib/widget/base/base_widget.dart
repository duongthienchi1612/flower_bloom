import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  const BaseStatelessWidget({super.key});

  AppLocalizations appLocalizations(BuildContext context) => AppLocalizations.of(context)!;
}

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  ThemeData get theme => Theme.of(context);

  AppLocalizations get appLocalizations => AppLocalizations.of(context)!;
}
