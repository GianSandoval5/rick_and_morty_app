import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/data/models/apisodie_models.dart';

// Repositorio de episodios
class EpisodeRepository {
  final GraphQLClient client;

  // Constructor del repositorio, donde inyectamos el cliente de GraphQL
  EpisodeRepository(this.client);

  // Método para obtener todos los episodios
  Future<List<Episode>> fetchEpisodes() async {
    const String query = r'''
      query {
        episodes {
          results {
            id
            name
            air_date
            episode
          }
        }
      }
    ''';

    try {
      // Realizamos la consulta a la API de GraphQL
      final QueryResult result = await client.query(
        QueryOptions(document: gql(query)),
      );

      // Verificamos si hubo algún error en la consulta
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      // Extraemos la lista de episodios desde la respuesta de GraphQL
      final List episodesData = result.data?['episodes']['results'] ?? [];

      // Mapeamos los datos y los convertimos en objetos de tipo Episode
      return episodesData.map((e) => Episode.fromJson(e)).toList();
    } catch (e) {
      // En caso de cualquier otro error, lo lanzamos
      throw Exception('Error al obtener episodios: $e');
    }
  }
}
