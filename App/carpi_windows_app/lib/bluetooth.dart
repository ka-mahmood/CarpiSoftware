import 'package:quick_blue/models.dart';
import 'package:quick_blue/quick_blue.dart';

const String ARDUINO_DEV_ID = "";

class BluetoothConnection{
  static var ble_data =
  { 'name': '',
    'deviceId': '',
    'manufacturerData': '',
    'rssi': '',
  };

  static var map = Map.fromEntries(ble_data.entries);

  BlueScanResult scan = BlueScanResult.fromMap(map);
  String deviceId = "";
  // singleton development pattern (forces one instance of this, one connect function run)
  static final BluetoothConnection _bluetoothConnection = BluetoothConnection._internal();

  factory BluetoothConnection(){
    return _bluetoothConnection;
  }

  BluetoothConnection._internal(){
    on_startup();
  }


  void on_startup(){
    // listen for advertising devices
    QuickBlue.scanResultStream.listen((scan) {
      print('onScanResult $scan');
    });

    QuickBlue.startScan();

    void _handleConnectionChange(deviceId, BlueConnectionState state) {
      print('_handleConnectionChange $deviceId, $state');
    }
    QuickBlue.setConnectionHandler(_handleConnectionChange);

    if(deviceId == ARDUINO_DEV_ID){
      QuickBlue.connect(deviceId);

      void _handleServiceDiscovery(String deviceId, String serviceId) {
        print('_handleServiceDiscovery $deviceId, $serviceId');
      }
      QuickBlue.setServiceHandler(_handleServiceDiscovery);

      QuickBlue.discoverServices(deviceId);

      // BlueScanResult scanResult; // has device id
    }
    else{
      print("BLE devID Error");
    }
  }




}