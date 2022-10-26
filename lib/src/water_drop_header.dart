part of easy_refresh_water_drop;

class WaterDropHeader extends Header {
  final Key? key;

  WaterDropHeader({
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
        'WaterDropHeader does not support horizontal scrolling.');
    return _WaterDropIndicator(
      key: key,
      state: state,
      reverse: state.reverse,
      backgroundColor: Colors.black26,
      foregroundColor: Colors.black26,
    );
  }
}
