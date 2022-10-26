part of easy_refresh_water_drop;
/// 自定义底部
class CustomFooter extends Footer {
  final Key? key;
  CustomFooter({
    this.key,
    bool clamping = false,
    double triggerOffset = 60,
    IndicatorPosition position = IndicatorPosition.above,
    Duration processedDuration = Duration.zero,
    SpringDescription? spring,
    SpringBuilder? readySpringBuilder,
    bool springRebound = false,
    FrictionFactor? frictionFactor,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool hapticFeedback = false,
  }) : super(
          triggerOffset: triggerOffset,
          clamping: clamping,
          processedDuration: processedDuration,
          spring: spring,
          readySpringBuilder: readySpringBuilder,
          springRebound: springRebound,
          frictionFactor: frictionFactor,
          safeArea: false,
          infiniteOffset: infiniteOffset,
          hitOver: hitOver,
          infiniteHitOver: infiniteHitOver,
          position: position,
          hapticFeedback: hapticFeedback,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    assert(state.axis == Axis.vertical,
        'WaterDropFooter does not support horizontal scrolling.');
    return _WaterDropIndicator(
      key: key,
      state: state,
      reverse: state.reverse,
    );
  }
}
