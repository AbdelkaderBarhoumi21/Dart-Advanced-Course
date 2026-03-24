// Complex subsystems
class StockService {
  bool checkAvailability(String productId) {
    print('Checking stock for $productId...');
    return true;
  }
}

class PaymentService {
  bool processPayment(double amount) {
    print('Processing payment \$$amount...');
    return true;
  }
}

class DeliveryService {
  String scheduleDelivery(String address) {
    print('Scheduling delivery to $address...');
    return 'TRACK-001';
  }
}

class NotificationService {
  void sendConfirmation(String trackingId) {
    print('SMS sent — tracking: $trackingId');
  }
}

// The Facade
class OrderFacade {
  final _stock = StockService();
  final _payment = PaymentService();
  final _delivery = DeliveryService();
  final _notification = NotificationService();

  void placeOrder(String productId, double amount, String address) {
    _stock.checkAvailability(productId);
    _payment.processPayment(amount);
    final trackingId = _delivery.scheduleDelivery(address);
    _notification.sendConfirmation(trackingId);
  }
}

void main() {
  final order = OrderFacade();
  order.placeOrder('iPhone-15', 999.0, 'Tunis, Lac 2');
}
