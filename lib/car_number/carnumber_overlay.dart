import 'package:car_number_view/car_number/carnumber_keyboard.dart';
import 'package:flutter/material.dart';


///悬浮框键盘
class CarNumberViewOverlay{

  static CarNumberViewOverlay? _instance;

  static CarNumberViewOverlay getInstance(){
    _instance ??= CarNumberViewOverlay();
    return _instance!;
  }

  /// 键盘悬浮窗口
  OverlayEntry? _keyboardOverlay;
  /// 键盘可见状态
  bool _isKeyboardShowing = false;


  /// 显示键盘
  void showKeyboard(BuildContext context , CarNumberChanged carNumberChanged) {
    if (_keyboardOverlay != null) {
      _keyboardOverlay!.remove();
    }
    _keyboardOverlay = OverlayEntry(
      builder: (context) {
        return Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Material(
              child: CarNumberKeyboard('',carNumberChanged)),
        );
      },
    );
    Overlay.of(context)!.insert(_keyboardOverlay!);
    if (!_isKeyboardShowing) {
      _isKeyboardShowing = true;
    }
  }

  /// 隐藏键盘
  void hideKeyboard() {
    print("隐藏键盘");
    _isKeyboardShowing = false;
    if (_keyboardOverlay != null) {
      _keyboardOverlay!.remove();
      _keyboardOverlay = null;
    }
  }

  /// 键盘是否可见
  bool isKeyboardShowing() {
    return _keyboardOverlay != null && _isKeyboardShowing;
  }

}