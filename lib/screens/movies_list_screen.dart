import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'favorites_screen.dart';
import 'my_list_screen.dart';

class MoviesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/my-list');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: movieProvider.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar filmes.'));
          }
          return ListView.builder(
            itemCount: movieProvider.movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movieProvider.movies[index]);
            },
          );
        },
      ),
    );
  }
}
