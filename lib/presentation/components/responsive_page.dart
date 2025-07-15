import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key, required this.header, required this.body});

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: isLandscape
            ? Row(
                children: [
                  Flexible(child: header),
                  Flexible(child: body),
                ],
              )
            : Column(
                children: [
                  Flexible(child: header),
                  Flexible(child: body),
                ],
              ),
      ),
    );
  }
}
