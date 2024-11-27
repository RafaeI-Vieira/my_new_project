import 'package:flutter/material.dart';
import 'package:my_new_project/models/movie.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class MovieDetailScreen extends StatefulWidget {
  final String id;
  final String type;

  const MovieDetailScreen({required this.id, required this.type, Key? key}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isInMyList = false; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final movieProvider = Provider.of<MovieProvider>(context, listen: false);
      if (widget.type == 'movie') {
        await movieProvider.fetchMovieDetails(widget.id);
      } else {
        await movieProvider.fetchSeriesDetails(widget.id);
      }
      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao carregar detalhes.';
      });
    }
  }

  void _toggleMyList(Movie movie) {
    setState(() {
      _isInMyList = !_isInMyList;
    });
    if (_isInMyList) {
      Provider.of<MovieProvider>(context, listen: false).addToMyList(movie);
      Navigator.pushNamed(context, '/my_list_screen'); // Redirecionar para a tela "MyListScreen"
    } else {
      Provider.of<MovieProvider>(context, listen: false).removeFromMyList(movie);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final selectedItem = movieProvider.selectedMovie;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.type == 'movie'
              ? 'Detalhes do Filme'
              : 'Detalhes da Série/Novela',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.white)))
              : selectedItem == null
                  ? const Center(child: Text('Item não encontrado.', style: TextStyle(color: Colors.white)))
                  : Container( // Adicionar Container para fundo preto
                      color: Colors.black, // Fundo preto
                      child: Column(
                        children: [
                          MovieImage(imageUrl: selectedItem.posterPath),
                          MovieInfo(
                            title: selectedItem.title,
                            type: widget.type,
                            overview: selectedItem.overview ?? 'Sem descrição disponível.',
                          ),
                        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      ElevatedButton.icon(
        onPressed: () {}, // Lógica para assistir
        icon: Icon(Icons.play_arrow, color: Colors.white), // Ícone de play
        label: const Text(
          'Assista',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, // Cor de fundo do botão
        ),
      ),
      ElevatedButton.icon(
        onPressed: () => _toggleMyList(selectedItem),
        icon: Icon(_isInMyList ? Icons.check : Icons.star_border, color: Colors.white),
        label: Text(
          _isInMyList ? 'Adicionado' : 'Minha lista',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
      ),
    ],
  ),
),
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            indicatorColor: Colors.red,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: 'Assista Também'),
                              Tab(text: 'Detalhes'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildRecommendations(movieProvider),
                                _buildDetails(selectedItem),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildRecommendations(MovieProvider movieProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: movieProvider.movies.length,
        itemBuilder: (ctx, index) {
          final movie = movieProvider.movies[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://image.tmdb.org/t/p/w200${movie.posterPath}',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetails(Movie selectedItem) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.black, // Fundo preto para o componente de detalhes
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ficha técnica',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Título Original
            Text(
              'Título Original: ${selectedItem.originalTitle ?? 'Não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),

            // Gênero(s)
            Text(
              'Gênero: ${selectedItem.genres?.join(', ') ?? 'Não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),

            // Episódios (apenas se for uma série)
            selectedItem.isSeries
                ? Text(
                    'Episódios: ${selectedItem.numberOfEpisodes ?? 'Informação não disponível'}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                : Container(),

            const SizedBox(height: 5),

            // Ano de Produção
            Text(
              'Ano de Produção: ${selectedItem.productionYear ?? 'Não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),

            // País
            Text(
              'País: ${selectedItem.originCountry?.join(', ') ?? 'Não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),

            // Direção
            Text(
              'Direção: ${selectedItem.director ?? 'Não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),

            // Elenco
            Text(
              'Elenco: ${selectedItem.cast?.join(', ') ?? 'Não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),

            // Disponibilidade no Globoplay
            Text(
              'Disponível até: ${selectedItem.globoplayExpirationDate ?? 'Informação não disponível'}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieImage extends StatelessWidget {
  final String? imageUrl;

  const MovieImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://image.tmdb.org/t/p/w500$imageUrl'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}


class MovieInfo extends StatelessWidget {
  final String title;
  final String type;
  final String overview;

  const MovieInfo({
    required this.title,
    required this.type,
    required this.overview,
    Key? key,
  }) : super(key: key);
@override
Widget build(BuildContext context) {
  return Container(
    color: Colors.black, // Use 'color' em vez de 'backgroundColor'
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          type == 'movie'
              ? 'Filme'
              : type == 'series'
                  ? 'Série'
                  : 'Novela',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          overview,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}
}