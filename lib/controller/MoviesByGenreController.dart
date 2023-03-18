import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'dart:async';
import 'package:themoviesflutter/constant/config.dart';
import 'package:themoviesflutter/network/TMDBClient.dart';
import 'package:themoviesflutter/models/Movie.dart';
import 'package:themoviesflutter/controller/MoviesDetailController.dart';

class MoviesByGenreControllerState extends StatefulWidget {
  final int genreId;
  final String genreTitle;
  MoviesByGenreControllerState({required this.genreId, required this.genreTitle});

  @override
  _MoviesByGenreControllerScreenState createState() => _MoviesByGenreControllerScreenState();
}

class _MoviesByGenreControllerScreenState extends State<MoviesByGenreControllerState>{
  int _currentPage = 1;
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = getMoviesList(_currentPage, widget.genreId);
  }

  @override
  void dispose() {    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Film: ${widget.genreTitle}'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                return ListTile(
                  leading: Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}'),
                  title: Text(movie.title),
                  subtitle: Text(movie.overview),
                  trailing: Text('Rating: ${movie.voteAverage}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesDetailControllerState(movieId: movie.id),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }




  /*
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: Colors.black,
      overlayOpacity: 0.8,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movie List'),
        ),
        backgroundColor: Color(0xfffffffff),
        body: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                'https://image.tmdb.org/t/p/w92${_movies[index].posterPath}',
              ),
              title: Text(_movies[index].title),
              subtitle: Text(_movies[index].overview),
              trailing: Text(_movies[index].voteAverage.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviesDetailControllerState(movieId: _movies[index].id),
                  ),
                );
              },
            );
          },
        ) ,
      ),
    );
  }*/
}
