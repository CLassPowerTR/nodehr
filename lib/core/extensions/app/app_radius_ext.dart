import 'package:flutter/widgets.dart';
import '../../constants/app_radius.dart';

extension RadiusX on Widget {
  Widget clipR12() => ClipRRect(borderRadius: AppRadius.r12, child: this);
}



