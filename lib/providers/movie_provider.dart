import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/movie.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _series = [];
  List<Movie> _novelas = [];
  final List<Movie> _favorites = [];
  final List<Movie> _myList = [];
  List<Movie> get movies => _movies;
  List<Movie> get series => _series;
  List<Movie> get novelas => _novelas;
  List<Movie> get favorites => _favorites;
  List<Movie> get myList => _myList;
  Movie? _selectedMovie; 
  Movie? get selectedMovie => _selectedMovie; 

  Future<void> fetchMovies() async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final apiKey = dotenv.env['API_KEY']!;
    final url = '$baseUrl/movie/now_playing?language=pt-BR&page=1&api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['results'];
        _movies = data.map<Movie>((json) => Movie.fromJson(json)).toList();
        notifyListeners();
      } else {
        debugPrint('Erro HTTP em filmes: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Erro ao buscar filmes: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar filmes: $error');
    }
  }

  Future<void> fetchSeries() async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final apiKey = dotenv.env['API_KEY']!;
    final url = '$baseUrl/tv/popular?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['results'];
        _series = data.map<Movie>((json) => Movie.fromJson(json)).toList();
        notifyListeners();
      } else {
        debugPrint('Erro HTTP em séries: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Erro ao buscar séries: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar séries: $error');
    }
  }

  Future<void> fetchNovelas() async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final apiKey = dotenv.env['API_KEY']!;
    final url = '$baseUrl/discover/tv?with_genres=10766&include_adult=false&language=en-US&page=1&sort_by=popularity.desc&api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['results'];
        _novelas = data.map<Movie>((json) => Movie.fromJson(json)).toList();
        notifyListeners();
      } else {
        debugPrint('Erro HTTP em novelas: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception('Erro ao buscar novelas: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar novelas: $error');
    }
  }

  Future<void> fetchMovieDetails(String movieId) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final apiKey = dotenv.env['API_KEY']!;
    final url = '$baseUrl/movie/$movieId?api_key=$apiKey&language=pt-BR';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _selectedMovie = Movie.fromJson(data);
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar detalhes do filme: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar detalhes do filme: $error');
    }
  }

  List<Movie> getCategory(String category) {
    if (category == 'Novelas') {
      return _novelas;
    } else if (category == 'Séries') {
      return _series;
    }

    final genreMapping = {
      'Cinema': [28, 12, 16]
    };

    final genreIds = genreMapping[category];
    if (genreIds == null) return [];

    return _movies.where((movie) => movie.genreIds.any((id) => genreIds.contains(id))).toList();
  }

  void toggleFavorite(Movie movie) {
    if (_favorites.contains(movie)) {
      _favorites.remove(movie);
    } else {
      _favorites.add(movie);
    }
    notifyListeners();
  }

  void toggleMyList(Movie movie) {
    if (_myList.contains(movie)) {
      _myList.remove(movie);
    } else {
      _myList.add(movie);
    }
    notifyListeners();
  }

  Future<void> fetchSeriesDetails(String seriesId) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final apiKey = dotenv.env['API_KEY']!;
    final url = '$baseUrl/tv/$seriesId?api_key=$apiKey&language=pt-BR';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _selectedMovie = Movie.fromJson(data);
        notifyListeners();
      } else {
        throw Exception('Erro ao buscar detalhes da série: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar detalhes da série: $error');
    }
  }

  void addToMyList(Movie movie) {
    if (!_myList.contains(movie)) {
      _myList.add(movie);
      notifyListeners();
    }
  }

  void removeFromMyList(Movie movie) {
    if (_myList.contains(movie)) {
      _myList.remove(movie);
      notifyListeners();
    }
  }
}
