import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/domain/providers/search_combine.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersData = ref.watch(charactersProvider);
    final episodesData = ref.watch(episodesProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          'Estadísticas de Rick & Morty',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas Generales',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: charactersData.when(
                data: (characters) => episodesData.when(
                  data: (episodes) {
                    final speciesCount = _getSpeciesCount(characters);
                    final topCharacters = _getTopCharacters(characters);

                    return ListView(
                      children: [
                        Text(
                          'Cantidad Total de Episodios: ${episodes.length}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Especies más comunes:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        ...speciesCount.entries.map(
                          (entry) => Text(
                            '${entry.key}: ${entry.value}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Personajes más recurrentes:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        ...topCharacters.map(
                          (character) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: Colors.indigo,
                              elevation: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(character.image),
                                ),
                                title: Text(character.name,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                subtitle: Text('Apariciones: ${character.status}',
                                    style: const TextStyle(color: Colors.white)),
                                trailing: Text('${character.gender}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Center(child: Text('Error al cargar episodios: $e')),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Center(child: Text('Error al cargar personajes: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para contar las especies
  Map<String, int> _getSpeciesCount(List characters) {
    final speciesCount = <String, int>{};
    for (var character in characters) {
      speciesCount[character.species] = (speciesCount[character.species] ?? 0) + 1;
    }
    return speciesCount;
  }

  // Obtiene los personajes más recurrentes
  List _getTopCharacters(List characters) {
    return characters.take(5).toList();
  }
}
