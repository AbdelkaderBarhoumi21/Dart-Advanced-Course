class Product {
  final String id;
  final String name;
  final double price;
  final int minQty;
  final int maxQty;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.minQty,
    required this.maxQty,
  }) : assert(minQty >= 1, 'minQty must be >=1'),
       assert(maxQty >= minQty, 'maxQty must be >= minQty'),
       assert(price >= 0, 'price must be >=0');
}
