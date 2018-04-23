import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'JustRead',
      theme: new ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  //Usiamo questa variabile per indicare la pagina corrente
  int _page = 0;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: const Text('JustRead!')
        ),
        body: new PageView(
          children: <Widget>[
            new Container(),
            new Container(),
            new Container(),
          ],

          ///Andiamo a inserire il controllor per lo slide
          controller: _pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.import_contacts),
              title: new Text('Libreria'),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.format_quote),
              title: new Text('Citazioni'),
            )
          ],

          ///aggiungiamo l'azione per lo scroll
          onTap: navigationTapped,
          currentIndex: _page,
        )
    );
  }

  void navigationTapped(int page){
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }

  @override
  void @override // ignore: expected_executable
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  void onPageChanged(int page){
    setState(() {
      this._page = page;
    });
  }

  @override
  // ignore: expected_executable
  void @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

