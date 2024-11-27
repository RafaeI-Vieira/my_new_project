import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart'; // Adicionando o modelo Movie caso precise
import 'package:my_new_project/screens/movie_detail_screen.dart';  // Importe a tela de detalhes

class MyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final myList = movieProvider.myList;

    return Scaffold(
      backgroundColor: Colors.black, // Fundo preto para tema escuro
      appBar: AppBar(
        title: Text(
          'Minha Lista', 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Título branco
        ),
        backgroundColor: Colors.black, // Fundo preto para a AppBar
        centerTitle: true,
      ),
      body: myList.isEmpty
          ? Center(
              child: Text(
                'Nenhum filme na sua lista.',
                style: TextStyle(color: Colors.white, fontSize: 18), // Texto branco
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,  // Ajuste para a altura do ListView horizontal
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: myList.length,
                      itemBuilder: (ctx, index) {
                        final movie = myList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => MovieDetailScreen(
                                  id: movie.id.toString(),
                                  type: movie.isSeries ? 'tv' : 'movie',
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 160,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  movie.title ?? 'Sem título',
                                  style: TextStyle(color: Colors.white, fontSize: 12), // Texto branco
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
