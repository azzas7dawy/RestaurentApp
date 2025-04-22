class MenuItem {
  final String docId;
  final String title;
  final String description;
  final double price;
  final String image;

  MenuItem({
    required this.docId,
    required this.title,
    required this.description,
    required this.price,
    required this.image, required String id, required name, required special,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      docId: json['docId'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'], id: '', name: null, special: null,
    );
  }
}