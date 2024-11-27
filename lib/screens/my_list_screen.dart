import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import 'package:my_new_project/screens/movie_detail_screen.dart';

class MyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final myList = movieProvider.myList;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Minha Lista', 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), 
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: myList.isEmpty
          ? Center(
              child: Text(
                'Nenhum filme na sua lista.',
                style: TextStyle(color: Colors.white, fontSize: 18), 
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,  
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
                                  style: TextStyle(color: Colors.white, fontSize: 12), 
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
