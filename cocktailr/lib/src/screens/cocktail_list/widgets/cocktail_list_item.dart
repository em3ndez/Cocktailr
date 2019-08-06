import 'package:cocktailr/src/blocs/cocktail_bloc.dart';
import 'package:cocktailr/src/models/cocktail.dart';
import 'package:cocktailr/src/screens/cocktail_list/widgets/loading_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CocktailListItem extends StatelessWidget {
  final String cocktailId;

  CocktailListItem({@required this.cocktailId});

  @override
  Widget build(BuildContext context) {
    final cocktailBloc = Provider.of<CocktailBloc>(context);
    final height = MediaQuery.of(context).size.width / 4.2;

    return StreamBuilder(
      stream: cocktailBloc.cocktails,
      builder:
          (context, AsyncSnapshot<Map<String, Future<Cocktail>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        return FutureBuilder(
          future: snapshot.data[cocktailId],
          builder: (context, AsyncSnapshot<Cocktail> cocktailSnapshot) {
            if (!cocktailSnapshot.hasData) {
              return LoadingContainer();
            }

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      _cocktailImage(
                        cocktailSnapshot.data,
                        height,
                      ),
                      Expanded(
                        child: _cocktailDetails(
                          cocktailSnapshot.data,
                          height,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _cocktailImage(Cocktail cocktail, double height) => Hero(
        tag: "Cocktail ${cocktail.id}",
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              cocktail.image,
              width: height,
              height: height,
            ),
          ),
        ),
      );

  Widget _cocktailDetails(Cocktail cocktail, double height) => Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              cocktail.name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              cocktail.ingredients
                  .toString()
                  .replaceAll('[', '')
                  .replaceAll(']', ''),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
}
