part of easy_refresh_water_drop;

class _CustomFooterIndicator extends StatefulWidget {
  const _CustomFooterIndicator(
      {Key? key,
      required this.state,
      required this.reverse,
      this.foregroundColor,
      this.userWaterDrop = true,
      this.backgroundColor,
      this.emptyWidget,
      this.refreshCompleteText = "刷新完成"})
      : super(key: key);

  final IndicatorState state;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  /// Indicator foreground color.
  final Color? foregroundColor;

  /// Use WaterDrop style.
  final bool userWaterDrop;

  /// WaterDrop background color.
  final Color? backgroundColor;

  /// Empty widget.
  /// When result is [IndicatorResult.noMore].
  final Widget? emptyWidget;

  final String refreshCompleteText;

  @override
  State<_CustomFooterIndicator> createState() => _CustomFooterIndicatorState();
}

class _CustomFooterIndicatorState extends State<_CustomFooterIndicator>
    with SingleTickerProviderStateMixin {
  Axis get _axis => widget.state.axis;

  IndicatorMode get _mode => widget.state.mode;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  // double get _radius => _useWaterDrop
  //     ? _kDefaultWaterDropCupertinoIndicatorRadius
  //     : _kDefaultCupertinoIndicatorRadius;

  late AnimationController _waterDropHiddenController;

  bool get _useWaterDrop =>
      widget.userWaterDrop && widget.state.indicator.infiniteOffset == null;

  @override
  void initState() {
    super.initState();
    _waterDropHiddenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    widget.state.notifier.addModeChangeListener(_onModeChange);
  }

  @override
  void dispose() {
    widget.state.notifier.removeModeChangeListener(_onModeChange);
    _waterDropHiddenController.dispose();
    super.dispose();
  }

  /// Mode change listener.
  void _onModeChange(IndicatorMode mode, double offset) {
    if (mode == IndicatorMode.ready) {
      if (!_waterDropHiddenController.isAnimating) {
        _waterDropHiddenController.forward(from: 0);
      }
    }
  }

  Widget _buildIndicator() {
    final scale = (_offset / _actualTriggerOffset).clamp(0.01, 0.99);
    Widget indicator;
    switch (_mode) {
      case IndicatorMode.drag:
      case IndicatorMode.armed:
        const Curve opacityCurve = Interval(
          0.0,
          0.8,
          curve: Curves.easeInOut,
        );
        indicator = Opacity(
          key: const ValueKey('indicator'),
          opacity: opacityCurve.transform(scale),
          child: Icon(
            Icons.autorenew,
            // size: _radius,
            color: widget.foregroundColor,
          ),
        );
        break;
      case IndicatorMode.ready:
      case IndicatorMode.processing:
      case IndicatorMode.processed:
        indicator = SizedBox(
            width: 20.0,
            height: 20.0,
            child: defaultTargetPlatform == TargetPlatform.iOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(strokeWidth: 2.0));

        break;
      case IndicatorMode.done:
        indicator = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.done,
              color: Colors.grey,
            ),
            Container(
              width: 15.0,
            ),
            Text(
              widget.refreshCompleteText,
              style: TextStyle(color: Colors.grey),
            )
          ],
        );
        break;
      default:
        indicator = const SizedBox(
          key: ValueKey('indicator'),
        );
        break;
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 100),
      child: widget.state.result == IndicatorResult.noMore
          ? widget.emptyWidget != null
              ? SizedBox(
                  key: const ValueKey('noMore'),
                  child: widget.emptyWidget!,
                )
              : Icon(
                  CupertinoIcons.archivebox,
                  key: const ValueKey('noMore'),
                  color: widget.foregroundColor,
                )
          : indicator,
    );
  }

  Widget _buildWaterDrop() {
    Widget waterDropWidget = CustomPaint(
      painter: _WaterDropPainter(
        axis: _axis,
        offset: _offset,
        actualTriggerOffset: _actualTriggerOffset,
        color: widget.backgroundColor ?? Theme.of(context).splashColor,
      ),
    );
    return AnimatedBuilder(
      animation: _waterDropHiddenController,
      builder: (context, _) {
        double opacity = 1;
        if (_mode == IndicatorMode.drag) {
          final scale = (_offset / _actualTriggerOffset).clamp(0.0, 1.0);
          const Curve opacityCurve = Interval(
            0.0,
            0.8,
            curve: Curves.easeInOut,
          );
          opacity = opacityCurve.transform(scale);
        } else if (_mode == IndicatorMode.armed) {
          opacity = 1;
        } else if (_mode == IndicatorMode.ready ||
            _mode == IndicatorMode.processing ||
            _mode == IndicatorMode.processed ||
            _mode == IndicatorMode.done) {
          opacity = 1 - _waterDropHiddenController.value;
        } else {
          opacity = 0;
        }
        return Opacity(
          opacity: opacity,
          child: waterDropWidget,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double offset = _offset;
    if (widget.state.indicator.infiniteOffset != null &&
        widget.state.indicator.position == IndicatorPosition.locator &&
        (_mode != IndicatorMode.inactive ||
            widget.state.result == IndicatorResult.noMore)) {
      offset = _actualTriggerOffset;
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: _axis == Axis.vertical ? offset : double.infinity,
          width: _axis == Axis.vertical ? double.infinity : offset,
        ),
        // WaterDrop.
        // if (_useWaterDrop)
        //   Positioned(
        //     top: 0,
        //     left: 0,
        //     right: _axis == Axis.vertical ? 0 : null,
        //     bottom: _axis == Axis.vertical ? null : 0,
        //     child: SizedBox(
        //       height: _axis == Axis.vertical ? _offset : double.infinity,
        //       width: _axis == Axis.vertical ? double.infinity : _offset,
        //       child: _buildWaterDrop(),
        //     ),
        //   ),
        // Indicator.
        Positioned(
          top: 0,
          left: 0,
          right: _axis == Axis.vertical ? 0 : null,
          bottom: _axis == Axis.vertical ? null : 0,
          child: Container(
            alignment: Alignment.center,
            height:
                _axis == Axis.vertical ? _actualTriggerOffset : double.infinity,
            width:
                _axis == Axis.vertical ? double.infinity : _actualTriggerOffset,
            child: _buildIndicator(),
          ),
        ),
      ],
    );
  }
}
