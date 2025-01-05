import 'dart:io';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_app/core/graphql_client.dart';
import 'package:rick_and_morty_app/data/graphql/queries.dart';
import 'package:rick_and_morty_app/data/models/character_models.dart';

class CharacterRepository {
  Future<List<Character>> fetchCharacters() async {
    try {
      final client = getGraphQLClient();
      final result = await client.query(QueryOptions(document: gql(fetchCharactersQuery)));
      if (result.hasException) throw Exception(result.exception.toString());
      final List characters = result.data?['characters']['results'] ?? [];
      return characters.map((e) => Character.fromJson(e)).toList();
    } on SocketException {
      throw Exception('Sin conexión a Internet');
    } catch (e) {
      throw Exception('Algo salió mal: $e');
    }
  }
}
