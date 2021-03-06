import 'package:cocktailr/src/blocs/main_navigation_bloc.dart';
import 'package:cocktailr/src/screens/cocktail_list/cocktail_list_screen.dart';
import 'package:cocktailr/src/screens/home/home_screen.dart';
import 'package:cocktailr/src/services/app_localizations.dart';
import 'package:cocktailr/src/services/navigation_router.dart';
import 'package:cocktailr/src/services/navigation_service.dart';
import 'package:cocktailr/src/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _controller;

  final Map<String, Widget> _screens = Map.fromEntries([
    MapEntry<String, Widget>(AppLocalizations.current.navigationLabelHomeScreen, HomeScreen()),
    MapEntry<String, Widget>(AppLocalizations.current.navigationLabelCocktailScreen, CocktailListScreen()),
  ]);

  void _onPageChanged(int index) {
    final bloc = Provider.of<MainNavigationBloc>(context);
    bloc.changeCurrentIndex(index);
  }

  void _animateToPage(int index) {
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  Future<void> _onSearchIconPressed() async {
    await sl<NavigationService>().navigateTo(NavigationRouter.search);
  }

  Future<bool> _onWillPop(int index, MainNavigationBloc bloc) {
    if (index == 0) {
      return Future.value(true);
    }

    _animateToPage(0);
    bloc.changeCurrentIndex(0);
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainNavigationBloc = Provider.of<MainNavigationBloc>(context);

    return StreamBuilder(
      stream: mainNavigationBloc.currentIndex,
      initialData: 0,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.data != 0) {
          _animateToPage(snapshot.data);
        }

        return WillPopScope(
          onWillPop: () => _onWillPop(snapshot.data, mainNavigationBloc),
          child: Scaffold(
            appBar: _buildAppBar(snapshot.data),
            body: _buildBody(snapshot.data),
            bottomNavigationBar: _buildBottomNavigationBar(snapshot.data),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(int index) => AppBar(
        title: Text(_screens.keys.toList()[index]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _onSearchIconPressed,
            tooltip: AppLocalizations.of(context).mainButtonLabelSearch,
          ),
        ],
      );

  Widget _buildBody(int index) => PageView(
        controller: _controller,
        children: _screens.values.toList(),
        onPageChanged: (int index) => _onPageChanged(index),
      );

  Widget _buildBottomNavigationBar(int index) => BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.compass),
            title: Text(AppLocalizations.of(context).navigationLabelHomeScreen),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_bar),
            title: Text(AppLocalizations.of(context).navigationLabelCocktailScreen),
          ),
        ],
        onTap: _animateToPage,
        type: BottomNavigationBarType.fixed,
      );
}
