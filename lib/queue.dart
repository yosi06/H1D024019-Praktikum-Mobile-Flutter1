class Queue<T> {
  final List<T> _items = [];

  void enqueue(T item) {
    _items.add(item);
  }

  T? pop() {
    if (_items.isEmpty) return null;
    return _items.removeAt(0);
  }

  bool get isEmpty => _items.isEmpty;
  int get length => _items.length;
  List<T> get items => List.unmodifiable(_items);
}