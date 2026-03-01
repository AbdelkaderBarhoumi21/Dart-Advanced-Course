import 'dart:math';

class EventException implements Exception {
  final String message;
  EventException(this.message);
  
  @override
  String toString() => 'EventException: $message';
}

enum TicketType {
  standard,
  vip,
  earlyBird,
  student
}

enum EventStatus {
  draft,
  published,
  soldOut,
  ongoing,
  completed,
  cancelled
}

class Ticket {
  final String id;
  final TicketType type;
  final double price;
  final String holderName;
  final String holderEmail;
  final DateTime purchaseDate;
  bool _checkedIn = false;
  
  Ticket({
    required this.type,
    required this.price,
    required this.holderName,
    required this.holderEmail,
  })  : id = _generateId(),
        purchaseDate = DateTime.now();
  
  bool get isCheckedIn => _checkedIn;
  
  void checkIn() {
    if (_checkedIn) {
      throw EventException('Ticket already checked in');
    }
    _checkedIn = true;
  }
  
  static String _generateId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(10000);
    return 'TKT-$timestamp-$randomNum';
  }
  
  @override
  String toString() {
    return '''
    Ticket ID: $id
    Type: ${type.name}
    Price: \$$price
    Holder: $holderName ($holderEmail)
    Checked In: $_checkedIn
    ''';
  }
}

class TicketPrice {
  final TicketType type;
  final double basePrice;
  final int quantity;
  int _sold = 0;
  
  TicketPrice({
    required this.type,
    required this.basePrice,
    required this.quantity,
  });
  
  int get remaining => quantity - _sold;
  bool get isAvailable => remaining > 0;
  double get revenue => _sold * basePrice;
  
  void sell() {
    if (!isAvailable) {
      throw EventException('No tickets available for ${type.name}');
    }
    _sold++;
  }
  
  void refund() {
    if (_sold > 0) {
      _sold--;
    }
  }
}

class Event {
  final String id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String venue;
  final int maxCapacity;
  
  EventStatus _status = EventStatus.draft;
  final Map<TicketType, TicketPrice> _ticketPrices = {};
  final List<Ticket> _tickets = [];
  final Set<String> _attendeeEmails = {};
  
  Event({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.maxCapacity,
  }) : id = _generateEventId();
  
  EventStatus get status => _status;
  int get totalTicketsSold => _tickets.length;
  int get remainingCapacity => maxCapacity - totalTicketsSold;
  int get checkedInCount => _tickets.where((t) => t.isCheckedIn).length;
  
  double get totalRevenue {
    return _ticketPrices.values
        .fold<double>(0, (sum, price) => sum + price.revenue);
  }
  
  void addTicketType(TicketType type, double price, int quantity) {
    if (_status != EventStatus.draft) {
      throw EventException('Cannot modify tickets after publishing');
    }
    
    final totalTickets = _ticketPrices.values
        .fold<int>(0, (sum, tp) => sum + tp.quantity);
    
    if (totalTickets + quantity > maxCapacity) {
      throw EventException('Total tickets exceed venue capacity');
    }
    
    _ticketPrices[type] = TicketPrice(
      type: type,
      basePrice: price,
      quantity: quantity,
    );
  }
  
  void publish() {
    if (_ticketPrices.isEmpty) {
      throw EventException('Add at least one ticket type before publishing');
    }
    
    if (_status != EventStatus.draft) {
      throw EventException('Event is already published');
    }
    
    _status = EventStatus.published;
  }
  
  Ticket purchaseTicket({
    required TicketType type,
    required String holderName,
    required String holderEmail,
  }) {
    if (_status != EventStatus.published) {
      throw EventException('Event is not available for ticket purchase');
    }
    
    if (!_ticketPrices.containsKey(type)) {
      throw EventException('Ticket type not available');
    }
    
    final ticketPrice = _ticketPrices[type]!;
    if (!ticketPrice.isAvailable) {
      throw EventException('Sold out for ${type.name} tickets');
    }
    
    // Check for duplicate attendee
    if (_attendeeEmails.contains(holderEmail)) {
      throw EventException('Email already registered for this event');
    }
    
    ticketPrice.sell();
    _attendeeEmails.add(holderEmail);
    
    final ticket = Ticket(
      type: type,
      price: ticketPrice.basePrice,
      holderName: holderName,
      holderEmail: holderEmail,
    );
    
    _tickets.add(ticket);
    
    // Check if sold out
    if (_isFullyBooked()) {
      _status = EventStatus.soldOut;
    }
    
    return ticket;
  }
  
