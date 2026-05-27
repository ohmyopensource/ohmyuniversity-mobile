import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../providers/onboarding_provider.dart';
import '../content/onboarding_slides.dart';
import '../widgets/onboarding_dots.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  int _currentIndex = 0;
  bool _isFinishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finish() {
    if (_isFinishing) return;
    _isFinishing = true;

    context.goNamed(AppRoutes.loginName);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final isLast = _currentIndex == onboardingSlides.length - 1;
    if (isLast && notification is OverscrollNotification) {
      final isForwardSwipe = notification.overscroll > 0;
      if (isForwardSwipe) {
        _finish();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingSlides.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return OnboardingSlide(slide: onboardingSlides[index]);
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 36,
              child: Center(
                child: OnboardingDots(
                  count: onboardingSlides.length,
                  currentIndex: _currentIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
