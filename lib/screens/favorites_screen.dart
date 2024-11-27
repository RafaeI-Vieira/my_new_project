import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final favorites = movieProvider.favorites;

    return Scaffold(
      appBar: AppBar(title: Text('Favoritos')),
      body: favorites.isEmpty
          ? Center(child: Text('Nenhum filme favorito.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: favorites[index]);
              },
            ),
    );
  }
}
