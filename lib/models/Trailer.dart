import 'package:flutter/material.dart';
import 'dart:convert';


class Trailer {
  final String id;
  final String keyYoutube;
  final String name;
  final String site;
  final String size;
  final String type;
  final bool official;

  Trailer({
    required this.id,
    required this.keyYoutube,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
  });

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      id: json['id'],
      keyYoutube: json['key'],
      name: json['name'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
      official: json['official'],
    );
  }
}