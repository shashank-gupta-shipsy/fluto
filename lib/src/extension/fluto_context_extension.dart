import 'package:fluto/src/provider/fluto_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

extension FlutoContextExt on BuildContext {
  void showFlutoSheet() =>
      read<FlutoProvider>().setSheetState(PluginSheetState.clicked);

  void showFluto(bool value) {
    read<FlutoProvider>().showFluto(value);
  }

  void setEnabledPlugin(Map<String, bool> value) {
    read<FlutoProvider>().setEnabledPlugin(value);
  }
}
