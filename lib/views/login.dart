import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../network_handler_mixin/network_handler.dart';
import 'customer_widgets/textformfield.dart';

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
      onPopInvoked: (didPop) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: size.height * 0.03,
              child: AlertDialog(
                backgroundColor: const Color.fromARGB(255, 245, 216, 216),
                contentPadding: EdgeInsets.only(
                    left: size.width * 0.04, top: size.height * 0.02),
                content: const Text('Are you sure you want to exit the app?'),
                actionsPadding: EdgeInsets.zero,
                buttonPadding: EdgeInsets.zero,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false); // Don't exit
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 145, 19, 19)),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      exit(0); // Exit
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 145, 19, 19)),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: SafeArea(
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
                      FocusManager.instance.primaryFocus?.unfocus();
                      sharedPreferences.setBool("isLogged", true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>const DashboardView(),
                        ),
                        (route) => false,
                      );
                      break;
                    case AuthenticationStatus.invalidCredentials:
                      message = "Invalid Credentials";
                      break;
                    case AuthenticationStatus.failure:
                      message = "Some error has occurred";
                    default:
                      message = null;
                  }

                  if (message != null) {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: message == "Login Successful"
                          ? Colors.green
                          : Colors.red,
                      message: message,
                      duration: const Duration(seconds: 2),
                      borderRadius: BorderRadius.circular(12),
                      margin: EdgeInsets.only(
                          top: size.height * 0.01,
                          left: isMobile ? 10 : size.width * 0.8,
                          right: size.width * 0.03),
                    ).show(context);
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/login.png'),
                                alignment: Alignment.topCenter),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 145, 19, 19),
                                  Colors.white,
                                  Color.fromARGB(255, 201, 138, 138)
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomCenter,
                                stops: [0.08, 0.6, 1])),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(size.height * 0.27),
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.08),
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Montserrat',
                                      fontSize: 28),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.08),
                                child: CustomTextFormField(
                                  hintText: 'employee id',
                                  controller: _emailController,
                                  prefixIcon: const Icon(Icons.person),
                                ),
                              ),
                              Gap(
                                size.height * 0.02,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.08),
                                child: CustomTextFormField(
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
                              ),
                              Gap(
                                size.height * 0.035,
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.08),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String? message =
                                          (_emailController.text.isEmpty
                                                  ? "username cannot be empty"
                                                  : null) ??
                                              _passwordValidator(
                                                  _passwordController.text);

                                      if (message != null) {
                                        Flushbar(
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                          backgroundColor: Colors.red,
                                          message: message,
                                          duration: const Duration(seconds: 2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          margin: EdgeInsets.only(
                                              top: size.height * 0.01,
                                              left: isMobile
                                                  ? 10
                                                  : size.width * 0.8,
                                              right: size.width * 0.03),
                                        ).show(context);
                                      } else {
                                        _authBloc.add(
                                            LoginButtonPressed(
                                                username: _emailController.text,
                                                password:
                                                    _passwordController.text));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        backgroundColor: const Color.fromARGB(
                                            255, 145, 19, 19),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        minimumSize: Size(
                                            size.width, size.height * 0.06)),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
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
      ),
    );
  }
}

String? _passwordValidator(String value) {
  if (value.isEmpty) {
    return "password cannot be empty";
  } else if (value.length < 10) {
    return "password must contain atleast 10 characters";
  }
  return null;
}
