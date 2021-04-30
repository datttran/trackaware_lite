import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackaware_lite/models/arrive_db.dart';
import 'package:trackaware_lite/models/depart_db.dart';
import 'package:trackaware_lite/models/location_db.dart';
import 'package:trackaware_lite/models/location_response.dart';
import 'package:trackaware_lite/models/pickup_external_db.dart';
import 'package:trackaware_lite/models/pickup_part_db.dart';
import 'package:trackaware_lite/models/priority_response.dart';
import 'package:trackaware_lite/models/server_db.dart';
import 'package:trackaware_lite/models/settings_db.dart';
import 'package:trackaware_lite/models/tender_external_db.dart';
import 'package:trackaware_lite/models/tender_parts_db.dart';
import 'package:trackaware_lite/models/user_db.dart';
import 'package:trackaware_lite/utils/database_strings.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "trackaware.db");
    return await openDatabase(path, version: 10, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE " +
          DatabaseStrings.USER +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.USER_NAME +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.PASSWORD +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.REMEMBER_ME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.LOGOUT +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.TOKEN +
          " " +
          " TEXT" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.SETTINGS +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.USE_TOOL_NUMBER +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.PICK_ON_TENDER +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.DRIVER_MODE +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.USER_NAME +
          " " +
          " TEXT" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.TENDER_EXTERNAL +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.PRIORITY +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.QUANTITY +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.DEST_LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.ORDER_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.REF_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.PART_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.TRACKING_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.KEEP_SCANNED_VALUES +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.SCAN_TIME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SCANNED +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SYNCED +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.TENDER_PART +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.PRIORITY +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.QUANTITY +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.DEST_LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.ORDER_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.PART_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.TOOL_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.KEEP_SCANNED_VALUES +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.SCAN_TIME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SCANNED +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SYNCED +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.PICKUP_EXTERNAL +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.PICKUP_SITE +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.DELIVERY_SITE +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.TRACKING_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.SCAN_TIME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SYNCED +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_PART +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SCANNED +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_DELIVERED +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.PICKUP_PART +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.DEST_LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.ORDER_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.PART_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.KEEP_SCANNED_VALUES +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.SCAN_TIME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SYNCED +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SCANNED +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_DELIVERED +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.ARRIVE +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.SCAN_TIME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SYNCED +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.DEPART +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.LOCATION +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.TRACKING_NUMBER +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.PACKAGING_COUNT +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.SCAN_TIME +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.IS_SYNCED +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.DISCIPLINE_CONFIG +
          " (" +
          DatabaseStrings.ID_AUTO_INCREMENT +
          DatabaseStrings.KEY_NAME +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.DISPLAY_NAME +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.IS_VISIBLE +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.LOCATION +
          " (" +
          DatabaseStrings.GPS_POLL_INTERVAL +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.GPS_URL +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.GPS_POST_INTERVAL +
          " INTEGER" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.PRIORITY_RESPONSE +
          " (" +
          DatabaseStrings.CODE +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.DESCRIPTION +
          " TEXT" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.LOCATION_RESPONSE +
          " (" +
          DatabaseStrings.CODE +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.LOC +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.ID +
          " " +
          DatabaseStrings.INTEGER +
          DatabaseStrings.DESCRIPTION +
          " TEXT" +
          ")");

      await db.execute("CREATE TABLE " +
          DatabaseStrings.SERVER_CONFIG_RESPONSE +
          " (" +
          DatabaseStrings.BASE_URL +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.USERNAME +
          " " +
          DatabaseStrings.TEXT +
          DatabaseStrings.PASSWORD +
          " TEXT" +
          ")");
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      //Todo - remove conditions before release
      if (oldVersion == 2) {
        await db.execute("CREATE TABLE " +
            DatabaseStrings.PRIORITY_RESPONSE +
            " (" +
            DatabaseStrings.CODE +
            " " +
            DatabaseStrings.TEXT +
            DatabaseStrings.DESCRIPTION +
            " TEXT" +
            ")");

        await db.execute("CREATE TABLE " +
            DatabaseStrings.LOCATION_RESPONSE +
            " (" +
            DatabaseStrings.CODE +
            " " +
            DatabaseStrings.TEXT +
            DatabaseStrings.LOC +
            " " +
            DatabaseStrings.TEXT +
            DatabaseStrings.ID +
            " " +
            DatabaseStrings.INTEGER +
            DatabaseStrings.DESCRIPTION +
            " TEXT" +
            ")");
      }

      if (oldVersion == 3) {
        //alter table _task add column done integer default 0;
        await db.execute("ALTER TABLE " +
            DatabaseStrings.PICKUP_EXTERNAL +
            " ADD COLUMN " +
            DatabaseStrings.IS_SCANNED +
            " INTEGER DEFAULT 0");
      }

      if (oldVersion == 4) {
        //alter table _task add column done integer default 0;
        await db.execute("ALTER TABLE " +
            DatabaseStrings.PICKUP_PART +
            " ADD COLUMN " +
            DatabaseStrings.IS_SCANNED +
            " INTEGER DEFAULT 0");
      }

      if (oldVersion == 5) {
        await db.execute("CREATE TABLE " +
            DatabaseStrings.SERVER_CONFIG_RESPONSE +
            " (" +
            DatabaseStrings.BASE_URL +
            " " +
            DatabaseStrings.TEXT +
            DatabaseStrings.USERNAME +
            " " +
            DatabaseStrings.TEXT +
            DatabaseStrings.PASSWORD +
            " TEXT" +
            ")");
      }

      if (oldVersion == 6) {
        //alter table _task add column done integer default 0;
        await db.execute("ALTER TABLE " +
            DatabaseStrings.TENDER_PART +
            " ADD COLUMN " +
            DatabaseStrings.IS_SCANNED +
            " INTEGER DEFAULT 0");

        await db.execute("ALTER TABLE " +
            DatabaseStrings.TENDER_EXTERNAL +
            " ADD COLUMN " +
            DatabaseStrings.IS_SCANNED +
            " INTEGER DEFAULT 0");
      }

      if (oldVersion == 7) {
        await db.execute("ALTER TABLE " +
            DatabaseStrings.USER +
            " ADD COLUMN " +
            DatabaseStrings.PASSWORD +
            " TEXT");
      }

      if (oldVersion == 8) {
        await db.execute("ALTER TABLE " +
            DatabaseStrings.USER +
            " ADD COLUMN " +
            DatabaseStrings.REMEMBER_ME +
            " INTEGER");
        await db.execute("ALTER TABLE " +
            DatabaseStrings.USER +
            " ADD COLUMN " +
            DatabaseStrings.LOGOUT +
            " INTEGER");
        await db.execute("DROP TABLE " + DatabaseStrings.SETTINGS);
        await db.execute("CREATE TABLE " +
            DatabaseStrings.SETTINGS +
            " (" +
            DatabaseStrings.ID_AUTO_INCREMENT +
            DatabaseStrings.USE_TOOL_NUMBER +
            " " +
            DatabaseStrings.INTEGER +
            DatabaseStrings.DRIVER_MODE +
            " " +
            DatabaseStrings.INTEGER +
            DatabaseStrings.USER_NAME +
            " " +
            " TEXT" +
            ")");
        await db.execute("ALTER TABLE " +
            DatabaseStrings.PICKUP_EXTERNAL +
            " ADD COLUMN " +
            DatabaseStrings.IS_PART +
            " INTEGER DEFAULT 0");
        await db.execute("ALTER TABLE " +
            DatabaseStrings.PICKUP_EXTERNAL +
            " ADD COLUMN " +
            DatabaseStrings.IS_DELIVERED +
            " INTEGER");
        await db.execute("ALTER TABLE " +
            DatabaseStrings.PICKUP_PART +
            " ADD COLUMN " +
            DatabaseStrings.IS_DELIVERED +
            " INTEGER");
      }
      if (oldVersion == 9) {
        await db.execute("ALTER TABLE " +
            DatabaseStrings.SETTINGS +
            " ADD COLUMN " +
            DatabaseStrings.PICK_ON_TENDER +
            " INTEGER");
      }
    });
  }

  deleteDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "trackaware.db");
    await deleteDatabase(path);
  }

  insertUser(User user) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.USER +
            " (" +
            DatabaseStrings.USER_NAME +
            "," +
            DatabaseStrings.PASSWORD +
            "," +
            DatabaseStrings.TOKEN +
            "," +
            DatabaseStrings.REMEMBER_ME +
            "," +
            DatabaseStrings.LOGOUT +
            ")" " VALUES (?,?,?,?,?)",
        [
          user.userName,
          user.password,
          user.token,
          user.rememberMe,
          user.logout
        ]);
    return raw;
  }

  updateUser(User user) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.LOGOUT: user.logout};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.USER, row,
        where: '${DatabaseStrings.USER_NAME} = ?', whereArgs: [user.userName]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.USER));
  }

  deleteUsers() async {
    final db = await database;

    var raw = await db.rawDelete("DELETE FROM " + DatabaseStrings.USER);

    print(raw);
  }

  updateUserRememberMe(User user) async {
    final db = await database;

    // row to update
    Map<String, dynamic> rows = {
      DatabaseStrings.REMEMBER_ME: user.rememberMe,
      DatabaseStrings.LOGOUT: user.logout
    };

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.USER, rows,
        where: '${DatabaseStrings.USER_NAME} = ?', whereArgs: [user.userName]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.USER));
  }

  Future<List<User>> getUser() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.USER_NAME,
      DatabaseStrings.PASSWORD,
      DatabaseStrings.TOKEN,
      DatabaseStrings.REMEMBER_ME,
      DatabaseStrings.LOGOUT
    ];

    var res = await db.query(DatabaseStrings.USER,
        columns: columnsToSelect, where: null, whereArgs: null);
    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromJson(c)).toList() : [];
    return list;
  }

  insertSettings(SettingsResponse settingsResponse) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.insert(
        DatabaseStrings.SETTINGS, settingsResponse.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  Future<List<SettingsResponse>> getSettings(String userName) async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.USER_NAME,
      DatabaseStrings.USE_TOOL_NUMBER,
      DatabaseStrings.PICK_ON_TENDER,
      DatabaseStrings.DRIVER_MODE
    ];

    String whereString = '${DatabaseStrings.USER_NAME} = ?';
    List<dynamic> whereArguments = [userName];

    var res = await db.query(DatabaseStrings.SETTINGS,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments,
        orderBy: DatabaseStrings.ID);
    List<SettingsResponse> list = res.isNotEmpty
        ? res.map((c) => SettingsResponse.fromJson(c)).toList()
        : [];
    return list;
  }

  insertTenderExternal(TenderExternal tenderExternal) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.TENDER_EXTERNAL +
            " (" +
            DatabaseStrings.PRIORITY +
            "," +
            DatabaseStrings.QUANTITY +
            "," +
            DatabaseStrings.LOCATION +
            "," +
            DatabaseStrings.DEST_LOCATION +
            "," +
            DatabaseStrings.ORDER_NUMBER +
            "," +
            DatabaseStrings.REF_NUMBER +
            "," +
            DatabaseStrings.PART_NUMBER +
            "," +
            DatabaseStrings.TRACKING_NUMBER +
            "," +
            DatabaseStrings.KEEP_SCANNED_VALUES +
            "," +
            DatabaseStrings.SCAN_TIME +
            "," +
            DatabaseStrings.IS_SYNCED +
            "," +
            DatabaseStrings.IS_SCANNED +
            ")"
                " VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
        [
          tenderExternal.priority,
          tenderExternal.quantity,
          tenderExternal.location,
          tenderExternal.destination,
          tenderExternal.orderNumber,
          tenderExternal.refNumber,
          tenderExternal.partNumber,
          tenderExternal.trackingNumber,
          tenderExternal.keepScannedValues,
          tenderExternal.scanTime,
          tenderExternal.isSynced,
          tenderExternal.isScanned,
        ]);
    return raw;
  }

  Future<List<TenderExternal>> getAllTenderExternalResults() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.PRIORITY,
      DatabaseStrings.QUANTITY,
      DatabaseStrings.LOCATION,
      DatabaseStrings.DEST_LOCATION,
      DatabaseStrings.ORDER_NUMBER,
      DatabaseStrings.REF_NUMBER,
      DatabaseStrings.PART_NUMBER,
      DatabaseStrings.TRACKING_NUMBER,
      DatabaseStrings.KEEP_SCANNED_VALUES,
      DatabaseStrings.SCAN_TIME,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED
    ];
    String whereString =
        '${DatabaseStrings.IS_SYNCED} = ? AND ${DatabaseStrings.IS_SCANNED} = ?';
    int isSynced = 0;
    int isScanned = 0;
    List<dynamic> whereArguments = [isSynced, isScanned];

    var res = await db.query(DatabaseStrings.TENDER_EXTERNAL,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<TenderExternal> list = res.isNotEmpty
        ? res.map((c) => TenderExternal.fromJson(c)).toList()
        : [];
    return list;
  }

  updateTenderExternal(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SYNCED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.TENDER_EXTERNAL, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.TENDER_EXTERNAL));
  }

  updateTenderPart(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SYNCED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.TENDER_PART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.TENDER_PART));
  }

  updateTenderPartScanStatus(TenderParts tenderParts) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SCANNED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.TENDER_PART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [tenderParts.id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.TENDER_PART));
  }

  updateTenderExternalScanStatus(TenderExternal tenderExternal) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SCANNED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.TENDER_EXTERNAL, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [tenderExternal.id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.TENDER_EXTERNAL));
  }

  insertTenderPart(TenderParts tenderParts) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.TENDER_PART +
            " (" +
            DatabaseStrings.PRIORITY +
            "," +
            DatabaseStrings.QUANTITY +
            "," +
            DatabaseStrings.LOCATION +
            "," +
            DatabaseStrings.DEST_LOCATION +
            "," +
            DatabaseStrings.ORDER_NUMBER +
            "," +
            DatabaseStrings.PART_NUMBER +
            "," +
            DatabaseStrings.TOOL_NUMBER +
            "," +
            DatabaseStrings.KEEP_SCANNED_VALUES +
            "," +
            DatabaseStrings.SCAN_TIME +
            "," +
            DatabaseStrings.IS_SYNCED +
            "," +
            DatabaseStrings.IS_SCANNED +
            ")"
                " VALUES (?,?,?,?,?,?,?,?,?,?,?)",
        [
          tenderParts.priority,
          tenderParts.quantity,
          tenderParts.location,
          tenderParts.destination,
          tenderParts.orderNumber,
          tenderParts.partNumber,
          tenderParts.toolNumber,
          tenderParts.keepScannedValues,
          tenderParts.scanTime,
          tenderParts.isSynced,
          tenderParts.isScanned
        ]);
    return raw;
  }

  removeTenderPart() async {
    final db = await database;
    //insert to the table using the new id
    await db.delete("TenderPart");

  }

  removePickupPart() async {
    final db = await database;
    //insert to the table using the new id
    await db.delete("PickUpPart");

  }


  Future<List<TenderParts>> getAllTenderPartResults() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.PRIORITY,
      DatabaseStrings.QUANTITY,
      DatabaseStrings.LOCATION,
      DatabaseStrings.DEST_LOCATION,
      DatabaseStrings.ORDER_NUMBER,
      DatabaseStrings.PART_NUMBER,
      DatabaseStrings.TOOL_NUMBER,
      DatabaseStrings.KEEP_SCANNED_VALUES,
      DatabaseStrings.SCAN_TIME,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED
    ];
    String whereString =
        '${DatabaseStrings.IS_SYNCED} = ? AND ${DatabaseStrings.IS_SCANNED} = ?';
    int isSynced = 0;
    int isScanned = 0;
    List<dynamic> whereArguments = [isSynced, isScanned];

    var res = await db.query(DatabaseStrings.TENDER_PART,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<TenderParts> list =
        res.isNotEmpty ? res.map((c) => TenderParts.fromJson(c)).toList() : [];
    return list;
  }

  insertPickUpExternal(PickUpExternal pickUpExternal) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.PICKUP_EXTERNAL +
            " (" +
            DatabaseStrings.PICKUP_SITE +
            "," +
            DatabaseStrings.DELIVERY_SITE +
            "," +
            DatabaseStrings.TRACKING_NUMBER +
            "," +
            DatabaseStrings.SCAN_TIME +
            "," +
            DatabaseStrings.IS_SYNCED +
            "," +
            DatabaseStrings.IS_SCANNED +
            "," +
            DatabaseStrings.IS_DELIVERED +
            ")"
                " VALUES (?,?,?,?,?,?,?)",
        [
          pickUpExternal.pickUpSite,
          pickUpExternal.deliverySite,
          pickUpExternal.trackingNumber,
          pickUpExternal.scanTime,
          pickUpExternal.isSynced,
          pickUpExternal.isScanned,
          pickUpExternal.isDelivered
        ]);
    return raw;
  }

  Future<List<PickUpExternal>> getAllPickUpExternalResults() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.PICKUP_SITE,
      DatabaseStrings.DELIVERY_SITE,
      DatabaseStrings.TRACKING_NUMBER,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED,
      DatabaseStrings.IS_DELIVERED,
      DatabaseStrings.IS_PART
    ];
    String whereString = '${DatabaseStrings.IS_SYNCED} = ?';
    int isSynced = 0;
    List<dynamic> whereArguments = [isSynced];

    var res = await db.query(DatabaseStrings.PICKUP_EXTERNAL,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<PickUpExternal> list = res.isNotEmpty
        ? res.map((c) => PickUpExternal.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<PickUpExternal>> getPickUpExternalResults(String location) async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.PICKUP_SITE,
      DatabaseStrings.DELIVERY_SITE,
      DatabaseStrings.TRACKING_NUMBER,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED,
      DatabaseStrings.IS_DELIVERED
    ];

    String whereString =
        '${DatabaseStrings.DELIVERY_SITE} = ? AND ${DatabaseStrings.IS_DELIVERED} = ?';
    List<dynamic> whereArguments = [location, 0];

    var res = await db.query(DatabaseStrings.PICKUP_EXTERNAL,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<PickUpExternal> list = res.isNotEmpty
        ? res.map((c) => PickUpExternal.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<PickUpExternal>> getPickUpExternalScannedResults(
      String location) async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.PICKUP_SITE,
      DatabaseStrings.DELIVERY_SITE,
      DatabaseStrings.TRACKING_NUMBER,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED,
      DatabaseStrings.IS_DELIVERED
    ];

    String whereString =
        '${DatabaseStrings.DELIVERY_SITE} = ? AND ${DatabaseStrings.IS_SCANNED} = ? AND ${DatabaseStrings.IS_DELIVERED} = ?';
    List<dynamic> whereArguments = [location, 1, 0];

    var res = await db.query(DatabaseStrings.PICKUP_EXTERNAL,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<PickUpExternal> list = res.isNotEmpty
        ? res.map((c) => PickUpExternal.fromJson(c)).toList()
        : [];
    return list;
  }

  updatePickUpExternal(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_DELIVERED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_EXTERNAL, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_EXTERNAL));
  }

  Future<int> updatePickUpExternalScanStatus(int id, int scanStatus) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SCANNED: scanStatus};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_EXTERNAL, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_EXTERNAL));
    return updateCount;
  }

  Future<int> updatePickUpPartScanStatus(int id, int scanStatus) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SCANNED: scanStatus};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_PART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_PART));
    return updateCount;
  }

  insertPickUpPart(PickUpPart pickUpPart) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.PICKUP_PART +
            " (" +
            DatabaseStrings.LOCATION +
            "," +
            DatabaseStrings.DEST_LOCATION +
            "," +
            DatabaseStrings.ORDER_NUMBER +
            "," +
            DatabaseStrings.PART_NUMBER +
            "," +
            DatabaseStrings.SCAN_TIME +
            "," +
            DatabaseStrings.KEEP_SCANNED_VALUES +
            "," +
            DatabaseStrings.IS_SYNCED +
            "," +
            DatabaseStrings.IS_SCANNED +
            "," +
            DatabaseStrings.IS_DELIVERED +
            ")"
                " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          pickUpPart.location,
          pickUpPart.destination,
          pickUpPart.orderNumber,
          pickUpPart.partNumber,
          pickUpPart.scanTime,
          pickUpPart.keepScannedValues,
          pickUpPart.isSynced,
          pickUpPart.isScanned,
          pickUpPart.isDelivered
        ]);
    return raw;
  }

  updatePickUpPartFoSync(PickUpPart pickUpPart) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {
      DatabaseStrings.IS_SYNCED: 1,
      DatabaseStrings.LOCATION: pickUpPart.location,
      DatabaseStrings.DEST_LOCATION: pickUpPart.destination,
      DatabaseStrings.ORDER_NUMBER: pickUpPart.orderNumber,
      DatabaseStrings.PART_NUMBER: pickUpPart.partNumber
    };

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_PART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [pickUpPart.id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_PART));
  }

  updatePickUpExternalForSync(PickUpExternal pickUpExternal) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {
      DatabaseStrings.IS_SYNCED: 1,
      DatabaseStrings.PICKUP_SITE: pickUpExternal.pickUpSite,
      DatabaseStrings.DELIVERY_SITE: pickUpExternal.deliverySite,
      DatabaseStrings.TRACKING_NUMBER: pickUpExternal.trackingNumber
    };

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_EXTERNAL, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [pickUpExternal.id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_EXTERNAL));
  }

  Future<List<PickUpPart>> getAllPickUpPartResults() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.LOCATION,
      DatabaseStrings.DEST_LOCATION,
      DatabaseStrings.ORDER_NUMBER,
      DatabaseStrings.PART_NUMBER,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED,
      DatabaseStrings.IS_DELIVERED,
      DatabaseStrings.KEEP_SCANNED_VALUES
    ];
    String whereString = '${DatabaseStrings.IS_SYNCED} = ?';
    int isSynced = 0;
    List<dynamic> whereArguments = [isSynced];

    var res = await db.query(DatabaseStrings.PICKUP_PART,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<PickUpPart> list =
        res.isNotEmpty ? res.map((c) => PickUpPart.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PickUpPart>> getAllPickUpPartResultsByLocation(
      String location) async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.LOCATION,
      DatabaseStrings.DEST_LOCATION,
      DatabaseStrings.ORDER_NUMBER,
      DatabaseStrings.PART_NUMBER,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_SCANNED,
      DatabaseStrings.IS_DELIVERED
    ];
    String whereString =
        '${DatabaseStrings.DEST_LOCATION} = ? AND ${DatabaseStrings.IS_DELIVERED} = ?';
    List<dynamic> whereArguments = [location, 0];

    var res = await db.query(DatabaseStrings.PICKUP_PART,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<PickUpPart> list =
        res.isNotEmpty ? res.map((c) => PickUpPart.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<PickUpPart>> getAllPickUpPartResultsByLocationAndScan(
      String location) async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.LOCATION,
      DatabaseStrings.DEST_LOCATION,
      DatabaseStrings.ORDER_NUMBER,
      DatabaseStrings.PART_NUMBER,
      DatabaseStrings.IS_SYNCED,
      DatabaseStrings.IS_DELIVERED
    ];
    String whereString =
        '${DatabaseStrings.DEST_LOCATION} = ? AND ${DatabaseStrings.IS_SCANNED} = ? AND ${DatabaseStrings.IS_DELIVERED} = ?';
    List<dynamic> whereArguments = [location, 1, 0];

    var res = await db.query(DatabaseStrings.PICKUP_PART,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<PickUpPart> list =
        res.isNotEmpty ? res.map((c) => PickUpPart.fromJson(c)).toList() : [];
    return list;
  }

  updatePickUpPart(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_DELIVERED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_PART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_PART));
  }

  updatePickUpPartSync(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SYNCED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_PART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_PART));
  }

  updatePickUpExternalSync(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SYNCED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.PICKUP_EXTERNAL, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.PICKUP_EXTERNAL));
  }

  insertArrive(Arrive arrive) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.ARRIVE +
            " (" +
            DatabaseStrings.LOCATION +
            "," +
            DatabaseStrings.SCAN_TIME +
            "," +
            DatabaseStrings.IS_SYNCED +
            ")"
                " VALUES (?,?,?)",
        [arrive.location, arrive.scanTime, arrive.isSynced]);
    return raw;
  }

  Future<List<Arrive>> getAllArriveResults() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.LOCATION,
      DatabaseStrings.SCAN_TIME,
      DatabaseStrings.IS_SYNCED
    ];
    String whereString = '${DatabaseStrings.IS_SYNCED} = ?';
    int isSynced = 0;
    List<dynamic> whereArguments = [isSynced];

    var res = await db.query(DatabaseStrings.ARRIVE,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<Arrive> list =
        res.isNotEmpty ? res.map((c) => Arrive.fromJson(c)).toList() : [];
    return list;
  }

  updateArrive(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SYNCED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.ARRIVE, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.ARRIVE));
  }

  insertDepart(Depart depart) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.DEPART +
            " (" +
            DatabaseStrings.LOCATION +
            "," +
            DatabaseStrings.SCAN_TIME +
            "," +
            DatabaseStrings.TRACKING_NUMBER +
            "," +
            DatabaseStrings.PACKAGING_COUNT +
            "," +
            DatabaseStrings.IS_SYNCED +
            ")"
                " VALUES (?,?,?,?,?)",
        [
          depart.location,
          depart.scanTime,
          depart.trackingNo,
          depart.packageCount,
          depart.isSynced
        ]);


    return raw;
  }

  Future<List<Depart>> getAllDepartResults() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.ID,
      DatabaseStrings.LOCATION,
      DatabaseStrings.SCAN_TIME,
      DatabaseStrings.TRACKING_NUMBER,
      DatabaseStrings.PACKAGING_COUNT,
      DatabaseStrings.IS_SYNCED
    ];
    String whereString = '${DatabaseStrings.IS_SYNCED} = ?';
    int isSynced = 0;
    List<dynamic> whereArguments = [isSynced];

    var res = await db.query(DatabaseStrings.DEPART,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<Depart> list =
        res.isNotEmpty ? res.map((c) => Depart.fromJson(c)).toList() : [];
    return list;
  }

  updateDepart(int id) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.IS_SYNCED: 1};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.DEPART, row,
        where: '${DatabaseStrings.ID} = ?', whereArgs: [id]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.ARRIVE));
  }

  insertDisciplineConfig(
      DisciplineConfigResponse disciplineConfigResponse) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.DISCIPLINE_CONFIG +
            " (" +
            DatabaseStrings.KEY_NAME +
            "," +
            DatabaseStrings.DISPLAY_NAME +
            "," +
            DatabaseStrings.IS_VISIBLE +
            ")"
                " VALUES (?,?,?)",
        [
          disciplineConfigResponse.keyName,
          disciplineConfigResponse.displayName,
          disciplineConfigResponse.isVisible
        ]);
    return raw;
  }

  Future<List<DisciplineConfigResponse>> getDisciplineConfig(
      String keyName) async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.KEY_NAME,
      DatabaseStrings.DISPLAY_NAME,
      DatabaseStrings.IS_VISIBLE
    ];
    String whereString = '${DatabaseStrings.KEY_NAME} = ?';
    List<dynamic> whereArguments = [keyName];

    var res = await db.query(DatabaseStrings.DISCIPLINE_CONFIG,
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);
    List<DisciplineConfigResponse> list = res.isNotEmpty
        ? res.map((c) => DisciplineConfigResponse.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<DisciplineConfigResponse>> fetchAllDisciplineConfig() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.KEY_NAME,
      DatabaseStrings.DISPLAY_NAME,
      DatabaseStrings.IS_VISIBLE
    ];

    var res = await db.query(DatabaseStrings.DISCIPLINE_CONFIG,
        columns: columnsToSelect, where: null, whereArgs: null);
    List<DisciplineConfigResponse> list = res.isNotEmpty
        ? res.map((c) => DisciplineConfigResponse.fromJson(c)).toList()
        : [];
    return list;
  }

  updateDiscplineConfig(String keyName, String displayName) async {
    final db = await database;

    // row to update
    Map<String, dynamic> row = {DatabaseStrings.DISPLAY_NAME: displayName};

    // do the update and get the number of affected rows
    int updateCount = await db.update(DatabaseStrings.DISCIPLINE_CONFIG, row,
        where: '${DatabaseStrings.KEY_NAME} = ?', whereArgs: [keyName]);

    print("Update Count : $updateCount");
    // show the results: print all rows in the db
    print(await db.query(DatabaseStrings.DISCIPLINE_CONFIG));
  }

  insertLocation(Location location) async {
    final db = await database;

    // deleteLocationValues();
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.LOCATION +
            " (" +
            DatabaseStrings.GPS_POLL_INTERVAL +
            "," +
            DatabaseStrings.GPS_POST_INTERVAL +
            "," +
            DatabaseStrings.GPS_URL +
            ")"
                " VALUES (?,?,?)",
        [location.gpsPollInterval, location.gpsPostInterval, location.gpsUrl]);
    return raw;
  }

  deleteLocationValues() async {
    final db = await database;

    var raw = await db.rawDelete("DELETE FROM " + DatabaseStrings.LOCATION);

    print(raw);
  }

  Future<List<Location>> getLocation() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.GPS_POLL_INTERVAL,
      DatabaseStrings.GPS_POST_INTERVAL,
      DatabaseStrings.GPS_URL
    ];

    var res = await db.query(DatabaseStrings.LOCATION,
        columns: columnsToSelect, where: null, whereArgs: null);
    List<Location> list =
        res.isNotEmpty ? res.map((c) => Location.fromJson(c)).toList() : [];
    return list;
  }

  deleteOnLogout() async {
    final db = await database;

    var rawUser = await db.rawDelete("DELETE FROM " + DatabaseStrings.USER);
    print(rawUser);
    var rawSettings =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.SETTINGS);
    print(rawSettings);
    var rawTenderExternal =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.TENDER_EXTERNAL);
    print(rawTenderExternal);
    var rawTenderPart =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.TENDER_PART);
    print(rawTenderPart);
    var rawPickUpExternal =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.PICKUP_EXTERNAL);
    print(rawPickUpExternal);
    var rawPickUpPart =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.PICKUP_PART);
    print(rawPickUpPart);
    var rawArrive = await db.rawDelete("DELETE FROM " + DatabaseStrings.ARRIVE);
    print(rawArrive);
    var rawDepart = await db.rawDelete("DELETE FROM " + DatabaseStrings.DEPART);
    print(rawDepart);
    var rawDisciplineConfig =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.DISCIPLINE_CONFIG);
    print(rawDisciplineConfig);
    var rawLocation =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.LOCATION);
    print(rawLocation);
    var rawPriority =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.PRIORITY_RESPONSE);
    print(rawPriority);
    var rawLocationResponse =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.LOCATION_RESPONSE);
    print(rawLocationResponse);
    var rawServerConfigResponse = await db
        .rawDelete("DELETE FROM " + DatabaseStrings.SERVER_CONFIG_RESPONSE);
    print(rawServerConfigResponse);
  }

  insertPriorityResponse(PriorityResponse priorityResponse) async {
    final db = await database;

    // deleteLocationValues();
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.PRIORITY_RESPONSE +
            " (" +
            DatabaseStrings.CODE +
            "," +
            DatabaseStrings.DESCRIPTION +
            ")"
                " VALUES (?,?)",
        [priorityResponse.code, priorityResponse.description]);
    return raw;
  }

  deletePriorityResponse() async {
    final db = await database;

    var raw =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.PRIORITY_RESPONSE);

    print(raw);
  }

  Future<List<PriorityResponse>> getPriorityResponse() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.CODE,
      DatabaseStrings.DESCRIPTION
    ];

    var res = await db.query(DatabaseStrings.PRIORITY_RESPONSE,
        columns: columnsToSelect, where: null, whereArgs: null);
    List<PriorityResponse> list = res.isNotEmpty
        ? res.map((c) => PriorityResponse.fromJson(c)).toList()
        : [];
    return list;
  }

  insertLocationResponse(LocationResponse locationResponse) async {
    final db = await database;

    // deleteLocationValues();
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.LOCATION_RESPONSE +
            " (" +
            DatabaseStrings.CODE +
            "," +
            DatabaseStrings.DESCRIPTION +
            "," +
            DatabaseStrings.ID +
            "," +
            DatabaseStrings.LOC +
            ")"
                " VALUES (?,?,?,?)",
        [
          locationResponse.code,
          locationResponse.description,
          locationResponse.id,
          locationResponse.loc
        ]);
    return raw;
  }

  deleteLocationResponse() async {
    final db = await database;

    var raw =
        await db.rawDelete("DELETE FROM " + DatabaseStrings.LOCATION_RESPONSE);

    print(raw);
  }

  Future<List<LocationResponse>> getLocationResponse() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.CODE,
      DatabaseStrings.DESCRIPTION,
      DatabaseStrings.ID,
      DatabaseStrings.LOC
    ];

    var res = await db.query(DatabaseStrings.LOCATION_RESPONSE,
        columns: columnsToSelect, where: null, whereArgs: null);
    List<LocationResponse> list = res.isNotEmpty
        ? res.map((c) => LocationResponse.fromJson(c)).toList()
        : [];
    return list;
  }

  insertServerConfig(ServerConfigResponse serverConfigResponse) async {
    final db = await database;

    // deleteLocationValues();
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT INTO " +
            DatabaseStrings.SERVER_CONFIG_RESPONSE +
            " (" +
            DatabaseStrings.BASE_URL +
            "," +
            DatabaseStrings.USERNAME +
            "," +
            DatabaseStrings.PASSWORD +
            ")"
                " VALUES (?,?,?)",
        [
          serverConfigResponse.baseUrl,
          serverConfigResponse.userName,
          serverConfigResponse.password
        ]);
    return raw;
  }

  deleteServerConfigValues() async {
    final db = await database;

    var raw = await db
        .rawDelete("DELETE FROM " + DatabaseStrings.SERVER_CONFIG_RESPONSE);

    print(raw);
  }

  Future<List<ServerConfigResponse>> getServerConfigValues() async {
    final db = await database;

    // get single row
    List<String> columnsToSelect = [
      DatabaseStrings.BASE_URL,
      DatabaseStrings.USERNAME,
      DatabaseStrings.PASSWORD
    ];

    var res = await db.query(DatabaseStrings.SERVER_CONFIG_RESPONSE,
        columns: columnsToSelect, where: null, whereArgs: null);
    List<ServerConfigResponse> list = res.isNotEmpty
        ? res.map((c) => ServerConfigResponse.fromJson(c)).toList()
        : [];
    return list;
  }
}
