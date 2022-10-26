part of easy_refresh_water_drop;

class _WaterDropIndicator extends StatefulWidget {
  const _WaterDropIndicator({
    Key? key,
    required this.state,
    required this.reverse,
  }) : super(key: key);

  final IndicatorState state;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  @override
  State<_WaterDropIndicator> createState() => _WaterDropIndicatorState();
}

class _WaterDropIndicatorState extends State<_WaterDropIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
