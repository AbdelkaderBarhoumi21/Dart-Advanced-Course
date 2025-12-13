enum OrderStatus {
  created('Created', canCancel: true, canPay: true),
  paymentPending('Payment Pending', canCancel: true, canPay: true),
  paid('Paid', canProcess: true),
  processing('Processing', canComplete: true, canRefund: true),
  shipped('Shipped', canComplete: true, canRefund: true),
  delivered('Delivered', canReturn: true),
  completed('Completed', canReview: true),
  cancelled('Cancelled', isFinal: true),
  refunded('Refunded', isFinal: true),
  returned('Returned', isFinal: true);

  const OrderStatus(
    this.label, {
    this.canCancel = false,
    this.canPay = false,
    this.canProcess = false,
    this.canComplete = false,
    this.canRefund = false,
    this.canReturn = false,
    this.canReview = false,
    this.isFinal = false,
  });

  final String label;
  final bool canCancel;
  final bool canPay;
  final bool canProcess;
  final bool canComplete;
  final bool canRefund;
  final bool canReturn;
  final bool canReview;
  final bool isFinal;

  List<OrderStatus> get validTransitions {
    switch (this) {
      case OrderStatus.created:
        return [paymentPending, cancelled];
      case OrderStatus.paymentPending:
        return [paid, cancelled];
      case OrderStatus.paid:
        return [processing, refunded];
      case OrderStatus.processing:
        return [shipped, refunded];
      case OrderStatus.shipped:
        return [delivered, refunded];
      case OrderStatus.delivered:
        return [completed, returned];
      case OrderStatus.completed:
        return [];
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
      case OrderStatus.returned:
        return [];
    }
  }

  bool canTransitionTo(OrderStatus newStatus) {
    return validTransitions.contains(newStatus);
  }

  Duration get estimatedDuration {
    switch (this) {
      case OrderStatus.created:
        return Duration(hours: 1);
      case OrderStatus.paymentPending:
        return Duration(hours: 24);
      case OrderStatus.paid:
      case OrderStatus.processing:
        return Duration(days: 2);
      case OrderStatus.shipped:
        return Duration(days: 5);
      case OrderStatus.delivered:
        return Duration(days: 1);
      case OrderStatus.completed:
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
      case OrderStatus.returned:
        return Duration.zero;
    }
  }

  String getIcon() {
    switch (this) {
      case OrderStatus.created:
        return '📝';
      case OrderStatus.paymentPending:
        return '💳';
      case OrderStatus.paid:
        return '✅';
      case OrderStatus.processing:
        return '⚙️';
      case OrderStatus.shipped:
        return '🚚';
      case OrderStatus.delivered:
        return '📦';
      case OrderStatus.completed:
        return '🎉';
      case OrderStatus.cancelled:
        return '❌';
      case OrderStatus.refunded:
        return '💰';
      case OrderStatus.returned:
        return '↩️';
    }
  }
}

class Order {
  final String id;
  OrderStatus _status;
  final List<StatusChange> _history = [];
  final DateTime createdAt;

  Order(this.id) : _status = OrderStatus.created, createdAt = DateTime.now() {
    _addHistoryEntry('Order created');
  }

  OrderStatus get status => _status;
  List<StatusChange> get history => List.unmodifiable(_history);

  bool canPerformAction(OrderAction action) {
    switch (action) {
      case OrderAction.cancel:
        return _status.canCancel;
      case OrderAction.pay:
        return _status.canPay;
      case OrderAction.process:
        return _status.canProcess;
      case OrderAction.ship:
        return _status.canProcess;
      case OrderAction.deliver:
        return _status.canComplete;
      case OrderAction.complete:
        return _status.canComplete;
      case OrderAction.refund:
        return _status.canRefund;
      case OrderAction.return_:
        return _status.canReturn;
    }
  }

  void transition(OrderStatus newStatus, {String? reason}) {
    if (!_status.canTransitionTo(newStatus)) {
      throw StateError(
        'Cannot transition from ${_status.label} to ${newStatus.label}',
      );
    }

    final oldStatus = _status;
    _status = newStatus;
    _addHistoryEntry(
      'Status changed from ${oldStatus.label} to ${newStatus.label}',
      reason: reason,
    );
  }

  void cancel({String? reason}) {
    if (!canPerformAction(OrderAction.cancel)) {
      throw StateError('Cannot cancel order in ${_status.label} status');
    }
    transition(OrderStatus.cancelled, reason: reason ?? 'Cancelled by user');
  }

  void pay() {
    if (!canPerformAction(OrderAction.pay)) {
      throw StateError('Cannot pay for order in ${_status.label} status');
    }
    transition(OrderStatus.paid, reason: 'Payment received');
  }

  void process() {
    if (!canPerformAction(OrderAction.process)) {
      throw StateError('Cannot process order in ${_status.label} status');
    }
    transition(OrderStatus.processing, reason: 'Order is being processed');
  }

  void ship() {
    transition(OrderStatus.shipped, reason: 'Order shipped');
  }

  void deliver() {
    transition(OrderStatus.delivered, reason: 'Order delivered');
  }

  void complete() {
    transition(OrderStatus.completed, reason: 'Order completed');
  }

  void refund({String? reason}) {
    if (!canPerformAction(OrderAction.refund)) {
      throw StateError('Cannot refund order in ${_status.label} status');
    }
    transition(OrderStatus.refunded, reason: reason ?? 'Refund requested');
  }

  void _addHistoryEntry(String message, {String? reason}) {
    _history.add(
      StatusChange(
        status: _status,
        timestamp: DateTime.now(),
        message: message,
        reason: reason,
      ),
    );
  }

  String getTimeline() {
    final buffer = StringBuffer();
    buffer.writeln('Order Timeline for #$id');
    buffer.writeln('=' * 50);
    for (var change in _history) {
      buffer.writeln(
        '${change.status.getIcon()} ${change.timestamp}: ${change.message}',
      );
      if (change.reason != null) {
        buffer.writeln('   Reason: ${change.reason}');
      }
    }

    return buffer.toString();
  }

  Duration get totalDuration {
    if (_history.isEmpty) return Duration.zero;
    return DateTime.now().difference(createdAt);
  }
}

enum OrderAction {
  cancel,
  pay,
  process,
  ship,
  deliver,
  complete,
  refund,
  return_,
}

class StatusChange {
  final OrderStatus status;
  final DateTime timestamp;
  final String message;
  final String? reason;

  StatusChange({
    required this.status,
    required this.timestamp,
    required this.message,
    this.reason,
  });
}

// Usage
void main() {
  final order = Order('ORD-001');

  print('Created order: ${order.status.label}');
  print('Can cancel: ${order.canPerformAction(OrderAction.cancel)}');

  order.pay();
  print('After payment: ${order.status.label}');

  order.process();
  order.ship();
  order.deliver();
  order.complete();

  print('\n${order.getTimeline()}');
  print('Total duration: ${order.totalDuration}');
}
