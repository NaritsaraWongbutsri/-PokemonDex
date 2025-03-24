class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItem> results;

  PokemonListResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<PokemonListItem>.from(
          json['results'].map((x) => PokemonListItem.fromJson(x))),
    );
  }
}

class PokemonListItem {
  final String name;
  final String url;
  String? imageUrl; // เพิ่ม imageUrl ที่นี่

  PokemonListItem({required this.name, required this.url, this.imageUrl});

  factory PokemonListItem.fromJson(Map<String, dynamic> json) {
    return PokemonListItem(
      name: json['name'],
      url: json['url'],
    );
  }
}
