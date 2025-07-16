import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({
    super.key,
    required this.headerBuilder,
    required this.bodyBuilder,
    this.headerFlex = 1,
    this.bodyFlex = 1,
  });

  final Widget Function(BoxConstraints) headerBuilder;
  final Widget Function(BoxConstraints) bodyBuilder;
  final int headerFlex;
  final int bodyFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final finalHeader = Flexible(
          flex: headerFlex,
          child: headerBuilder(constraints),
        );

        final finalBody = Flexible(
          flex: bodyFlex,
          child: bodyBuilder(constraints),
        );
        return Padding(
          padding: MediaQuery.of(context).padding,
          child: constraints.maxWidth > 500
              ? Row(children: [finalHeader, finalBody])
              : Column(children: [finalHeader, finalBody]),
        );
      },
    );
  }
}
