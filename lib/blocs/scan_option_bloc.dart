import 'package:bloc/bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:trackaware_lite/events/scan_option_event.dart';
import 'package:trackaware_lite/states/scan_option_state.dart';
import 'package:trackaware_lite/utils/colorstrings.dart';

class ScanOptionBloc extends Bloc<ScanOptionEvent, ScanOptionState> {
  @override
  ScanOptionState get initialState => ScanOptionInitial();

  @override
  Stream<ScanOptionState> mapEventToState(ScanOptionEvent event) async* {
    if (event is OrderNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield OrderNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

    if (event is PartNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield PartNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

    if (event is ToolNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield ToolNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

    if (event is TrackingNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield TrackingNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }

    if (event is RefNumberScanEvent) {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          ColorStrings.BORDER, "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != null &&
          barcodeScanRes.isNotEmpty &&
          barcodeScanRes != "-1") {
        yield RefNumberScanSuccess(barCode: barcodeScanRes);
      } else {
        yield ScanOptionFailure(error: "Scan failed!");
      }
    }
  }
}
