const String fetchCharactersQuery = '''
  query {
    characters(page: 1) {
      results {
        id
        name
        image
        status
        species
        gender
        location {
          name
        }
      }
    }
  }
''';

const String fetchEpisodesQuery = '''
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
