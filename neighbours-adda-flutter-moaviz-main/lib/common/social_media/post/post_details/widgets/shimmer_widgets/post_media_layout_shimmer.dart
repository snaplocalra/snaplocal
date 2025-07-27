import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/widgets/shimmer_widget.dart';

class PostMediaLayoutShimmerBuilder extends StatefulWidget {
  const PostMediaLayoutShimmerBuilder({super.key});

  @override
  State<PostMediaLayoutShimmerBuilder> createState() =>
      _PostMediaLayoutShimmerBuilderState();
}

class _PostMediaLayoutShimmerBuilderState
    extends State<PostMediaLayoutShimmerBuilder> {
  int getRandomLayoutNumber() {
    final random = Random();
    return random.nextInt(6);
  }

  @override
  Widget build(BuildContext context) {
    final mqSize = MediaQuery.sizeOf(context);
    final layoutNumber = getRandomLayoutNumber();
    return Visibility(
      visible: layoutNumber > 1,
      child: SizedBox(
        height: 400,
        width: mqSize.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: layoutNumber == 2
              ? const TwoImageLayoutShimmer()
              : layoutNumber == 3
                  ? const ThreeImageLayoutShimmer()
                  : layoutNumber == 4
                      ? const FourImageLayoutShimmer()
                      : const FiveImageLayoutShimmer(),
        ),
      ),
    );
  }
}

class TwoImageLayoutShimmer extends StatelessWidget {
  const TwoImageLayoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const Column(
          children: [
            Expanded(
              child: ShimmerWidget(
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ShimmerWidget(
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ThreeImageLayoutShimmer extends StatelessWidget {
  const ThreeImageLayoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const ShimmerWidget(
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Expanded(
              child: Column(
                children: [
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: ShimmerWidget(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  )),
                  SizedBox(height: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class FourImageLayoutShimmer extends StatelessWidget {
  const FourImageLayoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class FiveImageLayoutShimmer extends StatelessWidget {
  const FiveImageLayoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return const Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: ShimmerWidget(
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
