import 'package:flutter/material.dart';

class PulseButton extends StatefulWidget {
  final double temperatura;
  const PulseButton(this.temperatura, {Key? key}) : super(key: key);

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween(begin: 5.0, end: 80.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.temperatura > 37 && _animationController.isDismissed) {
      _animationController.repeat(reverse: true);
    } else if (widget.temperatura < 37) {
      _animationController.reverse();
    }

    if (widget.temperatura > 43 &&
        _animationController.duration?.inMilliseconds == 600) {
      _animationController.stop();
      _animationController.duration = const Duration(milliseconds: 200);
      _animationController.repeat(reverse: true);
    } else if (widget.temperatura > 37 &&
        widget.temperatura < 47 &&
        _animationController.duration?.inMilliseconds == 200) {
      _animationController.stop();
      _animationController.duration = const Duration(milliseconds: 600);
      _animationController.repeat(reverse: true);
    }

    final color = widget.temperatura > 37.0 ? Colors.red : Colors.blue;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: color),
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: _animation.value > 0 ? 20 : 0,
                  spreadRadius: _animation.value / 2,
                )
              ]),
          child: Center(
            child: Text(
              widget.temperatura.toStringAsPrecision(2),
              style:
                  Theme.of(context).textTheme.headline3?.copyWith(color: color),
            ),
          ),
        );
      },
    );
  }
}
