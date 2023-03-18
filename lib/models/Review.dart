import 'package:flutter/material.dart';
import 'dart:convert';

class Review {
  final String author;
  final ReviewDetails authorDetails;
  final String content;
  final String createdAt;
  final String id;
  final String updatedAt;
  final String url;

  Review({
    required this.author,
    required this.authorDetails,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.url,
  });
}

class ReviewDetails {
  final String name;
  final String username;
  final String avatarPath;
  final String rating;

  ReviewDetails({
    required this.name,
    required this.username,
    required this.avatarPath,
    required this.rating,
  });
}