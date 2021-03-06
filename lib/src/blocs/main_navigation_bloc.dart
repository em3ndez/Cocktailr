import 'package:cocktailr/src/bases/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class MainNavigationBloc extends BlocBase {
  final _currentIndex = BehaviorSubject<int>.seeded(0);

  Observable<int> get currentIndex => _currentIndex.stream;

  Function(int) get changeCurrentIndex => _currentIndex.sink.add;

  @override
  void dispose() {
    _currentIndex.close();
  }
}
