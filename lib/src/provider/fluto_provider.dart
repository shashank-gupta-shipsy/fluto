import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';

class FlutoProvider extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey;
  BuildContext? get context => navigatorKey.currentContext;
  PluginSheetState _sheetState = PluginSheetState.closed;
  bool _show;
  bool get show => _show;
  void showFluto(bool show) {
    _show = show;
    notifyListeners();
  }

  Map<String, bool> _enabledPlugin = {};
  Map<String, bool> get enabledPlugin => _enabledPlugin;
  void setEnabledPlugin(Map<String, bool> value) {
    _enabledPlugin = {..._enabledPlugin, ...value};
    notifyListeners();
  }

  FlutoProvider({
    required this.navigatorKey,
    required bool show,
    required Map<String, bool> enabledPlugin,
  })  : _show = show,
        _enabledPlugin = enabledPlugin;

  PluginSheetState get sheetState => _sheetState;

  bool get showDraggingButton => _showDraggingButton();

  bool _showDraggingButton() {
    if (_show) {
      return _sheetState == PluginSheetState.closed;
    }
    return false;
  }

  bool get showButtonSheet => _sheetState == PluginSheetState.clicked;

  setSheetState(PluginSheetState value) {
    _sheetState = value;
    if (_sheetState != PluginSheetState.clickedAndOpened) {
      notifyListeners();
    }
  }

  final DragController dragController = DragController();
}

enum PluginSheetState { clicked, clickedAndOpened, closed }
