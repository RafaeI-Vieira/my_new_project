import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import 'package:my_new_project/screens/movie_detail_screen.dart'; 
import 'package:my_new_project/screens/my_list_screen.dart'; 
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => MyListScreen()), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        title: Text('globoplay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<MovieProvider>(context, listen: false).fetchMovies(),
          Provider.of<MovieProvider>(context, listen: false).fetchSeries(),
          Provider.of<MovieProvider>(context, listen: false).fetchNovelas(),
        ]),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar conteúdo', style: TextStyle(color: Colors.white)));
          } else {
            return Consumer<MovieProvider>(
              builder: (ctx, movieProvider, child) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategorySection(title: 'Novelas', items: movieProvider.getCategory('Novelas')),
                      CategorySection(title: 'Séries', items: movieProvider.getCategory('Séries')),
                      CategorySection(title: 'Cinema', items: movieProvider.getCategory('Cinema')),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, 
        selectedItemColor: Colors.white, 
        unselectedItemColor: Colors.grey, 
        currentIndex: _selectedIndex, 
        onTap: _onItemTapped, 
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white), 
            label: 'Início',
            backgroundColor: Colors.black, 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, color: Colors.white), 
            label: 'Minha lista',
            backgroundColor: Colors.black, 
          ),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List<Movie> items;

  CategorySection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (ctx, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => MovieDetailScreen(
                          id: item.id.toString(), // ID do item
                          type: title == 'Novelas' || title == 'Séries' ? 'tv' : 'movie', 
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
                            'https://image.tmdb.org/t/p/w200${item.posterPath}',
                            fit: BoxFit.cover,
                            width: 120,
                            height: 160,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          item.title ?? 'Sem título',
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
    );
  }
}
