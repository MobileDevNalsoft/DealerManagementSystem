import 'package:dms/providers/home_provider.dart';
import 'package:dms/providers/service_history_provider.dart';
import 'package:dms/views/homeview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => HomeProvider()),ChangeNotifierProvider(create: (_) => ServiceHistoryProvider()),],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    ),
  ));
}
