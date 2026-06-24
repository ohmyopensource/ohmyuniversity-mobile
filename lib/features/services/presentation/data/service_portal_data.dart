import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/external_services_entity.dart';
import '../models/service_portal_models.dart';

const servicePortalCategories = [
  ServicePortalCategory(
    id: ServicePortalCategoryId.segreteria,
    label: 'Segreteria',
    icon: LucideIcons.building2,
    color: AppColors.colorPrimaryDark,
    backgroundColor: AppColors.colorPrimaryLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.didattica,
    label: 'Didattica',
    icon: LucideIcons.bookOpen,
    color: AppColors.colorSecondaryDark,
    backgroundColor: AppColors.colorSecondaryLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.email,
    label: 'Email & Comunicazione',
    icon: LucideIcons.mail,
    color: AppColors.colorTertiaryDark,
    backgroundColor: AppColors.colorTertiaryLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.borse,
    label: 'Borse & Servizi',
    icon: LucideIcons.wallet,
    color: AppColors.colorSuccessDark,
    backgroundColor: AppColors.colorSuccessLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.carriera,
    label: 'Carriera',
    icon: LucideIcons.briefcase,
    color: AppColors.colorWarningDark,
    backgroundColor: AppColors.colorWarningLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.collaborazione,
    label: 'Collaborazione',
    icon: LucideIcons.users,
    color: AppColors.colorInfoDark,
    backgroundColor: AppColors.colorInfoLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.benessere,
    label: 'Benessere & Supporto',
    icon: LucideIcons.shield,
    color: AppColors.colorErrorDark,
    backgroundColor: AppColors.colorErrorLight,
  ),
  ServicePortalCategory(
    id: ServicePortalCategoryId.internazionale,
    label: 'Internazionale',
    icon: LucideIcons.graduationCap,
    color: AppColors.colorPrimaryDark,
    backgroundColor: AppColors.colorPrimaryLight,
  ),
];

