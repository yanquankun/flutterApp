import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:mint_app/amap-basic/base_page.dart';
import 'package:mint_app/amap-basic/const_config.dart';
import 'package:mint_app/amap-widgets/amap_switch_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:mint_app/common/comfun.dart';
import 'dart:async';

class amapNavigatePage extends BasePage {
  amapNavigatePage(String title, String subTitle) : super(title, subTitle);
  @override
  Widget build(BuildContext context) {
    return _MapUiBody();
  }
}

class _MapUiBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapUiBodyState();
}

class _MapUiBodyState extends State<_MapUiBody> {
  // 以下为定位变量
  Map<String, Object> _locationResult;

  StreamSubscription<Map<String, Object>> _locationListener;

  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();
  //  以上为定位

  //默认显示在北京天安门
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(39.909187, 116.397451),
    zoom: 18.0,
  );

  ///地图类型
  MapType _mapType = MapType.bus;

  ///显示路况开关
  bool _trafficEnabled = true;

  /// 地图poi是否允许点击
  bool _touchPoiEnabled = true;

  ///是否显示3D建筑物
  bool _buildingsEnabled = true;

  ///是否显示底图文字标注
  bool _labelsEnabled = true;

  ///是否显示指南针
  bool _compassEnabled = true;

  ///是否显示比例尺
  bool _scaleEnabled = true;

  ///是否支持缩放手势
  bool _zoomGesturesEnabled = true;

  ///是否支持滑动手势
  bool _scrollGesturesEnabled = true;

  ///是否支持旋转手势
  bool _rotateGesturesEnabled = true;

  ///是否支持倾斜手势
  bool _tiltGesturesEnabled = true;

  ///是否开启实时定位
  bool _locationEnabled = true;

  AMapController _controller;

  CustomStyleOptions _customStyleOptions = CustomStyleOptions(false);

  double _longitude = 0;
  double _latitude = 0;

  String str = '位置信息';

  ///自定义定位小蓝点
  MyLocationStyleOptions _myLocationStyleOptions = MyLocationStyleOptions(true);

  @override
  void initState() {
    super.initState();

    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      setState(() {
        _locationResult = result;
        print('定位结果是：$_locationResult');
        str = '' + _locationResult['country'] + _locationResult['country'] ==
                null
            ? '|'
            : '' + _locationResult['province'] + _locationResult['province'] ==
                    null
                ? '|'
                : '' + _locationResult['city'] + _locationResult['city'] == null
                    ? '|'
                    : '' +
                                _locationResult['street'] +
                                _locationResult['street'] ==
                            null
                        ? '|'
                        : '';
        _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
            // target: LatLng(39.993306, 116.473004),
            target: LatLng(
                _locationResult['latitude'], _locationResult['longitude']),
            zoom: 18,
            tilt: 30,
            bearing: 30)));
      });
    });

    _startLocation();
  }

  @override
  void dispose() {
    super.dispose();

    ///移除定位监听
    if (null != _locationListener) {
      _locationListener.cancel();
    }

    ///销毁定位
    if (null != _locationPlugin) {
      _locationPlugin.destroy();
    }
  }

  ///设置定位参数
  void _setLocationOption() {
    if (null != _locationPlugin) {
      AMapLocationOption locationOption = new AMapLocationOption();

      ///是否单次定位
      locationOption.onceLocation = false;

      ///是否需要返回逆地理信息
      locationOption.needAddress = true;

      ///逆地理信息的语言类型
      locationOption.geoLanguage = GeoLanguage.DEFAULT;

      locationOption.desiredLocationAccuracyAuthorizationMode =
          AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

      locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

      ///设置Android端连续定位的定位间隔
      locationOption.locationInterval = 2000;

      ///设置Android端的定位模式<br>
      ///可选值：<br>
      ///<li>[AMapLocationMode.Battery_Saving]</li>
      ///<li>[AMapLocationMode.Device_Sensors]</li>
      ///<li>[AMapLocationMode.Hight_Accuracy]</li>
      locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

      ///设置iOS端的定位最小更新距离<br>
      locationOption.distanceFilter = -1;

      ///设置iOS端期望的定位精度
      /// 可选值：<br>
      /// <li>[DesiredAccuracy.Best] 最高精度</li>
      /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
      /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
      /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
      /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
      locationOption.desiredAccuracy = DesiredAccuracy.Best;

      ///设置iOS端是否允许系统暂停定位
      locationOption.pausesLocationUpdatesAutomatically = false;

      ///将定位参数设置给定位插件
      _locationPlugin.setLocationOption(locationOption);
    }
  }

  ///开始定位
  void _startLocation() {
    if (null != _locationPlugin) {
      ///开始定位之前设置定位参数
      _setLocationOption();
      _locationPlugin.startLocation();
      print('_locationListener.isPaused is ${_locationListener.isPaused}');
      // if (_locationListener != null && _locationListener.isPaused) {
      //   _locationListener.resume();
      // }
    }
  }

  ///停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
      print('_locationListener.isPaused is ${_locationListener.isPaused}');

      /// steamListener 你调用了多少次暂停, 要恢复, 也得调用对应次数的恢复才行
      // if (_locationListener != null && !_locationListener.isPaused) {
      //   _locationListener.pause();
      // }
    }
  }

  void _loadCustomData() async {
    if (null == _customStyleOptions) {
      _customStyleOptions = CustomStyleOptions(false);
    }
    ByteData styleByteData = await rootBundle.load('assets/style.data');
    _customStyleOptions.styleData = styleByteData.buffer.asUint8List();
    ByteData styleExtraByteData =
        await rootBundle.load('assets/style_extra.data');
    _customStyleOptions.styleExtraData =
        styleExtraByteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final AMapWidget map = AMapWidget(
      apiKey: ConstConfig.amapApiKeys,
      initialCameraPosition: _kInitialPosition,
      mapType: _mapType,
      trafficEnabled: _trafficEnabled,
      buildingsEnabled: _buildingsEnabled,
      compassEnabled: _compassEnabled,
      labelsEnabled: _labelsEnabled,
      scaleEnabled: _scaleEnabled,
      touchPoiEnabled: _touchPoiEnabled,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      onMapCreated: onMapCreated,
      customStyleOptions: _customStyleOptions,
      myLocationStyleOptions: _myLocationStyleOptions,
      onLocationChanged: _onLocationChanged,
      onCameraMove: _onCameraMove,
      onCameraMoveEnd: _onCameraMoveEnd,
      onTap: _onMapTap,
      onLongPress: _onMapLongPress,
      onPoiTouched: _onMapPoiTouched,
    );

    Widget _mapTypeRadio(String label, MapType radioValue) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          Radio(
            value: radioValue,
            groupValue: _mapType,
            onChanged: (value) {
              setState(() {
                _mapType = value;
              });
            },
          ),
        ],
      );
    }

    final List<Widget> _mapTypeList = [
      // _mapTypeRadio('普通地图', MapType.normal),
      _mapTypeRadio('卫星地图', MapType.satellite),
      _mapTypeRadio('导航地图', MapType.navi),
      _mapTypeRadio('公交地图', MapType.bus),
      _mapTypeRadio('黑夜模式', MapType.night),
    ];

    // 是否开启实时定位
    final List<Widget> _locationOptions = [
      AMapSwitchButton(
        label: Text('实时定位'),
        defaultValue: _locationEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _locationEnabled = value;
            if (!value)
              _stopLocation();
            else
              _startLocation();
          })
        },
      ),
    ];

    //ui控制
    final List<Widget> _uiOptions = [
      AMapSwitchButton(
        label: Text('显示路况'),
        defaultValue: _trafficEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _trafficEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('显示3D建筑物'),
        defaultValue: _buildingsEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _buildingsEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('显示指南针'),
        defaultValue: _compassEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _compassEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('显示地图文字'),
        defaultValue: _labelsEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _labelsEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('显示比例尺'),
        defaultValue: _scaleEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _scaleEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('点击Poi'),
        defaultValue: _touchPoiEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _touchPoiEnabled = value;
          })
        },
      ),
      // AMapSwitchButton(
      //   label: Text('自定义地图'),
      //   defaultValue: _customStyleOptions.enabled,
      //   onSwitchChanged: (value) => {
      //     setState(() {
      //       _customStyleOptions.enabled = value;
      //     })
      //   },
      // ),
    ];

    //手势开关
    final List<Widget> gesturesOptions = [
      AMapSwitchButton(
        label: Text('旋转'),
        defaultValue: _rotateGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _rotateGesturesEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('滑动'),
        defaultValue: _scrollGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _scrollGesturesEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('倾斜'),
        defaultValue: _tiltGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _tiltGesturesEnabled = value;
          })
        },
      ),
      AMapSwitchButton(
        label: Text('缩放'),
        defaultValue: _zoomGesturesEnabled,
        onSwitchChanged: (value) => {
          setState(() {
            _zoomGesturesEnabled = value;
          })
        },
      ),
    ];

    Widget _mapTypeOptions() {
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('地图样式', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: createGridView(_mapTypeList),
            ),
          ],
        ),
      );
    }

    Widget _myLocationStyleContainer() {
      return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Text('定位小蓝点', style: TextStyle(fontWeight: FontWeight.w600)),
            AMapSwitchButton(
              label:
                  Text('定位小蓝点', style: TextStyle(fontWeight: FontWeight.w600)),
              defaultValue: _myLocationStyleOptions.enabled,
              onSwitchChanged: (value) => {
                setState(() {
                  _myLocationStyleOptions.enabled = value;
                })
              },
            ),
          ],
        ),
      );
    }

    Widget _uiOptionsWidget() {
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('UI操作', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: createGridView(_uiOptions),
            ),
          ],
        ),
      );
    }

    Widget _locationWidget() {
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('实时定位', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: createGridView(_locationOptions),
            ),
          ],
        ),
      );
    }

    Widget _gesturesOptiosWeidget() {
      return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('手势控制', style: TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: createGridView(gesturesOptions),
            ),
          ],
        ),
      );
    }

    Widget _optionsItem() {
      return Column(
        children: [
          _mapTypeOptions(),
          // _myLocationStyleContainer(),
          _locationWidget(),
          // Text(str)
          // _uiOptionsWidget(),
          // _gesturesOptiosWeidget(),
          // FlatButton(
          //   child: const Text('移动到当前位置'),
          //   onPressed: _moveCameraToShoukai,
          // ),
        ],
      );
    }

    Widget _mapContent() {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              child: map,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: _optionsItem(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('高德导航'),
        automaticallyImplyLeading: false, // 不显示返回按钮
        // leading: Text(''),// 也可以不显示返回按钮
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: '退出',
            onPressed: () {
              new comfun().removeShared();
              Navigator.popAndPushNamed(context, 'login');
            },
          ),
        ],
      ),
      body: _mapContent(),
    );
  }

  void onMapCreated(AMapController controller) {
    setState(() {
      _controller = controller;
      printApprovalNumber();
    });
  }

  void printApprovalNumber() async {
    String mapContentApprovalNumber =
        await _controller?.getMapContentApprovalNumber();
    String satelliteImageApprovalNumber =
        await _controller?.getSatelliteImageApprovalNumber();
    print('地图审图号（普通地图）: $mapContentApprovalNumber');
    print('地图审图号（卫星地图): $satelliteImageApprovalNumber');
  }

  Widget createGridView(List<Widget> widgets) {
    return GridView.count(
        primary: false,
        physics: new NeverScrollableScrollPhysics(),
        //水平子Widget之间间距
        crossAxisSpacing: 1.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 0.5,
        //一行的Widget数量
        crossAxisCount: 2,
        //宽高比
        childAspectRatio: 8,
        children: widgets,
        shrinkWrap: true);
  }

  //移动到当前位置
  void _moveCameraToShoukai() {
    _startLocation();
  }

  void _onLocationChanged(AMapLocation location) {
    if (null == location) {
      return;
    }
    // print('_onLocationChanged ${location.toJson()}');
  }

  void _onCameraMove(CameraPosition cameraPosition) {
    if (null == cameraPosition) {
      return;
    }
    print('onCameraMove===> ${cameraPosition.toMap()}');
  }

  void _onCameraMoveEnd(CameraPosition cameraPosition) {
    if (null == cameraPosition) {
      return;
    }
    print('_onCameraMoveEnd===> ${cameraPosition.toMap()}');
  }

  void _onMapTap(LatLng latLng) {
    if (null == latLng) {
      return;
    }
    print('_onMapTap===> ${latLng.toJson()}');
  }

  void _onMapLongPress(LatLng latLng) {
    if (null == latLng) {
      return;
    }
    print('_onMapLongPress===> ${latLng.toJson()}');
  }

  void _onMapPoiTouched(AMapPoi poi) {
    if (null == poi) {
      return;
    }
    print('_onMapPoiTouched===> ${poi.toJson()}');
  }
}
