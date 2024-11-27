import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? posterUrl = movie.posterPath != null
        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        // Ação ao clicar no card, ex.: navegar para os detalhes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicou em ${movie.title}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagem do poster
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
                image: posterUrl != null
                    ? DecorationImage(
                        image: NetworkImage(posterUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: posterUrl == null
                  ? const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.white70,
                        size: 40,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Informações do filme
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Overview ou mensagem padrão
                    Text(
                      movie.overview ?? 'Descrição não disponível.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Data de lançamento (opcional)
                    if (movie.releaseDate != null)
                      Text(
                        'Lançamento: ${movie.releaseDate}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
