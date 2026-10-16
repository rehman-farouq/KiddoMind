// ignore_for_file: constant_identifier_names
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConstantDimensions {
  static double get heightExtraSmall => 6.h;
  static double get heightSmall => 10.h;
  static double get heightSmall_Medium => 16.h;
  static double get heightMedium => 20.h;
  static double get heightMedium_Large => 28.h;
  static double get heightLarge => 30.h;
  static double get heightExtraLarge => 50.h;

  static double get widthExtraSmall => 6.w;
  static double get widthSmall => 10.w;
  static double get widthSmall_Medium => 16.w;
  static double get widthMedium => 20.w;
  static double get widthMedium_Large => 28.w;
  static double get widthLarge => 30.w;
  static double get widthExtraLarge => 50.w;

  static double get heightSmallImage => 325.h;
  static double get heightBigImage => 350.h;

  static const List<double> exceptions = [135, 375, 5];
}
