import 'package:flutter/material.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/widgets/more_dialog.dart';
import 'package:snap_local/bottom_bar/model/bottom_bar_model.dart';
import 'package:snap_local/bottom_bar/widget/bottom_bar_item_widget.dart';
import 'package:snap_local/utility/constant/assets_images.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

class MoreButton extends StatefulWidget {
  final bool isSelected;
  const MoreButton({
    super.key,
    this.isSelected = false,
  });

  @override
  State<MoreButton> createState() => _MoreButtonState();
}

class _MoreButtonState extends State<MoreButton> with TickerProviderStateMixin {
  final GlobalKey _moreButtonKey = GlobalKey();
  late final AnimationController _dialogAnimationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            //If the user select the more button, then add the below color in the gradient
            if (widget.isSelected) const Color.fromRGBO(220, 6, 131, 1),
            const Color.fromRGBO(0, 25, 104, 1),
            const Color.fromRGBO(0, 25, 104, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ), // Use a single color if not index 2
      ),
      child: RawMaterialButton(
        key: _moreButtonKey,
        onPressed: () {
          //Open the more dialog
          // To open the dialog with animation:
          _dialogAnimationController.forward();
          final RenderBox renderBox =
          _moreButtonKey.currentContext!.findRenderObject() as RenderBox;
          final Offset fabPosition = renderBox.localToGlobal(renderBox.size.bottomCenter(Offset.zero));
          // // showDialog(
          // //   context: context,
          // //   barrierColor: Colors.transparent,
          // //   builder: (context) => GestureDetector(
          // //     onTap: () {
          // //       Navigator.pop(context);
          // //     },
          // //     child: TorchEffectDialog(
          // //       from: fabPosition,
          // //     ),
          // //   ),
          // // ).whenComplete(
          // //       () =>
          // //
          // //   // To close the dialog with animation:
          // //   _dialogAnimationController.reverse(),
          // // );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => TorchEffectDialogDemo()),
          // );


          showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.3),
            builder: (context) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: DialogSlideTransition(
                animationController: _dialogAnimationController,
                child: TorchEffectDialog(from: fabPosition),
              ),
            ),
          ).whenComplete(
            () =>

                // To close the dialog with animation:
                _dialogAnimationController.reverse(),
          );
        },
        shape: const CircleBorder(),
        elevation: 0,
        fillColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: BottomBarItem(
            isCenterButton: true,
            bottomBarModel: BottomBarModel(
              image: SVGAssetsImages.more,
              name: LocaleKeys.more,
            ),
          ),
        ),
      ),
    );
  }
}

class DialogSlideTransition extends AnimatedWidget {
  final AnimationController animationController;
  final Widget child;

  const DialogSlideTransition({super.key, required this.child, required this.animationController})
      : super(listenable: animationController);

  @override
  Widget build(BuildContext context) {
    final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}

// class TorchEffectDialog extends StatelessWidget {
//   final Offset spotlightPosition;
//   final double radius;
//
//   TorchEffectDialog({required this.spotlightPosition, this.radius = 100});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Dim background
//         GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: Container(
//             color: Colors.black.withOpacity(0.7),
//           ),
//         ),
//
//         // Spotlight effect
//         Positioned.fill(
//           child: CustomPaint(
//             painter: SpotlightPainter(spotlightPosition, radius),
//           ),
//         ),
//
//         // Dialog content
//         Center(
//           child: AlertDialog(
//             backgroundColor: Colors.white,
//             title: Text("Torch Effect Dialog"),
//             content: Text("This dialog has a torchlight spotlight."),
//             actions: [
//               TextButton(
//                 child: Text("Close"),
//                 onPressed: () => Navigator.pop(context),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class SpotlightPainter extends CustomPainter {
//   final Offset position;
//   final double radius;
//
//   SpotlightPainter(this.position, this.radius);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = Colors.black.withOpacity(0.7)
//       ..blendMode = BlendMode.dstOut;
//
//     canvas.saveLayer(Offset.zero & size, Paint());
//
//     // Draw full black layer
//     canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black.withOpacity(0.7));
//
//     // Draw transparent spotlight circle
//     canvas.drawCircle(position, radius, paint);
//
//     canvas.restore();
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }


