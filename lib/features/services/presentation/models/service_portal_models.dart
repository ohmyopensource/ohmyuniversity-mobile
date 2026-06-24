import 'package:flutter/material.dart';

enum ServicePortalCategoryId {
  segreteria,
  didattica,
  email,
  borse,
  carriera,
  collaborazione,
  benessere,
  internazionale,
}

class ServicePortalCategory {
  const ServicePortalCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  final ServicePortalCategoryId id;
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}

class ServicePortalEntry {
  const ServicePortalEntry({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    this.url,
    this.onTap,
    this.featured = false,
  });

  final String id;
  final String name;
  final String description;
  final ServicePortalCategoryId category;
  final List<String> tags;
  final Uri? url;
  final VoidCallback? onTap;
  final bool featured;

  bool get isAvailable => onTap != null || url != null;
}