List<ServicePortalEntry> buildServicePortals({
  required ExternalServicesEntity services,
  required VoidCallback onOpenEmail,
}) {
  return [
    ServicePortalEntry(
      id: 'esse3',
      name: 'ESSE3 - Cineca',
      description:
          'Portale ufficiale per iscrizioni, pagamento tasse, piano di studi e gestione carriera universitaria.',
      url: services.studentPortalUrl,
      category: ServicePortalCategoryId.segreteria,
      tags: const ['iscrizione', 'tasse', 'carriera'],
      featured: true,
    ),
    ServicePortalEntry(
      id: 'ateneo',
      name: 'Portale di Ateneo',
      description:
          "Sito ufficiale dell'universita con news, bandi, regolamenti e informazioni istituzionali.",
      url: Uri.parse('https://www.unimol.it'),
      category: ServicePortalCategoryId.segreteria,
      tags: const ['notizie', 'bandi', 'regolamenti'],
    ),
    ServicePortalEntry(
      id: 'pagopa',
      name: 'PagoPA - Tasse universitarie',
      description:
          'Pagamento online delle tasse universitarie tramite il sistema PagoPA.',
      url: Uri.parse('https://www.pagopa.gov.it'),
      category: ServicePortalCategoryId.segreteria,
      tags: const ['pagamento', 'tasse', 'bollettino'],
    ),
    ServicePortalEntry(
      id: 'moodle',
      name: 'Moodle',
      description:
          'Piattaforma e-learning per materiali didattici, attivita online e forum dei corsi.',
      url: services.moodleUrl,
      category: ServicePortalCategoryId.didattica,
      tags: const ['materiali', 'corsi', 'forum'],
      featured: true,
    ),
    ServicePortalEntry(
      id: 'teams',
      name: 'Microsoft Teams',
      description:
          'Piattaforma per lezioni in streaming, riunioni con docenti e collaborazione tra studenti.',
      url: Uri.parse('https://teams.microsoft.com'),
      category: ServicePortalCategoryId.didattica,
      tags: const ['lezioni', 'streaming', 'riunioni'],
    ),
    ServicePortalEntry(
      id: 'biblioteca',
      name: 'Biblioteca Digitale',
      description:
          'Accesso a cataloghi, libri digitali, banche dati e risorse accademiche.',
      url: services.libraryUrl,
      category: ServicePortalCategoryId.didattica,
      tags: const ['libri', 'ricerca', 'cataloghi'],
    ),
    ServicePortalEntry(
      id: 'gmail-uni',
      name: 'Email istituzionale',
      description:
          'Consulta i messaggi del tuo account universitario e le comunicazioni ufficiali.',
      onTap: onOpenEmail,
      category: ServicePortalCategoryId.email,
      tags: const ['email', 'posta', 'comunicazioni'],
      featured: true,
    ),
    ServicePortalEntry(
      id: 'outlook',
      name: 'Outlook - Microsoft 365',
      description:
          'Accesso alla suite Microsoft 365 con email, calendario, OneDrive e Office online.',
      url: Uri.parse('https://outlook.office.com'),
      category: ServicePortalCategoryId.email,
      tags: const ['email', 'calendario', 'office'],
    ),
    ServicePortalEntry(
      id: 'dsu',
      name: 'DSU Molise - Borse di Studio',
      description:
          'Portale per borse di studio, alloggi universitari e servizi per il diritto allo studio.',
      url: Uri.parse('https://www.dsumolise.it'),
      category: ServicePortalCategoryId.borse,
      tags: const ['borsa di studio', 'alloggio', 'mensa'],
      featured: true,
    ),
    ServicePortalEntry(
      id: 'mensa',
      name: 'Mensa Universitaria',
      description:
          'Consultazione menu, orari e servizi collegati alle mense universitarie.',
      url: Uri.parse('https://www.dsumolise.it/mensa'),
      category: ServicePortalCategoryId.borse,
      tags: const ['mensa', 'pasti', 'orari'],
    ),
    ServicePortalEntry(
      id: 'almalaurea',
      name: 'AlmaLaurea',
      description:
          'Profilo, curriculum online e statistiche occupazionali dei laureati italiani.',
      url: Uri.parse('https://www.almalaurea.it'),
      category: ServicePortalCategoryId.carriera,
      tags: const ['cv', 'lavoro', 'laureati'],
      featured: true,
    ),
    ServicePortalEntry(
      id: 'linkedin',
      name: 'LinkedIn',
      description:
          'Rete professionale per costruire il profilo lavorativo e cercare stage o opportunita.',
      url: Uri.parse('https://www.linkedin.com'),
      category: ServicePortalCategoryId.carriera,
      tags: const ['networking', 'stage', 'lavoro'],
    ),
    ServicePortalEntry(
      id: 'drive',
      name: 'Google Drive',
      description:
          "Archiviazione e condivisione documenti su cloud con l'account universitario.",
      url: Uri.parse('https://drive.google.com'),
      category: ServicePortalCategoryId.collaborazione,
      tags: const ['cloud', 'documenti', 'condivisione'],
    ),
    ServicePortalEntry(
      id: 'onedrive',
      name: 'OneDrive - Microsoft',
      description:
          'Archiviazione cloud Microsoft con integrazione Office 365 e accesso da qualsiasi dispositivo.',
      url: Uri.parse('https://onedrive.live.com'),
      category: ServicePortalCategoryId.collaborazione,
      tags: const ['cloud', 'office', 'documenti'],
    ),
    ServicePortalEntry(
      id: 'cus',
      name: 'CUS - Centro Universitario Sportivo',
      description:
          "Attivita sportive, corsi e strutture del Centro Universitario Sportivo dell'ateneo.",
      url: Uri.parse('https://www.cusunimol.it'),
      category: ServicePortalCategoryId.benessere,
      tags: const ['sport', 'palestra', 'corsi'],
    ),
    ServicePortalEntry(
      id: 'counseling',
      name: 'Counseling Psicologico',
      description:
          'Servizio di supporto psicologico gratuito per studenti e prenotazione colloqui.',
      url: Uri.parse('https://www.unimol.it/counseling'),
      category: ServicePortalCategoryId.benessere,
      tags: const ['supporto', 'psicologia', 'benessere'],
    ),
    ServicePortalEntry(
      id: 'erasmus',
      name: 'Erasmus+ - Portale Ateneo',
      description:
          "Informazioni, bandi e candidature per programmi Erasmus+ di studio e tirocinio all'estero.",
      url: Uri.parse('https://www.unimol.it/erasmus'),
      category: ServicePortalCategoryId.internazionale,
      tags: const ['erasmus', 'estero', 'mobilita'],
      featured: true,
    ),
    ServicePortalEntry(
      id: 'erasmus-portal',
      name: 'Erasmus Without Paper',
      description:
          'Portale EU per la gestione digitale dei documenti Erasmus, OLA e Learning Agreement.',
      url: Uri.parse('https://www.erasmus-ewp.eu'),
      category: ServicePortalCategoryId.internazionale,
      tags: const ['erasmus', 'documenti', 'accordi'],
    ),
  ];
}
