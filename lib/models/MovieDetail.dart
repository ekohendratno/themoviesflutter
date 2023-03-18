import 'package:flutter/material.dart';
import 'dart:convert';


class MovieDetail {
  final int id;
  final String tagline;
  final String title;
  final String overview;
  final String releaseDate;
  final double voteAverage;
  final String posterPath;

  MovieDetail({
    required this.id,
    required this.tagline,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.posterPath,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      tagline: json['tagline'] ?? '',
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      posterPath: json['poster_path'] ?? '',
    );
  }
}