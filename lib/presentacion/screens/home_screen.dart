import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_app/domain/providers/search_combine.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchCombinedProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Text(
          'Enciclopedia Rick & Morty',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) => ref.read(searchProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Buscar personajes o episodios...',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: searchResults.when(
              data: (results) {
                if (results['characters']!.isEmpty) {
                  return Center(
                    child: Text('No se encontraron personajes', style: const TextStyle(color: Colors.red)),
                  );
                }
                return ListView(
                  children: [
                    if (results['characters']!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text('Personajes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      ...results['characters']!.map((character) => Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            elevation: 10,
                            color: Colors.indigo,
                            child: ListTile(
                              leading: CircleAvatar(backgroundImage: NetworkImage(character.image)),
                              title: Text(character.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(character.status, style: const TextStyle(color: Colors.white)),
                              trailing: Text(character.species,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          )),
                    ],
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('No se encontró información', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