// class TorchEffectDialogDemo extends StatefulWidget {
//   @override
//   _TorchEffectDialogDemoState createState() => _TorchEffectDialogDemoState();
// }
//
// class _TorchEffectDialogDemoState extends State<TorchEffectDialogDemo> {
//   final GlobalKey _moreButtonKey = GlobalKey();
//
//   void _showTorchDialog() {
//     final RenderBox renderBox =
//     _moreButtonKey.currentContext!.findRenderObject() as RenderBox;
//     final Offset buttonOffset = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
//
//     showDialog(
//       context: context,
//       barrierColor: Colors.transparent,
//       builder: (_) => TorchEffectDialog(from: buttonOffset),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background content (example)
//           Center(child: Text("Main Content")),
//
//           // Bottom navigation with More button
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 40),
//               child: GestureDetector(
//                 key: _moreButtonKey,
//                 onTap: _showTorchDialog,
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.blueAccent,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.grid_view, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TorchEffectDialogDemo extends StatefulWidget {
//   @override
//   _TorchEffectDialogDemoState createState() => _TorchEffectDialogDemoState();
// }
//
// class _TorchEffectDialogDemoState extends State<TorchEffectDialogDemo> {
//   final GlobalKey _moreButtonKey = GlobalKey();
//
//   void _showTorchDialog() {
//     final RenderBox renderBox =
//     _moreButtonKey.currentContext!.findRenderObject() as RenderBox;
//     final Offset buttonOffset = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
//
//     showDialog(
//       context: context,
//       barrierColor: Colors.transparent,
//       builder: (_) => TorchEffectDialog(from: buttonOffset),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background content (example)
//           Center(child: Text("Main Content")),
//
//           // Bottom navigation with More button
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 40),
//               child: GestureDetector(
//                 key: _moreButtonKey,
//                 onTap: _showTorchDialog,
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Colors.blueAccent,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(Icons.grid_view, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class TorchEffectDialog extends StatelessWidget {
  final Offset from;

  const TorchEffectDialog({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    // Get screen center (dialog center)
    final screenCenter = MediaQuery.of(context).size.center(Offset.zero);

    // Offset to bottom of dialog (assume dialog height ~220)
    final dialogHeight = 220.0;
    final to = screenCenter.translate(0, dialogHeight / 2);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) {
        return Stack(
          children: [
            // Spotlight background
            Positioned.fill(
              child: CustomPaint(
                painter: TorchBeamPainter(from: from, to: to, progress: progress),
              ),
            ),

            // Dialog (fade in)
            Opacity(
              opacity: progress,
              child: MoreDialogWidget(),
            ),
          ],
        );
      },
    );
  }
}


class TorchBeamPainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final double progress;

  TorchBeamPainter({
    required this.from,
    required this.to,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dark background
    final darkPaint = Paint()
      ..color = Colors.black.withOpacity(0.8 * progress);
    canvas.drawRect(Offset.zero & size, darkPaint);

    // Beam cone from FAB to dialog BOTTOM
    const double dialogWidth = 280;
    final double halfWidth = (dialogWidth / 2) * progress;

    final beamPath = Path()
      ..moveTo(from.dx, from.dy)
      ..lineTo(to.dx - halfWidth, to.dy)
      ..lineTo(to.dx + halfWidth, to.dy)
      ..close();

    canvas.drawPath(
      beamPath,
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.3 * progress),
            Colors.white.withOpacity(0.1 * progress),
            Colors.transparent,
          ],
          stops: [0.0, 0.6, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromPoints(from, to)),
    );

    // Glow at dialog BOTTOM
    final glowRadius = 120 * progress;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: to, radius: glowRadius));

    canvas.drawCircle(to, glowRadius, glowPaint);
  }

  @override
  bool shouldRepaint(covariant TorchBeamPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
