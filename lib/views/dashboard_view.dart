import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late ServiceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ServiceBloc>();

    _bloc.add(GetServiceHistory(query: 'Main  Workshop'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                // Color.fromARGB(255, 255, 231, 231),
                Color.fromARGB(255, 238, 209, 209),
                Color.fromARGB(255, 231, 201, 201),
                Color.fromARGB(255, 231, 200, 200)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.01, 0.35, 1]),
        ),
        child: Column(
          children: [JobCardPage()],
        ),
      ),
    ));
  }
}

class SliverAppBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 280,
      child: ClipPath(
          clipper: BackgroundWaveClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 145, 19, 19),
                Color.fromARGB(255, 201, 94, 94)
              ],
            )),
          )),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print('height ${size.height} width ${size.width}');
    Path path = Path();

    const minSize = 50.0;

    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();

    path.lineTo(0, size.height - p1Diff);

    final controlPoint1 = Offset(size.width * 0.2, size.height);
    final controlPoint2 =
        Offset(size.width * 0.8, minSize + (minSize - size.height * 0.75) * 2);

    print('control point 1 $controlPoint1 control point 2 $controlPoint2');
    final endPoint = Offset(size.width, minSize);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}

class JobCardPage extends StatelessWidget {
  const JobCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.96,
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: SliverAppBar(),
                // Set this param so that it won't go off the screen when scrolling
                pinned: true,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Skeletonizer(
                  enableSwitchAnimation: true,
                  enabled: state.status != ServiceStatus.success,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: size.height * 0.05,
                        width: size.width * 0.3,
                        child: Text(
                          state.status == ServiceStatus.success
                              ? state.jobCards![index].jobCardNo!
                              : 'JC-MAD-633',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: size.height * 0.05,
                        width: size.width * 0.3,
                        child: Text(
                          state.status == ServiceStatus.success
                              ? state.jobCards![index].registrationNo!
                              : 'TS09ED7884',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: size.height * 0.05,
                          width: size.width * 0.4,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              onMenuStateChange: (isOpen) {},
                              isExpanded: true,
                              items: ['I', 'N', 'CL', 'C']
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                  .toList(),
                              value: state.status == ServiceStatus.success
                                  ? state.jobCards![index].status!
                                  : 'I',
                              onChanged: (String? value) {
                                context
                                    .read<ServiceBloc>()
                                    .state
                                    .jobCards![index]
                                    .status = value;
                                context
                                    .read<ServiceBloc>()
                                    .add(JobCardStatusUpdated());
                              },
                              buttonStyleData: ButtonStyleData(
                                height: size.height * 0.04,
                                width: size.width * 0.5,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  color: Colors.white,
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(!false
                                    ? Icons.keyboard_arrow_down_rounded
                                    : Icons.keyboard_arrow_up_rounded),
                                iconSize: 14,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.black,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: size.height * 0.3,
                                width: size.width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 30,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              },
                      childCount: state.status != ServiceStatus.success
                          ? 50
                          : state.jobCards!.length)),
            ],
          );
        },
      ),
    );
  }
}
