import 'package:flutter/material.dart';
import 'package:light_house_web_demo_app/screens/home_screen.dart';
import 'package:light_house_web_demo_app/screens/widgets/home_screen_widgets.dart';

/// Верстка для главной [HomeScreen] при широком экране
class WideScreenLayout extends StatelessWidget {
  const WideScreenLayout({
    super.key,
    required this.device,
  });

  final Widget device;

  @override
  Widget build(BuildContext context) {
    final mqd = MediaQuery.of(context).copyWith(size: const Size(450, 900));
    return Padding(
      padding: const EdgeInsets.symmetric( vertical: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 2,
            child: AdditionInfo(mqd: mqd),
          ),
          Flexible(
            flex: 3,
            child: _DeviceFrame(mqd: mqd, device: device),
          ),
          Flexible(
            flex: 3,
            child: DemoStand(mqd: mqd),
          ),
        ],
      ),
    );
  }
}

class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({
    required this.mqd,
    required this.device,
  });

  final MediaQueryData mqd;
  final Widget device;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black, width: 12),
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(38.5),
            child: MediaQuery(
              data: mqd,
              child: SizedBox(
                width: mqd.size.width,
                height: mqd.size.height,
                child: device,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
