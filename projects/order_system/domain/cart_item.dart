import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  CartItem({required this.product, required this.quantity})
    : assert(
        quantity >= product.minQty && quantity <= product.maxQty,
        'Quantity $quantity out of range [${product.minQty}, ${product.maxQty}]',
      );

  Map<String, dynamic> toJson() => {
    'product': product.name,
    'qty': quantity,
    'subtotal': subtotal,
  };
  double get subtotal => product.price * quantity;
  CartItem withQuantity(int newQty) =>
      CartItem(product: product, quantity: newQty);
}
