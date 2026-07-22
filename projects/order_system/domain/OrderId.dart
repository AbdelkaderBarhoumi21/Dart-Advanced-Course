class OrderId {
  final String value;
  const OrderId(this.value);
  factory OrderId.generate() =>
      OrderId("ORD-${DateTime.now().millisecondsSinceEpoch}");
  @override
  String toString() => value;
}
