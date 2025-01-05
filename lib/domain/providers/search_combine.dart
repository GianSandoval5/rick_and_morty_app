import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/data/models/apisodie_models.dart';
import 'package:rick_and_morty_app/data/models/character_models.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/domain/repositories/episodio_repository.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/core/graphql_client.dart';

// GraphQLClient Provider
final graphQLClientProvider = Provider<GraphQLClient>((ref) {
  return getGraphQLClient(); // Usa la función de mi core
});

// Character Repository Provider
final charactersProvider = FutureProvider<List<Character>>((ref) async {
  final repository = CharacterRepository();
  return repository.fetchCharacters();
});

// Episode Repository Provider
final episodeRepositoryProvider = Provider<EpisodeRepository>((ref) {
  final client = ref.read(graphQLClientProvider); // Obtener el GraphQLClient del provider
  return EpisodeRepository(client); // Pasamos el cliente al repositorio
});

final episodesProvider = FutureProvider<List<Episode>>((ref) async {
  final repository = ref.read(episodeRepositoryProvider); // Usamos el provider de repositorio
  return repository.fetchEpisodes();
});

// Search Query State
final searchProvider = StateProvider<String>((ref) => '');

// Search Combined Provider
final searchCombinedProvider = FutureProvider<Map<String, List>>((ref) async {
  final searchQuery = ref.watch(searchProvider).toLowerCase(); // Usamos .watch directamente
  final characters = await ref.watch(charactersProvider.future);
  final episodes = await ref.watch(episodesProvider.future);

  return {
    'characters': characters.where((c) => c.name.toLowerCase().contains(searchQuery)).toList(),
    'episodes': episodes.where((e) => e.name.toLowerCase().contains(searchQuery)).toList(),
  };
});