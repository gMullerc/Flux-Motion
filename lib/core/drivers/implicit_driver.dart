import '../drivers/motion_driver.dart';
import '../effects/motion_effect.dart';

/// Marker for effects that drive animation inside [MotionRender] (implicit).
abstract class IntrinsicMotionEffect extends MotionEffect {
  @override
  MotionDriver get preferredDriver => MotionDriver.intrinsic;
}
