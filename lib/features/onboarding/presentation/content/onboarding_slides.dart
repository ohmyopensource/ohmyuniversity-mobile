import '../../../../core/constants/app_assets.dart';
import '../models/onboarding_slide_data.dart';

const onboardingSlides = [
  OnboardingSlideData(
    title: 'BENVENUTO SU\nOhMyUniversity!',
    subtitle: 'Tutto ciò di cui hai bisogno per la tua carriera accademica in un\'unica app.',
    animationAsset: AppAssets.onboardingLogo1,
  ),
  OnboardingSlideData(
    title: 'LA TUA CARRIERA\nACCADEMICA',
    subtitle:
        'Accedi a materiali dei corsi, orari, risultati degli esami e piano di studi.',
    animationAsset: AppAssets.onboardingChart2,
  ),
  OnboardingSlideData(
    title: 'MATERIALI\nDI STUDIO',
    subtitle: 'Accedi a slide, PDF e risorse universitarie all\'istante.',
    animationAsset: AppAssets.onboardingLoadingBook3,
  ),
  OnboardingSlideData(
    title: 'VITA DI\nCAMPUS',
    subtitle: 'Orari, aule, mappe e trasporti a portata di mano.',
    animationAsset: AppAssets.onboardingCommunity4,
  ),
  OnboardingSlideData(
    title: 'PIANIFICA IL\nTUO FUTURO',
    subtitle: 'Monitora i progressi, le notizie sulla laurea e i requisiti per la magistrale.',
    animationAsset: AppAssets.onboardingBusinessStrategy5,
  ),
];
