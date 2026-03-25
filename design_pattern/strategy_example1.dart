abstract class RouteStrategy {
  void calculateRoute(String from, String to);
}

class CartStrategy implements RouteStrategy {
  @override
  void calculateRoute(String from, String to) {
    print('🚗 Car route: $from → $to (highway preferred)');
  }
}

class WalkStrategy implements RouteStrategy {
  @override
  void calculateRoute(String from, String to) {
    print('🚶 Walking route: $from → $to (shortest path)');
  }
}

class BusStrategy implements RouteStrategy {
  @override
  void calculateRoute(String from, String to) {
    print('🚌 Bus route: $from → $to (stops included)');
  }
}

class BikeStrategy implements RouteStrategy {
  @override
  void calculateRoute(String from, String to) {
    print('🚲 Bike route: $from → $to (bike lanes)');
  }
}

class Navigator {
  RouteStrategy _strategy;
  Navigator(this._strategy);

  void setStrategy(RouteStrategy strategy) {
    _strategy = strategy;
  }

  void getRoute(String from, String to) {
    _strategy.calculateRoute(from, to);
  }
}

void main() {
  final nav = Navigator(CartStrategy());
  nav.getRoute('Tunis', 'Sousse');
  nav.setStrategy(WalkStrategy());
  nav.getRoute('Siliana', 'Bouzid');
}
