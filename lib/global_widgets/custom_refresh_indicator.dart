import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class AdvancedCustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color indicatorColor;

  const AdvancedCustomRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.indicatorColor = const Color(0xFF316984),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
            return AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, _) {
                final double value = controller.value;

                if (controller.isLoading) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Transform.translate(
                        offset: Offset(0, 100 * value),
                        child: child,
                      ),

                      Positioned(
                        top: 40.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(indicatorColor),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  );
                }

                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, 100 * value),
                      child: child,
                    ),

                    Positioned(
                      top: 40.0,
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: value.clamp(0.0, 1.0),
                          child: Transform.rotate(
                            angle: value * 2 * 3.1415,
                            child: Icon(
                              Icons.refresh,
                              color: indicatorColor,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
      child: child,
    );
  }
}