  void refundTicket(String ticketId) {
    final ticketIndex = _tickets.indexWhere((t) => t.id == ticketId);
    
    if (ticketIndex == -1) {
      throw EventException('Ticket not found');
    }
    
    final ticket = _tickets[ticketIndex];
    
    if (ticket.isCheckedIn) {
      throw EventException('Cannot refund checked-in ticket');
    }
    
    _tickets.removeAt(ticketIndex);
    _attendeeEmails.remove(ticket.holderEmail);
    _ticketPrices[ticket.type]!.refund();
    
    if (_status == EventStatus.soldOut) {
      _status = EventStatus.published;
    }
  }
  
  void checkInTicket(String ticketId) {
    final ticket = _tickets.firstWhere(
      (t) => t.id == ticketId,
      orElse: () => throw EventException('Ticket not found'),
    );
    
    ticket.checkIn();
  }
  
  void start() {
    if (_status != EventStatus.published && _status != EventStatus.soldOut) {
      throw EventException('Event must be published before starting');
    }
    _status = EventStatus.ongoing;
  }
  
  void complete() {
    if (_status != EventStatus.ongoing) {
      throw EventException('Event must be ongoing to complete');
    }
    _status = EventStatus.completed;
  }
  
  void cancel() {
    if (_status == EventStatus.completed) {
      throw EventException('Cannot cancel completed event');
    }
    _status = EventStatus.cancelled;
  }
  
  bool _isFullyBooked() {
    return _ticketPrices.values.every((tp) => !tp.isAvailable);
  }
  
  Map<TicketType, int> getTicketDistribution() {
    final distribution = <TicketType, int>{};
    
    for (var ticket in _tickets) {
      distribution[ticket.type] = (distribution[ticket.type] ?? 0) + 1;
    }
    
    return distribution;
  }
  
  List<Ticket> getTicketsByType(TicketType type) {
    return _tickets.where((t) => t.type == type).toList();
  }
  
  String generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('=' * 60);
    buffer.writeln('EVENT REPORT: $name');
    buffer.writeln('=' * 60);
    buffer.writeln('Status: ${status.name}');
    buffer.writeln('Venue: $venue');
    buffer.writeln('Date: ${startDate.toString().split(' ')[0]} to ${endDate.toString().split(' ')[0]}');
    buffer.writeln('\nCapacity:');
    buffer.writeln('  Total: $maxCapacity');
    buffer.writeln('  Sold: $totalTicketsSold');
    buffer.writeln('  Remaining: $remainingCapacity');
    buffer.writeln('  Checked In: $checkedInCount');
    
    buffer.writeln('\nTicket Sales:');
    for (var entry in _ticketPrices.entries) {
      final type = entry.key;
      final price = entry.value;
      buffer.writeln('  ${type.name}:');
      buffer.writeln('    Sold: ${price._sold}/${price.quantity}');
      buffer.writeln('    Price: \$${price.basePrice}');
      buffer.writeln('    Revenue: \$${price.revenue}');
    }
    
    buffer.writeln('\nTotal Revenue: \$${totalRevenue.toStringAsFixed(2)}');
    buffer.writeln('=' * 60);
    
    return buffer.toString();
  }
  
  static String _generateEventId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'EVT-$timestamp';
  }
}

// Usage
void main() {
  final event = Event(
    name: 'Flutter Conference 2024',
    description: 'Annual Flutter developer conference',
    startDate: DateTime(2024, 6, 15),
    endDate: DateTime(2024, 6, 17),
    venue: 'Convention Center',
    maxCapacity: 500,
  );
  
  // Setup ticket types
  event.addTicketType(TicketType.earlyBird, 199.99, 100);
  event.addTicketType(TicketType.standard, 299.99, 300);
  event.addTicketType(TicketType.vip, 499.99, 50);
  event.addTicketType(TicketType.student, 99.99, 50);
  
  event.publish();
  
  // Purchase tickets
  try {
    final ticket1 = event.purchaseTicket(
      type: TicketType.earlyBird,
      holderName: 'John Doe',
      holderEmail: 'john@example.com',
    );
    
    final ticket2 = event.purchaseTicket(
      type: TicketType.vip,
      holderName: 'Jane Smith',
      holderEmail: 'jane@example.com',
    );
    
    event.checkInTicket(ticket1.id);
    
    print(event.generateReport());
  } on EventException catch (e) {
    print('Error: $e');
  }
}
