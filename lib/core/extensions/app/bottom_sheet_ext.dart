import 'package:flutter/material.dart';

extension BottomSheetX on BuildContext {
  Future<T?> presentSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }
}



