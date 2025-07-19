import 'package:flutter/material.dart';
import 'package:github_profile_viewer/utils/constants.dart';

class ShimmerCircleAvatar extends StatelessWidget {
  const ShimmerCircleAvatar({super.key, required this.radius});

  final double radius;

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: radius * 2,
      height: radius * 2,
      borderRadius: radius,
    );
  }
}

class ShimmerLine extends StatelessWidget {
  const ShimmerLine({
    super.key,
    this.width = double.infinity,
    this.height = Dimens.lineHeightSmall,
    this.borderRadius,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius ?? height / 2,
    );
  }
}


class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = Dimens.lineHeightXLarge,
    this.borderRadius = Dimens.borderRadiusMedium,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(vertical: Dimens.paddingXXSmall),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    super.key,
    this.linearGradient = const LinearGradient(
      colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
      stops: [0.1, 0.5, 0.9],
      begin: Alignment(0, -1),
      end: Alignment(0, 1),
      tileMode: TileMode.clamp,
    ),
    this.child,
    this.period = const Duration(seconds: 2),
  });

  final LinearGradient linearGradient;
  final Widget? child;
  final Duration period;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  Gradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
    transform: _SlidingGradientTransform(
      slidePercent: _shimmerController.value,
    ),
  );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Listenable get shimmerChanges => _shimmerController;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: widget.period);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    // required this.isLoading,
    required this.child,
  });

  // final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (!widget.isLoading) {
    //   return widget.child;
    // }

    // Collect ancestor shimmer information.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      // The ancestor Shimmer widget isn't laid
      // out yet. Return an empty box.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = context.findRenderObject() != null ? shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    ): Offset(0, 0);

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues( 0.0,(bounds.height * slidePercent) - 150, 0.0);
  }
}
