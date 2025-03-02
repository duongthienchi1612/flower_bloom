import 'package:flutter/material.dart';

import '../../dependencies.dart';
import '../../preference/user_reference.dart';
import '../../utilities/localization_helper.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  BaseStatelessWidget({super.key});
  final localizations = LocalizationHelper.instance;
}

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  final localizations = LocalizationHelper.instance;
  final userRef = injector.get<UserReference>();
  ThemeData get theme => Theme.of(context);
}
