import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorak_business/view/loading/loading_view.dart';
import 'package:dorak_business/viewModel/loading/loading_viewmodel.dart';
import 'package:dorak_business/service/loading/routing_service.dart';
import 'package:dorak_business/service/loading/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoadingViewModel(
            RoutingService(AuthService()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'dorak business',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoadingView(),
      ),
    );
  }
}