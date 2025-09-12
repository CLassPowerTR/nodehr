import 'package:flutter/widgets.dart';
import '../../constants/app_paddings.dart';

extension PaddingX on Widget {
  Widget padAll16() => Padding(padding: AppPaddings.all16, child: this);
  Widget padH16() => Padding(padding: AppPaddings.h16, child: this);
  Widget padV16() => Padding(padding: AppPaddings.v16, child: this);
}



