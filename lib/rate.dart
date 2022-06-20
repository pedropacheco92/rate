library rate;

import 'package:flutter/material.dart';

typedef IconBuilder = Icon Function(double value, int index);

class Rate extends StatefulWidget {
  /// Allows half a start to be selectable, like 2.5 stars. Defaults to `false`
  final bool allowHalf;

  /// Allows clearing if clicked in the same points. Defaults to `true`
  final bool allowClear;

  /// If read only, click is blocked
  final bool readOnly;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon
  final Color color;

  /// Initial value, defaults to `0`
  final double initialValue;

  /// Function called whenever the rating changes
  final void Function(double value)? onChange;

  /// Custom icon builder, in case you need something more customizable
  final IconBuilder? iconBuilder;

  const Rate({
    Key? key,
    this.allowHalf = false,
    this.allowClear = true,
    this.readOnly = false,
    this.iconSize = 24,
    this.color = Colors.yellow,
    this.initialValue = 0.0,
    this.onChange,
    this.iconBuilder,
  }) : super(key: key); // coverage:ignore-line

  @override
  State<Rate> createState() => _RateState();
}

class _RateState extends State<Rate> {
  double _value = 0;
  double? _hoverValue;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _valueChangeAction(double value) {
    final newValue = widget.allowClear && _value == value ? 0.0 : value;

    if (mounted) {
      setState(() => _value = newValue);
    }

    widget.onChange?.call(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStar(0),
        _buildStar(1),
        _buildStar(2),
        _buildStar(3),
        _buildStar(4),
      ],
    );
  }

  Widget _buildStar(int index) {
    var icon =
        widget.iconBuilder?.call(_value, index) ?? _defaultIconBuilder(index);

    final iconSize = icon.size ?? widget.iconSize;

    return GestureDetector(
      key: Key('star_rate_$index'),
      onTapDown: widget.readOnly
          ? null
          : (details) {
              if (details.localPosition.dx < ((iconSize / 2) + 1) &&
                  widget.allowHalf) {
                _valueChangeAction(index + 0.5);
              } else {
                _valueChangeAction(index + 1);
              }
            },
      child: MouseRegion(
        cursor: widget.readOnly ? MouseCursor.defer : SystemMouseCursors.click,
        onHover: widget.readOnly
            ? null
            : (event) {
                if (event.localPosition.dx < ((iconSize / 2) + 1) &&
                    widget.allowHalf) {
                  setState(() => _hoverValue = index + 0.5);
                } else {
                  setState(() => _hoverValue = index + 1);
                }
              },
        onExit: widget.readOnly
            ? null
            : (_) {
                setState(() {
                  _hoverValue = null;
                });
              },
        child: icon,
      ),
    );
  }

  Icon _defaultIconBuilder(int index) {
    var icon = (_hoverValue ?? _value) > index.toDouble()
        ? Icons.star
        : Icons.star_border;

    if (widget.allowHalf && (_hoverValue ?? _value) == (index + 0.5)) {
      icon = Icons.star_half;
    }

    return Icon(icon, size: widget.iconSize, color: widget.color);
  }
}
