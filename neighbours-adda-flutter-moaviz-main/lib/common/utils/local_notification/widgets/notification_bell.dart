import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/widgets/circular_svg_button_3d_widget.dart';
import 'package:snap_local/common/utils/local_notification/logic/notification_counter/notification_counter_cubit.dart';
import 'package:snap_local/common/utils/local_notification/screen/local_notification_screen.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCounterCubit>().fetchNotificationCount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCounterCubit, NotificationCounterState>(
      builder: (context, state) {
        final count = state.notificationCount;
        final moreThan99 = count > 9;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Badge(
            label: Text("${moreThan99 ? '9+' : count}"),
            backgroundColor: const Color(0xffe2037f),
            isLabelVisible: count > 0,
            offset: Offset(moreThan99 ? -5 : 0, -5),
            child: CircularSvgButton3D(
              svgImage: SVGAssetsImages.bell,
              height: 26,
              onTap: () {
                GoRouter.of(context)
                    .pushNamed(LocalNotificationViewScreen.routeName);
              },
            ),
          ),
        );
      },
    );
  }
}
