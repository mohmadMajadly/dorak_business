import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dorak_business/viewModel/loading/loading_viewmodel.dart';
import 'widgets/error_dialog.dart';
import 'dart:math' as math;

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _checkRouting();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(_pulseController);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() {
    _fadeController.forward();
  }

  void _checkRouting() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<LoadingViewModel>().checkRouteCondition();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.isLoading && viewModel.errorMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ErrorDialog(
                  title: 'Connection Error',
                  message: viewModel.errorMessage!,
                  onRetry: () {
                    Navigator.of(context).pop();
                    viewModel.checkRouteCondition();
                  },
                );
              },
            );
          });
        }

        if (!viewModel.isLoading && viewModel.nextPage != null && viewModel.errorMessage == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                viewModel.nextPage!,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 800),
              ),
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.blue.shade500,
          body: Stack(
            children: [
              ...List.generate(
                3,
                    (index) => Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: index * math.pi / 3,
                        child: Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue.shade900.withOpacity(0.3),
                                  Colors.blue.shade700.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'DORAK',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const SizedBox(
                            height: 4,
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
