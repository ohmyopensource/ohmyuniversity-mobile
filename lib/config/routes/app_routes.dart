/// Centralized constants for all app routes.
/// Always use these values instead of hardcoded strings.
abstract final class AppRoutes {
  // Pre-auth ================================
  static const splash = '/';
  static const splashName = 'splash';

  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';

  static const login = '/login';
  static const loginName = 'login';

  // Orientation (pre-auth | non-student) ================================
  static const orientamento = '/orientamento';
  static const orientamentoName = 'orientamento';

  static const orientamentoScegliCorso = '/orientamento/scegli-corso';
  static const orientamentoScegliCorsoName = 'orientamento-scegli-corso';

  static const orientamentoQuiz = '/orientamento/quiz';
  static const orientamentoQuizName = 'orientamento-quiz';

  static const orientamentoComeFunziona = '/orientamento/come-funziona';
  static const orientamentoComeFunzionaName = 'orientamento-come-funziona';

  static const orientamentoVitaUniversitaria =
      '/orientamento/vita-universitaria';
  static const orientamentoVitaUniversitariaName =
      'orientamento-vita-universitaria';

  static const orientamentoSbocchi = '/orientamento/sbocchi';
  static const orientamentoSbocchiName = 'orientamento-sbocchi';

  static const orientamentoErroriComuni = '/orientamento/errori-comuni';
  static const orientamentoErroriComuniName = 'orientamento-errori-comuni';

  // Bottom bar ================================
  static const home = '/home';
  static const homeName = 'home';

  static const academicCareer = '/academic-career';
  static const academicCareerName = 'academic-career';

  static const didattica = '/didattica';
  static const didatticaName = 'didattica';

  static const explore = '/explore';
  static const exploreName = 'explore';

  static const chat = '/chat';
  static const chatName = 'chat';

  static const aziende = '/aziende';
  static const aziendeName = 'aziende';

  static const services = '/services';
  static const servicesName = 'services';

  // Top bar ================================
  static const preferiti = '/preferiti';
  static const preferitiName = 'preferiti';

  // Drawer ================================
  static const notifiche = '/notifiche';
  static const notificheName = 'notifiche';
}