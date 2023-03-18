import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'dart:async';
import 'package:themoviesflutter/network/TMDBClient.dart';
import 'package:themoviesflutter/models/Genre.dart';
import 'package:themoviesflutter/controller/MoviesByGenreController.dart';

class GenresControllerState extends StatefulWidget {
  @override
  _GenresControllerScreenState createState() => _GenresControllerScreenState();
}

class _GenresControllerScreenState extends State<GenresControllerState>{
  late Future<List<Genre>> _genresFuture;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();

    _genresFuture = getGenreList(_currentPage);
    
  }

  @override
  void dispose() {    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genre List'),
      ),
      body: FutureBuilder<List<Genre>>(
        future: _genresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final genre = snapshot.data![index];
                return ListTile(
                  title: Text(genre.name),
                  subtitle: Text('ID: ${genre.id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoviesByGenreControllerState(genreId: genre.id, genreTitle: genre.name),
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
          title: Text('Genre List'),
        ),
        backgroundColor: Color(0xfffffffff),
        body:ListView.builder(
          itemCount: _genres.length,
          itemBuilder: (context, index) {
            final genre = _genres[index];
            return ListTile(
              title: Text(genre.name),
              subtitle: Text('ID: ${genre.id}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviesByGenreControllerState(genreId: genre.id, genreTitle: genre.name),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }*/
}
