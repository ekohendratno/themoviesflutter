import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:themoviesflutter/constant/config.dart';
import 'package:themoviesflutter/models/Genre.dart';
import 'package:themoviesflutter/models/Movie.dart';
import 'package:themoviesflutter/models/MovieDetail.dart';
import 'package:themoviesflutter/models/Trailer.dart';
import 'package:themoviesflutter/models/Review.dart';

Future<List<Genre>> getGenreList(int page) async {
  final response = await http.get(
    Uri.parse(
      "$API_URL/genre/movie/list?api_key=$API_KEY&page=$page&language=en-US",
    ),
  );

  if (response.statusCode == 200) {
    final jsonList = jsonDecode(response.body)['genres'] as List<dynamic>;
    final genreList = jsonList.map((e) => Genre.fromJson(e)).toList();
    return genreList;
  } else {
    throw Exception('Failed to load genre list');
  }
}

Future<List<Movie>> getMoviesList(int page, int genreId) async {
  final response = await http.get(
    Uri.parse(
      "$API_URL/discover/movie?api_key=$API_KEY&with_genres=$genreId&page=$page&language=en-US",
    ),
  );

  if (response.statusCode == 200) {
    final jsonString = response.body;
    final jsonObject = json.decode(jsonString);
    final moviesArray = jsonObject['results'] as List<dynamic>;

    final movieList = moviesArray
        .map((movieObject) => Movie(
              id: movieObject['id'] as int,
              title: movieObject['title'] as String,
              overview: movieObject['overview'] as String,
              posterPath: movieObject['poster_path'] as String,
              releaseDate: movieObject['release_date'] as String,
              voteAverage: movieObject['vote_average'] == null
                  ? 0.0
                  : movieObject['vote_average'].toDouble() as double,
            ))
        .toList();

    return movieList;
  } else {
    throw Exception('Failed to load movies');
  }
}

Future<MovieDetail> getMoviesDetail(int movieId) async {
  final response = await http.get(
    Uri.parse(
      "$API_URL/movie/$movieId?api_key=$API_KEY&language=en-US",
    ),
  );

  if (response.statusCode == 200) {
    final jsonString = response.body;
    final jsonObject = json.decode(jsonString);

    final id = jsonObject['id'] as int;
    final tagline = jsonObject['tagline'] as String;
    final title = jsonObject['title'] as String;
    final overview = jsonObject['overview'] as String;
    final releaseDate = jsonObject['release_date'] as String;
    final rating = jsonObject['vote_average'] as double;
    final poster = jsonObject['poster_path'] as String;

    return MovieDetail(
      id: id,
      tagline: tagline,
      title: title,
      overview: overview,
      releaseDate: releaseDate,
      voteAverage: rating,
      posterPath: poster,
    );
  } else {
    throw Exception('Failed to load movie detail');
  }
}

Future<List<Trailer>> getMoviesTrailerList(int movieId) async {
  final response = await http.get(
    Uri.parse(
      "$API_URL/movie/$movieId/videos?api_key=$API_KEY&language=en-US",
    ),
  );

  if (response.statusCode == 200) {
    final jsonString = response.body;
    final jsonObject = json.decode(jsonString);
    final trailersArray = jsonObject['results'] as List<dynamic>;

    final trailerList = trailersArray
        .map((trailerObject) => Trailer(
              id: trailerObject['id'] as String,
              keyYoutube: trailerObject['key'] as String,
              name: trailerObject['name'] as String,
              site: trailerObject['site'] as String,
              size: trailerObject['size'].toString(),
              type: trailerObject['type'] as String,
              official: trailerObject['official'] as bool,
            ))
        .toList();

    return trailerList;
  } else {
    throw Exception('Failed to load trailers');
  }
}

Future<List<Review>> getMoviesReviewList(int page, int movieId) async {
  final response = await http.get(
    Uri.parse(
      "$API_URL/movie/$movieId/reviews?api_key=$API_KEY&page=$page&language=en-US",
    ),
  );

  if (response.statusCode == 200) {
    final jsonString = response.body;
    final jsonObject = json.decode(jsonString);
    final reviewsArray = jsonObject['results'];

    final reviewList = <Review>[];
    for (var i = 0; i < reviewsArray.length; i++) {
      final reviewObject = reviewsArray[i];
      final authorDetails = reviewObject['author_details'];

      final review = Review(
        author: reviewObject['author'],
        authorDetails: ReviewDetails(
          name: authorDetails['name'].toString(),
          username: authorDetails['username'].toString(),
          avatarPath: authorDetails['avatar_path'].toString(),
          rating: authorDetails['rating'].toString(),
        ),
        content: reviewObject['content'],
        createdAt: reviewObject['created_at'],
        id: reviewObject['id'],
        updatedAt: reviewObject['updated_at'],
        url: reviewObject['url'],
      );

      reviewList.add(review);
    }

    return reviewList;
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}