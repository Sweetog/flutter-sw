import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/services/site_service.dart';
import 'package:app/@core/util/map_util.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/inlet/upsert.dart';
import 'package:app/screens/inlet/upsert_site.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/map/map-view.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final TextStyle errorStyle = UIUtil.createTxtStyle(18, color: Colors.red);
const CARD_HEIGHT = 110.0;

class SiteInlets extends StatefulWidget {
  final String _siteId;

  SiteInlets(this._siteId);

  @override
  _SiteInletsState createState() => _SiteInletsState(this._siteId);
}

class _SiteInletsState extends State<SiteInlets> {
  static final _lg = new Logger();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String _siteId;
  JobModel? _site;
  _SiteInletsState(this._siteId);
  ScrollController? _controller;
  bool _inletOrderHasChanged = false;

  @override
  void initState() {
    _controller = ScrollController();
    _controller!.addListener(_scrollListener); //the listener for up and down.
    super.initState();
  }

  _scrollListener() {
    if (_controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
    if (_controller!.offset <= _controller!.position.minScrollExtent &&
        !_controller!.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SiteService.getSite(this._siteId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold(context);
          }

          _site = snapshot.data;
          return _buildScaffold(context);
        });
  }

  Widget _buildScaffold(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_inletOrderHasChanged) {
          await _updateInletOrder(_siteId, _site!.inlets!);
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: SdAppBar(),
        body: _buildBody(),
        bottomNavigationBar: NavBar(index: NavBarIndex.Jobs),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () => _navigateInletUpsert(context, _siteId),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_site == null) {
      return Loading();
    }

    return ReorderableListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var inlets = _site!.inlets!;
          return _buildCard(_siteId, inlets[index], index, inlets);
        },
        itemCount: (_site!.inlets != null) ? _site!.inlets!.length : 0,
        onReorder: _reorderInlets);
  }

  Widget _buildCard(
      String siteId, InletModel inlet, index, List<InletModel> inlets) {
    return Card(
      key: Key('$index'),
      color: SdColors.primaryBackground,
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: SdColors.primaryForeground,
          ),
        ),
        height: CARD_HEIGHT,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 8,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 2,
                  right: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Container(
                    //   height: 70,
                    //   child: Image(
                    //     image: NetworkImage(inlet.beforeImgUrl),
                    //   ),
                    // ),
                    Column(
                      children: [
                        Text(
                          '${index + 1} - ${inlet.type}',
                          style: UIUtil.getTxtStyleTitle3(),
                          textAlign: TextAlign.left,
                        ),
                        GestureDetector(
                            onTap: () {
                              MapUtil.openMapLL(inlet.location.latitude,
                                  inlet.location.longitude);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: SdColors.swLightBlue,
                                ),
                                Text(
                                  'Navigate to Inlet',
                                  style: UIUtil.getTxtStyleCaption2(),
                                )
                              ],
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          child: Row(
                            children: [
                              Icon(Icons.map),
                              Text(
                                'Map',
                                style: UIUtil.getTxtStyleCaption1(),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await _updateInletOrder(siteId, inlets);
                            _navigateMap(
                                context,
                                inlet.location.latitude,
                                inlet.location.longitude,
                                _site!.inlets!,
                                index);
                          },
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              Text(
                                'Edit',
                                style: UIUtil.getTxtStyleCaption1(),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await _updateInletOrder(siteId, inlets);
                            _navigateInletUpsert(context, siteId,
                                inletIndex: index);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reorderInlets(prev, nxt) {
    _inletOrderHasChanged = true;
    var inlets = _site!.inlets!;
    InletModel old = inlets[prev];

    if (prev > nxt) {
      for (int i = prev; i > nxt; i--) {
        inlets[i] = inlets[i - 1];
      }
      inlets[nxt] = old;
    } else {
      for (int i = prev; i < nxt - 1; i++) {
        inlets[i] = inlets[i + 1];
      }
      inlets[nxt - 1] = old;
    }
  }

  Future<void> _updateInletOrder(String siteId, List<InletModel> inlets) async {
    if (!_inletOrderHasChanged) return;
    UIUtil.snackBar(context, 'Updating Order of Inlets...');
    await SiteService.updateInletsOrder(id: siteId, inlets: inlets);
    _inletOrderHasChanged = false;
    UIUtil.snackBarClose();
  }

  void _navigateMap(BuildContext context, double latitude, double longitude,
      List<InletModel> inlets, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapView(
                latitude: latitude,
                longitude: longitude,
                inlets: inlets,
                currentIndex: index,
              )),
    );
  }

  void _navigateInletUpsert(BuildContext context, String siteId,
      {int? inletIndex}) async {
    if (this._inletOrderHasChanged) {
      await SiteService.updateInletsOrder(id: _siteId, inlets: _site!.inlets!);
    }
    var inletUpsertRoute = MaterialPageRoute(
      builder: (context) => InletSiteUpsert(
        siteId,
        editIndex: inletIndex,
      ),
    );

    inletUpsertRoute.popped.then((value) {
      SiteService.getSite(this._siteId).then((site) {
        setState(() {
          _site = site;
        });
      });
    });

    await Navigator.push(
      context,
      inletUpsertRoute,
    );
  }
}
