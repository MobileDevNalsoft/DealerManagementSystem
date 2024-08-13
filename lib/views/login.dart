import 'dart:io';
import 'package:dms/inits/init.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../network_handler_mixin/network_handler.dart';
import 'custom_widgets/loginformfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with ConnectivityMixin {
  // controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // shared preference
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // variable to hold Authentication bloc
  late AuthenticationBloc _authBloc;

  @override
  void initState() {
    super.initState();

    //initiating _authBloc
    _authBloc = context.read<AuthenticationBloc>();

    // setting the default state of the obscure password to true
    _authBloc.state.obscure = true;

    // setting the initial state for authentication
    _authBloc.state.authenticationStatus = AuthenticationStatus.initial;
  }

  @override
  void dispose() {
    //disposing controllers when this page is removed from the stack
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showConfirmationDialog(size: size);
      },
      child: AspectRatio(
        aspectRatio: size.height / size.width,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                String? message;

                switch (state.authenticationStatus) {
                  case AuthenticationStatus.success:
                    message = "Login Successful";
                    sharedPreferences.setBool("isLogged", true);
                    FocusManager.instance.primaryFocus?.unfocus();
                    break;
                  case AuthenticationStatus.invalidCredentials:
                    message = "Invalid Credentials";
                    break;
                  case AuthenticationStatus.failure:
                    message = "Something went wrong. Please try again later";
                  default:
                    message = null;
                }

                if (message != null) {
                  DMSCustomWidgets.DMSFlushbar(size, context,
                      message: message,
                      icon: Icon(
                        message == "Login Successful"
                            ? Icons.check_circle_rounded
                            : Icons.error,
                        color: Colors.white,
                      ));
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black45,
                                Colors.black26,
                                Colors.black45
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.1, 0.5, 1])),
                      child: Stack(children: [
                        if (isMobile)
                          ClipShadowPath(
                            shadow: BoxShadow(
                                blurRadius: 20,
                                blurStyle: BlurStyle.outer,
                                spreadRadius: 25,
                                color: Colors.orange.shade200,
                                offset: const Offset(0, 0)),
                            clipper: ImageClipper(),
                            child: Container(
                              height: size.height * 0.4,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/login.png'),
                                    alignment: Alignment.topCenter,
                                    isAntiAlias: true),
                              ),
                            ),
                          ),
                        if (!isMobile)
                          Container(
                            height: size.height,
                            width: size.width * 0.4,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/login.png'),
                                  alignment: Alignment.center,
                                  isAntiAlias: true),
                            ),
                          ),
                        Positioned(
                          top: size.height * 0.35,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.09,
                                    bottom: size.width * 0.03),
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25),
                                ),
                              ),
                              CustomTextFormField(
                                hintText: 'employee id',
                                controller: _emailController,
                                prefixIcon: const Icon(Icons.person),
                              ),
                              Gap(
                                size.height * 0.02,
                              ),
                              CustomTextFormField(
                                hintText: 'password',
                                controller: _passwordController,
                                prefixIcon: const Icon(Icons.key),
                                obscureText: state.obscure,
                                obscureChar: '*',
                                suffixIcon: IconButton(
                                  iconSize: 20,
                                  onPressed: () => {
                                    context
                                        .read<AuthenticationBloc>()
                                        .add(ObscurePasswordTapped())
                                  },
                                  icon: state.obscure!
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                ),
                              ),
                              Gap(
                                size.height * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  String? message =
                                      (_emailController.text.isEmpty
                                              ? "username cannot be empty"
                                              : null) ??
                                          _passwordValidator(
                                              _passwordController.text);

                                  if (message != null) {
                                    DMSCustomWidgets.DMSFlushbar(
                                      size,
                                      context,
                                      message: message,
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _authBloc.add(LoginButtonPressed(
                                        username: _emailController.text,
                                        password: _passwordController.text));
                                  }
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.08),
                                    height: size.height * 0.05,
                                    width: size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 10,
                                              blurStyle: BlurStyle.outer,
                                              spreadRadius: 0,
                                              color: Colors.orange.shade200,
                                              offset: const Offset(0, 0))
                                        ]),
                                    child: const Text(
                                      textAlign: TextAlign.center,
                                      'log in',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )),
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                    if (state.authenticationStatus ==
                        AuthenticationStatus.loading)
                      Container(
                        color: Colors.white54,
                        child: Center(
                            child: Lottie.asset(
                                'assets/lottie/login_loading.json',
                                height: size.height * 0.4,
                                width: size.width * 0.4)),
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void showConfirmationDialog({required Size size}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.only(top: size.height * 0.01),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: const Text(
                      'Are you sure you want to exit the app ?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(size.height * 0.01),
                  Container(
                    height: size.height * 0.05,
                    margin: EdgeInsets.all(size.height * 0.001),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'no',
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              exit(0);
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'yes',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero);
        });
  }
}

class ImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(size.width * 0.25, size.height - 120,
        size.width * 0.5, size.height - 50);
    path.quadraticBezierTo(
        size.width * 0.75, size.height + 15, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}

String? _passwordValidator(String value) {
  if (value.isEmpty) {
    return "password cannot be empty";
  } else if (value.length < 10) {
    return "password must contain atleast 10 characters";
  }
  return null;
}
