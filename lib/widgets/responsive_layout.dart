import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/arg_cubit.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  final double breakpoint;

  const ResponsiveLayout({
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
    this.breakpoint = 800,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return BlocProvider(
      create: (_) => ArgCubit(
          args), // Pass the push notification arguments to the ArgCubit
      child: LayoutBuilder(
        builder: (_, constraints) {
          return constraints.maxWidth > breakpoint
              ? webScreenLayout
              : mobileScreenLayout;
        },
      ),
    );
  }
}

// Extension to easily check device type
extension DeviceTypeExtension on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 800;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= 800 &&
      MediaQuery.of(this).size.width < 1200;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;

  double get devicePadding {
    if (isDesktop) return 32.0;
    if (isTablet) return 24.0;
    return 16.0;
  }
}
