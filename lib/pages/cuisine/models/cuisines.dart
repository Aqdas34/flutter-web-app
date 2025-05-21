class Cuisine {
  final String id;
  final String chefId;
  final String cuisineType;
  final String name;
  final List<String> ingredients;
  final double price;
  final String imageUrl;
  final String description;


  Cuisine({
    required this.id,
    required this.chefId,
    required this.cuisineType,
    required this.name,
    required this.ingredients,
    required this.price,
    required this.imageUrl,
    required this.description,

  });

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(
      id: json['_id'],
      chefId: json['ChefId'],
      cuisineType: json['CuisineType'],
      name: json['Name'],
      ingredients: List<String>.from(json['Ingredients']),
      price: json['Price'].toDouble(),
      imageUrl: json['ImageURL'],
      description: json['Description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ChefId': chefId,
      'CuisineType': cuisineType,
      'Name': name,
      'Ingredients': ingredients,
      'Price': price,
      'ImageURL': imageUrl,
      'Description': description,
    };
  }
}