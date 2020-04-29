import 'package:flutter/material.dart';

class PlatformDependentText extends InheritedWidget {
  const PlatformDependentText({
    Key key,
    @required this.object,
    @required Widget child,
  })
      : assert(child != null),
        super(key: key, child: child);

  final dynamic object;

  static PlatformDependentText of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(
        PlatformDependentText) as PlatformDependentText;
  }

  @override
  bool updateShouldNotify(PlatformDependentText old) {
    return object != old.object;
  }
}