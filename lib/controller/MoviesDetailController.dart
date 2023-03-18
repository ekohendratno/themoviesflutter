import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';
import 'package:themoviesflutter/constant/config.dart';
import 'package:themoviesflutter/network/TMDBClient.dart';
import 'package:themoviesflutter/models/Movie.dart';
import 'package:themoviesflutter/models/MovieDetail.dart';
import 'package:themoviesflutter/models/Trailer.dart';
import 'package:themoviesflutter/models/Review.dart';

class TrailerItem extends StatelessWidget {
  final String name;
  final String keyYoutube;

  TrailerItem({required this.name, required this.keyYoutube});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              'https://img.youtube.com/vi/$keyYoutube/mqdefault.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MoviesDetailControllerState extends StatefulWidget {
  final int movieId;
  MoviesDetailControllerState({required this.movieId});

  @override
  _MoviesDetailControllerScreenState createState() =>
      _MoviesDetailControllerScreenState();
}

class _MoviesDetailControllerScreenState
    extends State<MoviesDetailControllerState> {

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMoviesDetail(widget.movieId),
      builder: (context, AsyncSnapshot<MovieDetail> snapshot) {
        if (snapshot.hasData) {
          final movieDetail = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(movieDetail.title),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Image.network(
                        'https://image.tmdb.org/t/p/w500/${movieDetail.posterPath}',
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tagline: ${movieDetail.tagline}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('Release Date: ${movieDetail.releaseDate}'),
                      SizedBox(height: 8),
                      Text('Rating: ${movieDetail.voteAverage}'),
                      SizedBox(height: 16),
                      Text(movieDetail.overview),
                      SizedBox(height: 16),
                      Text(
                        'Trailers',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      FutureBuilder(
                        future: getMoviesTrailerList(widget.movieId),
                        builder:
                            (context, AsyncSnapshot<List<Trailer>> snapshot) {
                          if (snapshot.hasData) {
                            final trailers = snapshot.data!;
                            return Container(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: trailers.length,
                                itemBuilder: (context, index) {


                                  return GestureDetector(
                                      onTap: () async {
                                        final Uri _url = Uri.parse('https://www.youtube.com/watch?v=${trailers[index].keyYoutube}');
                                        _launchUrl(_url);
                                      },
                                      child: TrailerItem(
                                        name: trailers[index].name,
                                        keyYoutube: trailers[index].keyYoutube,
                                      )
                                  );


                                },
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Reviews',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
              body: FutureBuilder(
                future: getMoviesReviewList(1, widget.movieId),
                builder: (context, AsyncSnapshot<List<Review>> snapshot) {
                  if (snapshot.hasData) {
                    final reviews = snapshot.data!;
                    return ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Author: ${reviews[index].author}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rating: ${reviews[index].authorDetails.rating}',
                              ),
                              SizedBox(height: 4),
                              Text(
                                reviews[index].content,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
