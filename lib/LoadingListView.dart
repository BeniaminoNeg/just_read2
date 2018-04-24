import 'package:flutter/material.dart';
import 'package:just_read2/MainPage.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class LoadingListView<T> extends StatefulWidget {
  ///Astrazione per il caricamento dei dati
  final PageRequest<T> pageRequest;

  ///Used for building Widgets out of
  /// the fetched data
  final WidgetAdapter<T> widgetAdapter;

  //numero di elementi per ogni pagina
  final int pageSize;

  //Numero elementi rimasti per caricare prossima pagina
  final int pageThreshold;

  //[PageView.reverse]
  final bool reverse;

  final Indexer<T> indexer;

  //Costruttore
  LoadingListView(this.pageRequest,
      {this.pageSize: 50,
      this.pageThreshold: 10,
      @required this.widgetAdapter,
      this.reverse: false,
      this.indexer});

  @override
  State<StatefulWidget> createState() {
    return new _LoadingListViewState();
  }
}

class _LoadingListViewState extends State<LoadingListView> {
  //Elementi pronti per essere visualizzati
  List objects = [];

  @override
  Widget build(BuildContext context) {
    ListView listView = new ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: objects.length,
        reverse: widget.reverse);

    return new RefreshIndicator(
        child: listView,
        onRefresh: onRefresh);
  }

  Widget itemBuilder(BuildContext context, int index) {
    return widget.widgetAdapter != null
        ? widget.widgetAdapter(objects[index])
        : new Container();
  }

  Future loadNext() async {
    int page = (objects.length / widget.pageSize).floor();
    List<T> fetched = await widget.pageRequest(page, widget.pageSize);

    if (mounted) {
      this.setState(() {
        objects.addAll(fetched);
      });
    }
  }

  Future onRefresh() async {
    this.request?.timeout(const Duration());
    List<T> fetched = await widget.pageRequest(0, widget.pageSize);
    setState(() {
      this.objects = fetched;
    });

    return true;
  }
}

class _LoadingListViewStateO<T> extends State<LoadingListView<T>> {
  List<T> objects = [];

  /// A Future returned by loadNext() if there
  /// is currently a request running
  /// or null, if no request is performed.
  Future request;

  void lockedLoadNext() {
    if (this.request == null) {
      this.request = loadNext().then((x) {
        this.request = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.lockedLoadNext();
  }

  Widget itemBuilder(BuildContext context, int index) {

    /// here we go: Once we are entering the threshold zone, the loadLockedNext()
    /// is triggered.
    if (index + widget.pageThreshold > objects.length) {
      loadLockedNext();
    }

    return widget.widgetAdapter != null ? widget.widgetAdapter(objects[index])
        : new Container();
  }


}
