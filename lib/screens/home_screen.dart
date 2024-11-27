import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import 'package:my_new_project/screens/movie_detail_screen.dart'; 
import 'package:my_new_project/screens/my_list_screen.dart';  // Importe a tela MyListScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Variável para controlar o índice do BottomNavigationBar

  // Função para trocar a tela com base no índice selecionado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navegação para "Minha Lista" ou para "Início" com base no índice selecionado
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => MyListScreen()), // Redireciona para "Minha Lista"
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Altera o fundo da Home para preto
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
        backgroundColor: Colors.black, // Cor de fundo do BottomNavigationBar
        selectedItemColor: Colors.white, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor do item não selecionado
        currentIndex: _selectedIndex, // Atualiza o índice selecionado
        onTap: _onItemTapped, // Chama a função para tratar o clique
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white), // Ícone em branco
            label: 'Início',
            backgroundColor: Colors.black, // Cor de fundo para a opção
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, color: Colors.white), // Ícone em branco
            label: 'Minha lista',
            backgroundColor: Colors.black, // Cor de fundo para a opção
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
                color: Colors.white, // Texto branco para os títulos das categorias
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
                          type: title == 'Novelas' || title == 'Séries' ? 'tv' : 'movie', // Define o tipo com base na categoria
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
    );
  }
}
