import 'package:cocktailr/src/bases/blocs/bloc_base.dart';
import 'package:cocktailr/src/models/ingredient.dart';
import 'package:cocktailr/src/repositories/ingredient_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class IngredientBloc extends BlocBase {
  final IngredientRepository ingredientRepository;
  final _ingredientNames = BehaviorSubject<List<String>>();
  final _trendingIngredientNames = BehaviorSubject<List<String>>();
  final _ingredientsOutput = BehaviorSubject<Map<String, Future<Ingredient>>>();
  final _ingredientsFetcher = BehaviorSubject<String>();

  Observable<List<String>> get ingredientNames => _ingredientNames.stream;
  Observable<List<String>> get trendingIngredientNames => _trendingIngredientNames.stream;
  Observable<Map<String, Future<Ingredient>>> get ingredients => _ingredientsOutput.stream;

  Function(String) get fetchIngredient => _ingredientsFetcher.sink.add;

  IngredientBloc({@required this.ingredientRepository}) {
    _ingredientsFetcher.stream
        .transform(_ingredientsTransformer())
        .pipe(_ingredientsOutput);
    _fetchIngredientNames();
    _fetchTrendingCocktailNames();
  }

  Future<void> _fetchIngredientNames() async {
    List<String> ingredientsNames = await ingredientRepository.fetchIngredientNames();
    ingredientsNames.sort((a, b) => a.compareTo(b));
    _ingredientNames.sink.add(ingredientsNames);
  }

  Future<void> _fetchTrendingCocktailNames() async {
    List<String> ingredientNames = await ingredientRepository.fetchTrendingIngredientNames();
    _trendingIngredientNames.sink.add(ingredientNames);
  }

  Future<Ingredient> _fetchIngredientByName(String ingredientName) async => ingredientRepository.fetchIngredientByName(ingredientName);

   ScanStreamTransformer<String, Map<String, Future<Ingredient>>> _ingredientsTransformer() {
    return ScanStreamTransformer(
      (Map<String, Future<Ingredient>> cache, String name, _) {
        cache[name] = _fetchIngredientByName(name);
        return cache;
      },
      <String, Future<Ingredient>>{},
    );
  }

  @override
  void dispose() {
    _ingredientNames.close();
    _trendingIngredientNames.close();
    _ingredientsOutput.close();
    _ingredientsFetcher.close();
  }
}
