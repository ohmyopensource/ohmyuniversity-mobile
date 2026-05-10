import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_dots.dart';

// Slide content ================================

class _SlideData {
  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

const _slides = [
  _SlideData(
    icon: Icons.school_outlined,
    title: 'Welcome to OhMyUniversity!',
    subtitle:
    'Your all-in-one companion for university life. Manage your academic journey from a single app.',
  ),
  _SlideData(
    icon: Icons.menu_book_outlined,
    title: 'Didattica',
    subtitle:
    'Access your course materials, timetables, exam results, and study plan — all in one place.',
  ),
  _SlideData(
    icon: Icons.language_outlined,
    title: 'Explore',
    subtitle:
    'Discover graduate programmes, calls for applications, and opportunities offered by your university.',
  ),
  _SlideData(
    icon: Icons.chat_bubble_outline,
    title: 'Chat',
    subtitle:
    'Stay connected with classmates, tutors, and university staff through the integrated chat.',
  ),
  _SlideData(
    icon: Icons.business_center_outlined,
    title: 'Aziende',
    subtitle:
    'Explore job postings, internships, and events from companies partnered with your university.',
  ),
];

// Page ================================

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    await completeOnboarding(ref);
    if (!mounted) return;
    context.goNamed(AppRoutes.loginName);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLast = _currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button ================================
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
                child: AnimatedOpacity(
                  opacity: isLast ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: isLast ? null : _skip,
                    child: Text(
                      'Skip',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ),

            // Slides ================================
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return OnboardingSlide(
                    icon: slide.icon,
                    title: slide.title,
                    subtitle: slide.subtitle,
                  );
                },
              ),
            ),

            // Bottom bar: dots + button ================================
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OnboardingDots(
                    count: _slides.length,
                    currentIndex: _currentIndex,
                  ),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(isLast ? 'Get started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}