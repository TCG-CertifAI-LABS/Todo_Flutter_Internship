class ListObjectsStruct<T> {
  late List<T> _objects = [];

  List<T> get objects => _objects;

  ListObjectsStruct({List<T>? objects}) {
    if (objects != null) {
      _objects = objects;
    }
  }

  bool contains(bool Function(T object) condition) {
    T? found = _objects.where(condition).firstOrNull;

    return found == null ? false : true;
  }

  List<T> clear() {
    List<T> initial = List.from(_objects);

    _objects.clear();

    return initial;
  }

  List<T> add(T object) {
    List<T> initial = List.from(_objects);

    _objects.add(object);

    return initial;
  }

  List<T> remove(bool Function(T object) condition) {
    List<T> initial = List.from(_objects);

    _objects.removeWhere(condition);

    return initial;
  }
}
