// Observer pattern manual implementation
// 1) Subject maintains state and observers list
// 2) Observers implement onUpdate(T data)
// 3) Subject.setState(newState) updates and notifies all observers

abstract class Observer<T> {
  void onUpdate(T data);
}

class Subject<T> {
  final List<Observer<T>> _observers = [];
  T? _state;

  void subscribe(Observer<T> observer) => _observers.add(observer);
  void unsubscribe(Observer<T> observer) => _observers.remove(observer);

  void setState(T newState) {
    _state = newState;
    _notifyAll();
  }

  void _notifyAll() {
    for (final observer in _observers) {
      observer.onUpdate(_state as T);
    }
  }
}

// Example
class CartSubject extends Subject<List<String>> {
  final List<String> _items = [];

  void addItem(String item) {
    _items.add(item);
    setState(List.from(_items));
  }

  void removeItem(String item) {
    _items.remove(item);
    setState(List.from(_items));
  }
}

class CartBadgeObserver implements Observer<List<String>> {
  @override
  void onUpdate(List<String> data) => print('Badge update : ${data.length}');
}

class CartSummaryObserver implements Observer<List<String>> {
  @override
  void onUpdate(List<String> data) => print('Summary: ${data.join(', ')}');
}

void main() {
  final cartSubject = CartSubject();
  cartSubject.subscribe(CartBadgeObserver());
  cartSubject.subscribe(CartSummaryObserver());

  cartSubject.addItem('Iphone 15 pro');
  cartSubject.addItem('AirPods Pro');
  cartSubject.addItem('Samsung 23');
  cartSubject.removeItem('AirPods Pro');
}
