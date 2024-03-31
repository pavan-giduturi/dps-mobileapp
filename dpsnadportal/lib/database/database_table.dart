//import 'dart:ffi';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/utils/utils.dart';

import '../apiservice/restapi.dart';
import '../helpers/utilities.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

/* Userdetails Table and columns */
  String userdetailsTable = 'userdetails';
  String employeeID = 'employeeID';
  String firstNameCol = 'firstName';
  String lastNameCol = 'lastName';
  String employeeCodeCol = 'employeeCode';
  String contactNoCol = 'contactNo';
  String employeeTypeCol = 'employeeType';
  String userIDCol = 'userID';
  String emailIDCol = 'emailID';
  String imageBase64Col = 'imageBase64';

  /*Employee table and Columns */
  String employeeTable = 'employee';
  String employeeIDCol = 'employeeID';
  String employeeNumberCol = 'employeeNumber';
  String employeeNameCol = 'employeeName';
  String employeeNamewithNumberCol = 'employeeNamewithNumber';

  /*Flight table and Columns */
  String flightTable = 'flight';
  String idCol = 'id';
  String flightNumberCol = 'flightNumber';
  String destinationFromCol = 'destinationFrom';
  String sectorCol = 'sector';
  String flightDateandTimeCol = 'flightDateandTime';
  String aircraftTypeCol = 'aircraftType';
  String destinationToCol = 'destinationTo';

  /* Check List table and Columns */
  String checkListTable = 'checkListTable';
  String checkListIdCol = 'checkListId';
  String checkListNameCol = 'checkListName';
  String itemIDCol = 'itemID';
  String itemNameCol = 'itemName';

  /*CCAA Summary*/
  String auditSummaryTable = 'auditSummary';
  String cabicrewNoCol = 'cabicrewNo';
  String auditIDCol = 'auditID';
  String auditStatusCol = 'auditStatus';
  String auditDoneByCol = 'auditDoneBy';
  String flightScheduleIDCol = 'flightScheduleID';
  String famTypeIDCol = 'famTypeID';
  String famTypeNameCol = 'famTypeName';
  String famStatusIDCol = 'famStatusID';
  String famStatusNameCol = 'famStatusName';
  String summaryItemIDCol = 'itemID';
  String summaryItemNameCol = 'itemName';
  String itemDataIDCol = 'itemDataID';
  String famOneCol = 'famOne';
  String famTwoCol = 'famTwo';
  String famThreeCol = 'famThree';
  String famFourCol = 'famFour';
  String famFiveCol = 'famFive';
  String checkFlightOneCol = 'checkFlightOne';
  String checkFlightTwoCol = 'checkFlightTwo';

  String AuditCheckListTable = "auditCheckList";
  String CCAIDCol = "CCAID";
  String CabicrewNoCol = "CabicrewNo";
  String AuditDonebyCol = "AuditDoneby";
  String StatusidCol = "Statusid";
  String FlightSceduleIDCol = "FlightSceduleID";
  String FAMTypeCol = "FAMType";
  String FAMStatusCol = "FAMStatus";
  String UserIDCol = "UserID";
  String CommentsCol = "Comments";
  String ObjectIDCol = "ObjectID";
  String ChecklistIDCol = "ChecklistID";
  String ChecklistItemIDCol = "checklistItemID";
  String ChecklistItemDataIDCol = "ChecklistItemDataID";
  String CheckEmpIDCol = "EmpID";
  String CommentsSubCol = "SubComments";

  /*GOPA Stations Configuration*/
  String GOPAStationConfTable = 'GOPAstation';
  String stationIdConfCol = 'id';
  String stationCodeConfCol = 'stationID';
  String stationNameConfCol = 'stationName';
  String stationCodeCol = 'stationCode';
  String apmCol = 'apm';
  String rmCol = 'rm';
  String hoCol = 'ho';
  String apmmailid = 'apmmailid';
  String rmmailid = 'rmmailid';
  String homailid = 'homailid';

  String SearchCAPATable = 'SearchCAPA';
  String capaMainDataoverviewTable = 'capaMainDataoverview';
  String capaWorkflowDataoverviewTable = 'capaWorkflowDataoverview';

  String capaNumber = 'capaNumber';
  String CAPAID = 'CAPAID';
  String statusID = 'statusID';
  String rejectionComments = 'rejectionComments';
  String level = 'level';
  String capaCreationDate = 'capaCreationDate';
  String comments = 'comments';

  String IsGOPAClosedbasedonStationTable = 'IsGOPAClosedbasedonStation';
  String StationID = 'StationID';
  String capaFullNumbers = 'capaFullNumbers';

  String IsGOPAClosedbasedGHTable = 'IsGOPAClosedbasedGH';
  String EMPNO = 'EMPNO';
  String GHID = 'GHID';
  String AuditType = 'AuditType';

  String MOAirlinesDataTable = 'MOAirlinesData';
  String GOPANumber = 'GOPANumber';

  /*GOPA Ground Handler Configuration */
  String GOPAGroundHandlerConfTable = 'GOPAgroundHandler';
  String ghIdConfCol = 'id';
  String ghCodeConfCol = 'grounhandlerId';
  String ghNameConfCol = 'groundhandlerName';

  /*GOPA Airline Configuration */
  String GOPAAirlineConfTable = 'GOPAairline';
  String airlineIdConfCol = 'id';
  String airlineCodeConfCol = 'airlineCode';
  String airlineNameConfCol = 'airlineName';

  /*GetAssignedCAPA Configuration */
  String AssignedCAPATable = 'AssignedCAPA';
  String ACidCol = 'id';
  String ACpluginIDCol = 'pluginID';
  String ACfeatureIDCol = 'featureID';
  String ACcapaFeatureIDCol = 'capaFeatureID';
  String ACnumberCol = 'number';
  String ACobjectNumberCol = 'objectNumber';
  String ACauditQuestionIDCol = 'auditQuestionID';
  String ACcapaTypeCol = 'capaType';
  String ACcapaTitleCol = 'capaTitle';
  String ACcapaDetailsCol = 'capaDetails';
  String ACcapaCommentsCol = 'capaComments';
  String ACsubmittedDateCol = 'submittedDate';
  String submitDate = 'submitDate';
  String ACdueDateCol = 'dueDate';
  String ACpriorityCol = 'priority';
  String ACstatusCol = 'status';
  String ACassignedFromCol = 'assignedFrom';
  String ACassignedToCol = 'assignedTo';
  String LoginEMPNumber = 'LoginEMPNumber';

  /*CAPAModules Configuration */
  String CAPAModulesTable = 'CAPAModules';
  String CmoduleIDCol = 'moduleID';
  String CmoduleNameCol = 'moduleName';

  /*Scope  of audit Configuration */
  String ScopeOfAuditTable = 'ScopeOfAudit';
  String scopeRatingIdCol = 'id';
  String scopeRatingNameCol = 'name';
  String scopeDropdownIdCol = 'dropdownID';
  String scopeDropdownNameCol = 'dropdownName';
  String scopeInterlinksCol = 'interlinks';
  String scopeNameCol = 'scopeName';

  /*Menu Configuration */
  String PrimaryMenuTable = 'PrimaryMenu';
  String pMenuIDCol = 'pMenuID';
  String pPluginIDCol = 'pPluginID';
  String pDisplayNameCol = 'pDisplayName';
  String pModuleIDCol = 'pModuleID';

  String secondryMenuTable = 'SecondryMenu';
  String fMenuIDCol = 'fMenuID';
  String fPluginIDCol = 'fPluginID';
  String fFeatureIDCol = 'fFeatureID';
  String fDisplayNameCol = 'fDisplayName';

  /* checklistRatingcommn Configuration */
  String RatingcommonTable = 'Ratingcommon';
  /* checklistRatingIDbased Configuration */
  String RatingIDbasedTable = 'RatingIDbased';
  String ratingIDCol = 'ratingID';
  String ratingNameCol = 'ratingName';
  String ratingchecklistIDCol = 'checklistID';
  String ratingsubChecklistIDCol = 'subChecklistID';

/*GOPA Check List questionary*/
  String GOPAcheckListQstnTable = "GOPAcheckListQuestions";
  String checkListIDQstnCol = "checkListID";
  String checkListNameQstnCol = "checkListName";
  String itemIDQstnCol = "itemID";
  String itemNameQstnCol = "itemName";
  /*new column*/
  // String subCheckListIDQstnCol= "subchecklistID";
  // String subCheckListNameQstnCol= "subchecklistname";
  // String checkListOrderQstnCol= "checklistorder";
  // String subChecklistOrderQstnCol= "subChecklistorder";

  // GOPA Draft Audits
  String GOPADraftAuditsTable = 'GOPADraftAudits';
  String GOPASearchTrackAuditsTable = 'GOPASearchTrackAudits';
  String GopaOverviewDetailsTable = 'GopaOverviewDetails';
  String stationName = 'stationName';
  String HoNumber = 'HoNumber';
  String auditID = 'auditID';
  String gghName = 'gghName';
  String groundHandler = 'groundHandler';
  String auditDate = 'auditDate';
  String auditDoneby = 'auditDoneby';
  String airlineIDs = 'airlineIDs';
  String statusName = 'statusName';
  String statusid = 'statusid';
  String auditNumber = 'auditNumber';
  String restartOperations = 'restartOperations';
  String allAirlinesSameServiceProvider = 'allAirlinesSameServiceProvider';
  String isagocertified = 'isagocertified';
  String gghid = 'gghid';
  String stationID = 'stationID';
  String submittedBy = 'submittedBy';
  String userID = 'userID';
  String msg = 'msg';
  String submittedDate = 'submittedDate';
  String restartoperations = 'restartoperations';
  String sameserviceprovider = 'sameserviceprovider';
  String gopaNumber = 'gopaNumber';
  String pBhandling = 'pBhandling';
  String ramphandling = 'ramphandling';
  String cargohandling = 'cargohandling';
  String deicingoperations = 'deicingoperations';
  String aircraftMarshalling = 'aircraftMarshalling';
  String loadcontrol = 'loadcontrol';
  String aircraftmovement = 'aircraftmovement';
  String headsetcommunication = 'headsetcommunication';
  String passengerbridge = 'passengerbridge';
  String isago = 'isago';
  String duedate = 'duedate';
  String pBhandlingID = 'pBhandlingID';
  String ramphandlingID = 'ramphandlingID';
  String cargohandlingID = 'cargohandlingID';
  String deicingoperationsID = 'deicingoperationsID';
  String aircraftMarshallingID = 'aircraftMarshallingID';
  String loadcontrolID = 'loadcontrolID';
  String aircraftmovementID = 'aircraftmovementID';
  String headsetcommunicationID = 'headsetcommunicationID';
  String passengerbridgeID = 'passengerbridgeID';
  String isagoid = 'isagoid';
  String restartoperationsID = 'restartoperationsID';
  String sameserviceprovideriD = 'sameserviceproviderID';
  String duedateID = 'duedateID';
  String reason = 'reason';
  String pBhandlingServiceProvider = 'pBhandlingServiceProvider';
  String ramphandlingServiceProvider = 'ramphandlingServiceProvider';
  String cargohandlingServiceProvider = 'cargohandlingServiceProvider';
  String deicingoperationsServiceProvider = 'deicingoperationsServiceProvider';
  String aircraftMarshallingServiceProvider =
      'aircraftMarshallingServiceProvider';
  String loadcontrolServiceProvider = 'loadcontrolServiceProvider';
  String aircraftmovementServiceProvider = 'aircraftmovementServiceProvider';
  String headsetcommunicationServiceProvider =
      'headsetcommunicationServiceProvider';
  String passengerbridgeServiceProvider = 'passengerbridgeServiceProvider';

  //GOPA Check List
  String GOPAcheckListTable = 'GOPAcheckList';
  String chkNameCol = 'chkName';
  String chkIdCol = 'chkId';
  String uploadFileNameCol = 'uploadFileName';
  String followUpCol = 'followUp';
  String ratingStatusCol = 'ratingStatus';
  String statusIdGOPACol = 'Statusid';
  String airLineIdCol = 'id';
  String subHeadingCol = 'subHeading';
  String airlineIdsChkCol = 'airlineIds';
  String airlineCodeCol = 'airlineCode';
  String auditIdChkCol = 'auditID';
  String stationIdCol = 'stationId';
  String stationAirportCol = 'stationAirport';
  String groundHandlerIdCol = 'groundHandlerId';
  String groundHandlerCol = 'groundHandler';
  String auditDateCol = 'auditDate';
  String conductedIdCol = 'conductedId';
  String conductAuditCol = 'conductAudit';
  String auditNumberCol = 'auditNumber';
  String GOPAcheckListUserIdCol = 'userId';
  //String  GOPAcheckListUserIdCol = 'userId';
  String isSynchedCol = 'isSynched';
  String isDeletedCol = 'isDeleted';

  //GOPA Attachment Table
  String GOPAattachmentTable = "GOPAattachment";
  String GOPAatchmntAditIdCol = "AuditID";
  String GOPAAttachmentIDCol = "AttachmentID";
  String GOPAAttachmentAttachedByCol = "AttachedBy";
  String GOPAAttachmentFileNameCol = "FileName";
  String GOPAAttachmentAttachedDateCol = "AttachedDate";
  String GOPAAttachmentFileTypeCol = "FileType";
  String GOPAAttachmentPathCol = "Path";
  String GOPAAttachmentImageBase64Col = "ImageBase64";

  // Annexure Module Table and Columns

  /*Gopa Number table and Columns */
  String GopaNumberTable = 'gopaNumber';
  String gopaNumberCol = 'gopaNumber';
  String gopaNumberwithGGHCol = 'gopaNumberwithGGH';

  /* Annexure Details tabble and Columns */

  String AnnexureDraftAuditsTable = 'AnnexureDraftAudits';
  String AnnexureSearchTrackAuditsTable = 'AnnexureSearchTrackAudits';
  String annexureIDCol = 'annexureID';
  String annexureNumberCol = 'annexureNumber';
  String stationNameCol = 'stationName';
  String airlineNameCol = 'airlineName';
  String statusCol = 'status';
  String msgCol = 'msg';
  String anxrAuditDateCol = 'auditDate';
  String anxrAuditDoneByCol = 'auditDoneBy';

  /* Annexure Checklist tabble and Columns */

  String AnnexureCheckListTable = 'AnnexureCheckList';
  String GOPACheckListDataTable = 'GOPACheckListData';
  String checkListIDCol = 'checkListID';
  String subchecklistIDCol = 'subchecklistID';
  String subchecklistnameCol = 'subchecklistname';
  String checklistorderCol = 'checklistorder';
  String subChecklistorderCol = 'subChecklistorder';

  /* Annexure Overview */

  String AnnexureOverviewDetailsTable = 'AnnexureOverviewDetails';
  String stationIDCol = 'stationID';
  String annexuresIDCol = 'annexuresID';
  String flightDateCol = 'flightDate';
  String flightNoCol = 'flightNo';
  String marshallingaircraftdonebyCol = 'marshallingaircraftdoneby';
  String marshallingaircraftdonebyId = 'marshallingaircraftdonebyId';
  String statusidCol = 'statusid';
  String statusNameCol = 'statusName';
  String airlineIDCol = 'airlineID';
  String submittedByCol = 'submittedBy';
  String annexuresNumberCol = 'annexuresNumber';
  String previousAuditFlightNoCol = 'previousAuditFlightNo';
  String previousAuditDateCol = 'previousAuditDate';
  String passengerHandlingstaffCol = 'passengerHandlingstaff';
  String loadControlstaffCol = 'loadControlstaff';
  String rampHandlingstaffCol = 'rampHandlingstaff';
  String equipmentOperatorsCol = 'equipmentOperators';
  String passengerBoardingBridgeCol = 'passengerBoardingBridge';
  String passengerBoardingBridgeId = 'passengerBoardingBridgeId';

  /* Annexure Overview Checklist*/

  String AnnexureOverviewChecklistTable = 'AnnexureOverviewChecklist';
  String GOPAOverviewChecklistTable = 'GOPAOverviewChecklist';
  String objectIDCol = 'objectID';
  String checklistIDCol = 'checklistID';
  String checklistItemIDCol = 'checklistItemID';
  String checklistItemDataIDCol = 'checklistItemDataID';
  String empIDCol = 'empID';
  String commentsCol = 'comments';
  String attachmentNameCol = 'attachmentName';
  String imagename = 'imagename';
  String attachmentBaseImgCol = 'attachmentBaseImg';
  String attachfileManadatory = 'attachfileManadatory';

  ////ANNEXURE NEW AIRLINES ////////
  /*GOPA Airline Configuration */
  String annexureAAirlineConfTable = 'annexureairliness';
  String annexureairlineIdConfCol = 'id';
  String annexureairlineCodeConfCol = 'airlineCode';
  String annexureairlineNameConfCol = 'airlineName';

  /*CAPA Status */
  String CapaStatusTable = 'CapaStatus';
  String capaStatusId = 'statusId';
  String statusId = 'id';
  String statusname = 'status';
  String flag = 'flag';

  /*GetMOMasterData Status */
  String MOMasterDataTable = 'MOMasterData';
  String GOPANo = 'GOPANo';
  String moIntrelinks = 'moIntrelinks';
  String loadControl = 'loadControl';
  String passengerBoardingBridge = 'passengerBoardingBridge';
  String Type = 'Type';
  String Sync = 'Sync';

  String IsMOexistsTable = 'IsMOexists';
  String GOPAID = 'GOPAID';
  String AirlineID = 'AirlineID';
  String moExist = 'moExist';
  String annexuresExitID = 'annexuresExitID';

  String PreviousAnnexuresFlighNoandDateTable =
      'PreviousAnnexuresFlighNoandDate';
  String SationID = 'SationID';
  String flightNo = 'flightNo';
  String flightDate = 'flightDate';

  String GetEMPRoleTable = 'GetEMPRole';
  String EMPNo = 'EMPNo';
  String role = 'role';

  String GGPANumberforMOTable = 'GOPANumberforMO';
  String AuditerNo = 'AuditerNo';
  String gopano = 'gopano';

  String SaveFileAttachmentforChecklistTable = 'SaveFileAttachmentforChecklist';
  String PluginID = 'PluginID';
  String AuditID = 'AuditID';
  String AuditNumber = 'AuditNumber';
  String featurID = 'featurID';
  String ChecklistID = 'ChecklistID';
  String ChecklistItemID = 'ChecklistItemID';
  String SubchecklistID = 'SubchecklistID';
  String FilePath = 'FilePath';
  String FileName = 'FileName';
  String AttachedBy = 'AttachedBy';
  String ImageBase64 = 'ImageBase64';

  String CapaAttachmentTable = 'CapaAttachment';
  String attachmentID = 'attachmentID';
  String attachedBy = 'attachedBy';
  String fileName = 'fileName';
  String attachedDate = 'attachedDate';
  String fileType = 'fileType';
  String path = 'path';
  String imageBase64 = 'imageBase64';
  String imageDownlaodpath = 'imageDownlaodpath';

  String AnnexuresOverviewDataforgopaTable = 'AnnexuresOverviewDataforgopa';
  String id = 'id';
  String annexureID = 'annexureID';
  String airlines = 'airlines';
  String auditDoneBy = 'auditDoneBy';
  String moFullnumber = 'moFullnumber';
  String auditId = 'auditId';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper
  List airlineList = [];

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory? directory = await getApplicationDocumentsDirectory();
    // Directory? directory = await getExternalStorageDirectory();

    print("directory------");
    print(directory);
    print(directory!.path + "/");
    Utilities.attachmentFilePathLocal = directory!.path + "/";

    if (Directory("${directory!.path}/AACC").existsSync()) {
      Directory("${directory.path}/AACC").createSync(recursive: true);
    }

    String path = directory.path + 'aacc.db';

    // Open/create the database at a given path
    var aaccDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return aaccDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    // Search Status Table
    await db.execute(
        "create table $SaveFileAttachmentforChecklistTable ($PluginID TEXT,$AuditID TEXT,$AuditNumber TEXT,$featurID TEXT,$ChecklistID TEXT,$ChecklistItemID TEXT,$SubchecklistID TEXT,$FileName TEXT,$FilePath TEXT,$AttachedBy TEXT,$ImageBase64 TEXT,$flag TEXT)");

    // Search Status Table
    await db.execute(
        "create table $MOMasterDataTable ($GOPANo TEXT,$moIntrelinks TEXT,$loadControl TEXT,$passengerBoardingBridge TEXT)");

    // Search Status Table
    await db.execute(
        "create table $AnnexuresOverviewDataforgopaTable ($auditId TEXT,$id TEXT,$annexureID TEXT,$airlines TEXT,$auditDoneBy TEXT,$auditDate TEXT,$moFullnumber TEXT,$statusName TEXT,$statusID TEXT)");

    // Search Status Table
    await db.execute(
        "create table $CapaStatusTable ($capaStatusId TEXT,$statusId TEXT,$statusname TEXT,$flag TEXT)");

    // Search CAPA Table
    await db.execute(
        "create table $SearchCAPATable ($ACidCol TEXT,$ACpluginIDCol TEXT,$ACfeatureIDCol TEXT, $ACcapaFeatureIDCol TEXT,$ACnumberCol TEXT,$ACobjectNumberCol TEXT,$ACassignedToCol TEXT,$ACassignedFromCol TEXT,$ACstatusCol TEXT,$ACpriorityCol TEXT,$ACdueDateCol TEXT,$ACsubmittedDateCol TEXT,$ACcapaCommentsCol TEXT,$ACcapaDetailsCol TEXT,$ACcapaTitleCol TEXT,$ACcapaTypeCol TEXT,$ACauditQuestionIDCol TEXT,$LoginEMPNumber TEXT,$Sync TEXT)");

    // CAPA Overview Table
    await db.execute(
        "create table $capaMainDataoverviewTable ($CAPAID TEXT,$capaNumber TEXT,$ACnumberCol TEXT,$ACauditQuestionIDCol TEXT,$ACcapaTypeCol TEXT,$ACcapaTitleCol TEXT,$ACcapaDetailsCol TEXT,$ACcapaCommentsCol TEXT,$ACsubmittedDateCol TEXT,$submitDate TEXT,$ACdueDateCol TEXT,$ACpriorityCol TEXT,$statusID TEXT,$ACstatusCol TEXT,$ACassignedFromCol TEXT,$ACassignedToCol TEXT,$rejectionComments TEXT,$level TEXT)");

    // CAPA Overview Workflow Details Table
    await db.execute(
        "create table $capaWorkflowDataoverviewTable ($ACassignedFromCol TEXT,$ACassignedToCol TEXT,$ACstatusCol TEXT,$statusID TEXT,$ACcapaDetailsCol TEXT,$ACcapaCommentsCol TEXT,$capaCreationDate TEXT,$rejectionComments TEXT,$capaNumber TEXT,$CAPAID TEXT,$comments TEXT,$attachedBy TEXT,$fileName TEXT,$imageBase64 TEXT,$FilePath TEXT,$Sync TEXT)");

    // CAPA Overview Workflow Details Table
    await db.execute(
        "create table $CapaAttachmentTable ($attachmentID TEXT,$attachedBy TEXT,$fileName TEXT,$attachedDate TEXT,$fileType TEXT,$path TEXT,$imageBase64 TEXT,$imageDownlaodpath TEXT,$capaNumber TEXT,$flag TEXT)");

    //User Details Table Creation
    await db.execute(
        "create table $userdetailsTable ($employeeID TEXT,$firstNameCol TEXT,$lastNameCol TEXT,"
        "$employeeCodeCol TEXT,$contactNoCol TEXT,$employeeTypeCol TEXT,$userIDCol TEXT,$emailIDCol TEXT,$imageBase64Col TEXT)");

    //checkListTable Table Creation
    await db.execute(
        "create table $employeeTable ($employeeIDCol TEXT,$employeeNumberCol TEXT,$employeeNameCol TEXT,"
        "$employeeNamewithNumberCol TEXT)");

    //Flight Table Creation
    await db.execute(
        "create table $flightTable ($idCol TEXT,$flightNumberCol TEXT, $destinationFromCol TEXT,"
        "$sectorCol TEXT, $flightDateandTimeCol TEXT, $aircraftTypeCol TEXT, $destinationToCol TEXT)");

    //Audit Summary Table creation
    await db.execute(
        "create table $auditSummaryTable ($cabicrewNoCol TEXT,$auditIDCol TEXT,$auditStatusCol TEXT,$auditDoneByCol TEXT,$flightScheduleIDCol TEXT, $famTypeIDCol TEXT,"
        "$famTypeNameCol TEXT,$famStatusIDCol TEXT,$famStatusNameCol TEXT,$checkListIdCol TEXT ,$checkListNameCol TEXT,$summaryItemIDCol TEXT,$summaryItemNameCol TEXT ,$itemDataIDCol TEXT,$famOneCol TEXT,"
        "$famTwoCol TEXT,$famThreeCol TEXT,$famFourCol TEXT,$famFiveCol TEXT,$checkFlightOneCol TEXT,$checkFlightTwoCol TEXT)");

    // Audit Check List Creation
    await db.execute(
        'create table $AuditCheckListTable ($CCAIDCol TEXT,$CabicrewNoCol TEXT,$AuditDonebyCol TEXT, $StatusidCol TEXT, $FlightSceduleIDCol TEXT,'
        '$FAMTypeCol TEXT, $FAMStatusCol TEXT, $UserIDCol TEXT, $CommentsCol TEXT, $ObjectIDCol TEXT, $ChecklistIDCol TEXT,$ChecklistItemIDCol TEXT, $ChecklistItemDataIDCol TEXT,'
        '$CheckEmpIDCol TEXT, $CommentsSubCol TEXT)');

    /* GOPA STATION MASTER TABLE CREATION */
    await db.execute(
        'CREATE TABLE $GOPAStationConfTable ($stationIdConfCol TEXT,$stationCodeConfCol TEXT, $stationNameConfCol TEXT, $stationCodeCol TEXT, $apmCol TEXT, $rmCol TEXT, $hoCol TEXT, $EMPNO TEXT, $apmmailid TEXT, $rmmailid TEXT, $homailid TEXT)');

    /*  GOPA AIRLINE MASTER TABLE CREATION */
    await db.execute(
        'CREATE TABLE $GOPAAirlineConfTable ($airlineIdConfCol TEXT,$airlineCodeConfCol TEXT, $airlineNameConfCol,$StationID TEXT)');

    /* GOPA GROUND HANDLER MASTER TABLE CREATION */
    await db.execute(
        'CREATE TABLE $GOPAGroundHandlerConfTable ($ghIdConfCol TEXT,$StationID TEXT,$ghCodeConfCol TEXT, $ghNameConfCol)');

    /* GOPA CheckList TABLE CREATION */
    await db.execute(
        'CREATE TABLE $GOPAcheckListQstnTable  ($checkListIDQstnCol TEXT, $checkListNameQstnCol TEXT, $itemIDQstnCol TEXT, $itemNameQstnCol TEXT, $subchecklistIDCol TEXT, $subchecklistnameCol TEXT, $checklistorderCol TEXT, $subChecklistorderCol TEXT, $checklistItemDataIDCol TEXT, $empIDCol TEXT, $commentsCol TEXT)');

    //Create GOPA Check List Table and Column
    await db.execute(
        'CREATE TABLE $GOPAcheckListTable ($chkNameCol TEXT,$chkIdCol TEXT, $uploadFileNameCol TEXT, $followUpCol TEXT, $ratingStatusCol TEXT, $airLineIdCol TEXT, $subHeadingCol TEXT,'
        '$airlineIdsChkCol TEXT,$airlineCodeCol TEXT,$auditIdChkCol TEXT,$stationIdCol TEXT,$stationAirportCol TEXT,$groundHandlerIdCol TEXT,$groundHandlerCol TEXT,$auditDateCol TEXT,'
        '$conductedIdCol TEXT,$conductAuditCol TEXT,$statusIdGOPACol TEXT,$GOPAcheckListUserIdCol TEXT,$auditNumberCol TEXT,$isSynchedCol INTEGER DEFAULT 0,$isDeletedCol INTEGER DEFAULT 0)'); //Create GOPA Check List Table and Column

    //Create GOPA Attachment Table
    await db.execute(
        'CREATE TAble $GOPAattachmentTable ($GOPAatchmntAditIdCol TEXT,$GOPAAttachmentIDCol TEXT,$GOPAAttachmentAttachedByCol TEXT,$GOPAAttachmentFileNameCol TEXT,$GOPAAttachmentAttachedDateCol TEXT,$GOPAAttachmentFileTypeCol TEXT,$GOPAAttachmentPathCol TEXT,$GOPAAttachmentImageBase64Col TEXT)');

    // Annexure module

    //Create Gopa Number Table Creation
    await db.execute(
        "CREATE TABLE $GopaNumberTable ($gopaNumberCol TEXT,$gopaNumberwithGGHCol TEXT)");
    // Create Annexure Draft Audit Table Created
    await db.execute(
        "CREATE TABLE $AnnexureDraftAuditsTable ($annexureIDCol TEXT,$annexureNumberCol TEXT,$stationNameCol TEXT,$airlineNameCol TEXT,$statusCol TEXT,$msgCol TEXT,$anxrAuditDateCol TEXT,$anxrAuditDoneByCol TEXT ,$Sync TEXT)");
    // Create Annexure Search Track Table Created
    await db.execute(
        "CREATE TABLE $AnnexureSearchTrackAuditsTable ($annexureIDCol TEXT,$annexureNumberCol TEXT,$stationNameCol TEXT,$airlineNameCol TEXT,$statusCol TEXT,$msgCol TEXT,$anxrAuditDateCol TEXT,$anxrAuditDoneByCol TEXT ,$Sync TEXT)");
    // Create Annexure Checklist Table Created
    await db.execute(
        "CREATE TABLE $AnnexureCheckListTable ($checkListIDCol TEXT,$checkListNameCol TEXT,$subchecklistIDCol TEXT,$subchecklistnameCol TEXT,$itemIDCol TEXT,$itemNameCol TEXT,$checklistorderCol TEXT,$subChecklistorderCol TEXT, $attachfileManadatory TEXT)");
    // Create GOPA Checklist Table Created
    await db.execute(
        "CREATE TABLE $GOPACheckListDataTable ($checkListIDCol TEXT,$checkListNameCol TEXT,$subchecklistIDCol TEXT,$subchecklistnameCol TEXT,$itemIDCol TEXT,$itemNameCol TEXT,$checklistorderCol TEXT,$subChecklistorderCol TEXT, $attachfileManadatory TEXT)");

    // Create Annexure Overview Details Table Created
    await db.execute(
        "CREATE TABLE $AnnexureOverviewDetailsTable ($stationIDCol TEXT,$stationNameCol TEXT,$annexuresIDCol TEXT,$flightDateCol TEXT,$flightNoCol TEXT,$anxrAuditDateCol TEXT,$anxrAuditDoneByCol TEXT,"
        "$marshallingaircraftdonebyCol TEXT,$marshallingaircraftdonebyId TEXT,$statusidCol TEXT,$statusNameCol TEXT,$airlineIDCol TEXT,$airlineNameCol TEXT,"
        "$submittedByCol TEXT,$userIDCol TEXT,$gopaNumberCol TEXT,$annexuresNumberCol TEXT,$previousAuditFlightNoCol TEXT,$previousAuditDateCol TEXT,"
        "$passengerHandlingstaffCol TEXT,"
        "$loadControlstaffCol TEXT,$rampHandlingstaffCol TEXT,$equipmentOperatorsCol TEXT,$passengerBoardingBridgeCol TEXT,$passengerBoardingBridgeId TEXT)");

    // Create Annexure OverviewChecklist Table Created
    await db.execute(
        "CREATE TABLE $AnnexureOverviewChecklistTable ($objectIDCol TEXT,$annexuresNumberCol TEXT,$checklistIDCol TEXT,$checklistItemIDCol TEXT,$checklistItemDataIDCol TEXT,$empIDCol TEXT,$commentsCol TEXT,$checkListNameCol TEXT,$itemNameCol TEXT,$subchecklistIDCol TEXT,$subchecklistnameCol TEXT,$checklistorderCol TEXT,$subChecklistorderCol TEXT, $imagename TEXT, $attachfileManadatory TEXT)");

    // GOPA Draft Audits
    await db.execute(
        "CREATE TABLE $GOPADraftAuditsTable ($stationName TEXT,$auditID TEXT,$gghName TEXT,$auditDate TEXT,$auditDoneby TEXT,$airlineIDs TEXT,$statusName TEXT,$statusid TEXT,$auditNumber TEXT,$Sync TEXT)");

    // GOPA Search/Track Audits
    await db.execute(
        "CREATE TABLE $GOPASearchTrackAuditsTable ($stationName TEXT,$auditID TEXT,$gghName TEXT,$auditDate TEXT,$auditDoneby TEXT,$airlineIDs TEXT,$statusName TEXT,$statusid TEXT,$auditNumber TEXT,$Sync TEXT)");

    // GopaOverviewDetailsTable
    await db.execute(
        "CREATE TABLE $GopaOverviewDetailsTable ($stationName TEXT,$auditID TEXT,$HoNumber TEXT,$groundHandler TEXT,$auditDate TEXT,$auditDoneby TEXT,$airlineIDs TEXT,$statusName TEXT,$statusid TEXT,$auditNumber TEXT,$allAirlinesSameServiceProvider TEXT,$isagocertified TEXT,$gghid TEXT,$stationID TEXT,$submittedBy TEXT,$userID TEXT,$msg TEXT,$submittedDate TEXT,$restartoperations TEXT,$sameserviceprovider TEXT,$gopaNumber TEXT,$pBhandling TEXT,$ramphandling TEXT,$cargohandling TEXT,$deicingoperations TEXT,$aircraftMarshalling TEXT,$loadcontrol TEXT,$aircraftmovement TEXT,$headsetcommunication TEXT,$passengerbridge TEXT,$isago TEXT,$duedate TEXT,$pBhandlingID TEXT,$ramphandlingID TEXT,$cargohandlingID TEXT,$deicingoperationsID TEXT,$aircraftMarshallingID TEXT,$loadcontrolID TEXT,$aircraftmovementID TEXT,$headsetcommunicationID TEXT,$passengerbridgeID TEXT,$isagoid TEXT,$restartoperationsID TEXT,$sameserviceprovideriD TEXT,$duedateID TEXT,$reason TEXT,$pBhandlingServiceProvider TEXT,$ramphandlingServiceProvider TEXT,$cargohandlingServiceProvider TEXT,$deicingoperationsServiceProvider TEXT,$aircraftMarshallingServiceProvider TEXT,$loadcontrolServiceProvider TEXT,$aircraftmovementServiceProvider TEXT,$headsetcommunicationServiceProvider TEXT,$passengerbridgeServiceProvider TEXT)");

    // Create GOPAOverviewChecklistTable Created
    await db.execute(
        "CREATE TABLE $GOPAOverviewChecklistTable ($objectIDCol TEXT,$checklistIDCol TEXT,$checklistItemIDCol TEXT,$checklistItemDataIDCol TEXT,$empIDCol TEXT,$commentsCol TEXT,$checkListNameCol TEXT,$itemNameCol TEXT,$subchecklistIDCol TEXT,$subchecklistnameCol TEXT,$checklistorderCol TEXT,$subChecklistorderCol TEXT,$attachmentNameCol TEXT,$attachmentBaseImgCol TEXT,$imagename TEXT, $attachfileManadatory TEXT)");

    await db.execute(
        "create table $ScopeOfAuditTable ($scopeRatingIdCol TEXT,$scopeRatingNameCol TEXT,$scopeDropdownIdCol TEXT, $scopeDropdownNameCol TEXT,$scopeInterlinksCol TEXT,$scopeNameCol TEXT)");

    await db.execute(
        "create table $PrimaryMenuTable ($pMenuIDCol TEXT,$pPluginIDCol TEXT,$pDisplayNameCol TEXT, $pModuleIDCol TEXT)");
    await db.execute(
        "create table $secondryMenuTable ($fMenuIDCol TEXT,$fPluginIDCol TEXT, $fFeatureIDCol TEXT, $fDisplayNameCol TEXT)");

    await db.execute(
        "create table $RatingcommonTable ($ratingIDCol TEXT,$ratingNameCol TEXT, $ratingchecklistIDCol TEXT, $ratingsubChecklistIDCol TEXT)");

    await db.execute(
        "create table $RatingIDbasedTable ($ratingIDCol TEXT,$ratingNameCol TEXT, $ratingchecklistIDCol TEXT, $ratingsubChecklistIDCol TEXT)");

    await db.execute(
        "create table $CAPAModulesTable ($CmoduleIDCol TEXT,$CmoduleNameCol TEXT)");

    await db.execute(
        "create table $AssignedCAPATable ($ACidCol TEXT,$ACpluginIDCol TEXT,$ACfeatureIDCol TEXT, $ACcapaFeatureIDCol TEXT,$ACnumberCol TEXT,$ACobjectNumberCol TEXT,$ACassignedToCol TEXT,$ACassignedFromCol TEXT,$ACstatusCol TEXT,$ACpriorityCol TEXT,$ACdueDateCol TEXT,$ACsubmittedDateCol TEXT,$ACcapaCommentsCol TEXT,$ACcapaDetailsCol TEXT,$ACcapaTitleCol TEXT,$ACcapaTypeCol TEXT,$ACauditQuestionIDCol TEXT,$LoginEMPNumber TEXT,$Sync TEXT)");

    await db.execute(
        "create table $IsGOPAClosedbasedonStationTable ($StationID TEXT,$capaFullNumbers TEXT)");

    await db.execute(
        "create table $IsGOPAClosedbasedGHTable ($StationID TEXT,$EMPNO TEXT,$GHID TEXT,$AuditType TEXT,$capaFullNumbers TEXT)");

    await db.execute(
        "create table $MOAirlinesDataTable ($StationID TEXT,$GOPANumber TEXT,$airlineIdConfCol TEXT,$airlineCodeConfCol TEXT,$airlineNameConfCol TEXT)");

    await db.execute(
        "create table $IsMOexistsTable ($GOPAID TEXT,$AirlineID TEXT,$moExist TEXT,$annexuresExitID TEXT,$flag TEXT)");

    await db.execute(
        "create table $PreviousAnnexuresFlighNoandDateTable ($AirlineID TEXT,$StationID TEXT,$flightNo TEXT,$flightDate TEXT)");

    await db.execute("create table $GetEMPRoleTable ($EMPNo TEXT,$role TEXT)");

    await db.execute(
        "create table $GGPANumberforMOTable ($StationID TEXT, $AuditerNo TEXT, $gopano TEXT)");
  }

  /*Configuratio Tables Start*/

  // GOPA Station Data Inserting
  Future<int> SaveCAPAFileAttachment(
      attachmentObj, capaNumber, flag, filePath) async {
    print("Welcome 11");
    int result = 0;
    Database db = await this.database;
    var attachmentID = attachmentObj["attachmentID"].toString();

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $CapaAttachmentTable WHERE attachmentID = "$attachmentID" AND capaNumber = "$capaNumber")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$CapaAttachmentTable",
          SaveCAPAFileAttachmentMap(attachmentObj, capaNumber, flag, filePath),
          where: 'attachmentID = ? AND capaNumber = ?',
          whereArgs: ['$attachmentID', '$capaNumber']);
      ;
    } else {
      result = await db.insert("$CapaAttachmentTable",
          SaveCAPAFileAttachmentMap(attachmentObj, capaNumber, flag, filePath));
    }
    return result;
  }

  // GOPA Station Data Inserting
  Future<int> SaveFileAttachmentforChecklist(attachmentObj, flag) async {
    int result = 0;
    Database db = await this.database;
    var AuditID = attachmentObj["AuditID"].toString();
    var ChecklistID = attachmentObj["ChecklistID"];
    var ChecklistItemID = attachmentObj["ChecklistItemID"];
    var SubchecklistID = attachmentObj["SubchecklistID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $SaveFileAttachmentforChecklistTable WHERE AuditID = "$AuditID" AND ChecklistID = "$ChecklistID" AND ChecklistItemID = "$ChecklistItemID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$SaveFileAttachmentforChecklistTable",
          SaveFileAttachmentforChecklistMap(attachmentObj, flag),
          where: 'AuditID = ? AND ChecklistID = ? AND ChecklistItemID = ?',
          whereArgs: ['$AuditID', '$ChecklistID', '$ChecklistItemID']);
      ;
    } else {
      result = await db.insert("$SaveFileAttachmentforChecklistTable",
          SaveFileAttachmentforChecklistMap(attachmentObj, flag));
    }
    return result;
  }

  // GOPA Station Data Inserting
  Future<int> saveorupdateStation(stationObj, EMPNO) async {
    int result = 0;
    Database db = await this.database;
    var stationId = stationObj["stationID"].toString();
    // var isExist = await getStationById(stationId);
    var id = stationObj["id"];
    var stationCode = stationObj["stationCode"];
    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $GOPAStationConfTable WHERE id = "$id" AND stationCode = "$stationCode")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$GOPAStationConfTable", stationMap(stationObj, EMPNO),
          where: 'id = ? AND stationCode = ?',
          whereArgs: ['$id', '$stationCode']);
      ;
    } else {
      result = await db.insert(
          "$GOPAStationConfTable", stationMap(stationObj, EMPNO));
    }
    return result;
  }

  Map<String, dynamic> SaveCAPAFileAttachmentMap(
      attachmentObj, capaNumber, flag, filePath) {
    var map = Map<String, dynamic>();
    map["attachmentID"] = attachmentObj["attachmentID"].toString();
    map["attachedBy"] = attachmentObj["attachedBy"].toString();
    map["fileName"] = attachmentObj["fileName"].toString();
    map["attachedDate"] = attachmentObj["attachedDate"].toString();
    map["fileType"] = attachmentObj["fileType"].toString();
    map["path"] = attachmentObj["path"].toString();
    map["imageBase64"] = attachmentObj["imageBase64"].toString();
    if (flag == 0) {
      map["imageDownlaodpath"] = attachmentObj["imageDownlaodpath"].toString();
    } else {
      map["imageDownlaodpath"] = filePath;
    }
    map["capaNumber"] = capaNumber;
    map["flag"] = flag;
    return map;
  }

  Map<String, dynamic> SaveFileAttachmentforChecklistMap(attachmentObj, flag) {
    var map = Map<String, dynamic>();
    map["PluginID"] = attachmentObj["PluginID"].toString();
    map["AuditID"] = attachmentObj["AuditID"].toString();
    map["AuditNumber"] = attachmentObj["AuditNumber"].toString();
    map["featurID"] = attachmentObj["featurID"].toString();
    map["ChecklistID"] = attachmentObj["ChecklistID"].toString();
    map["ChecklistItemID"] = attachmentObj["ChecklistItemID"].toString();
    map["SubchecklistID"] = attachmentObj["SubchecklistID"].toString();
    map["FilePath"] = attachmentObj["FilePath"].toString();
    map["FileName"] = attachmentObj["FileName"].toString();
    map["AttachedBy"] = attachmentObj["AttachedBy"].toString();
    map["ImageBase64"] = attachmentObj["ImageBase64"].toString();
    map["flag"] = flag;
    return map;
  }

  Map<String, dynamic> stationMap(stationObj, EMPNO) {
    var map = Map<String, dynamic>();
    map["id"] = stationObj["id"].toString();
    map["stationID"] = stationObj["id"].toString();
    map["stationName"] = stationObj["stationName"].toString();
    map["stationCode"] = stationObj["stationCode"].toString();
    map["apm"] = stationObj["apm"].toString();
    map["rm"] = stationObj["rm"].toString();
    map["ho"] = stationObj["ho"].toString();
    map["apmmailid"] = stationObj["apmmailid"].toString();
    map["rmmailid"] = stationObj["rmmailid"].toString();
    map["homailid"] = stationObj["homailid"].toString();
    map["EMPNO"] = EMPNO;
    return map;
  }

  Future<bool> getStationById(id) async {
    Database db = await this.database;
    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $GOPAStationConfTable WHERE stationID="$id")',
    );
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String, dynamic>>> getCapaAttachmentsById(CAPANUMBER) async {
    Database db = await this.database;
    var capaObj = await db.rawQuery(
        'SELECT capaNumber,fileName,attachedBy,attachedDate,attachmentID FROM CapaAttachment WHERE capaNumber = "$CAPANUMBER"');
    return capaObj;
  }

  Future<List<Map<String, dynamic>>> getCapaAttachmentsByCapaNumber(
      attachmentID, capaNumber) async {
    print("attachmentID");
    print(attachmentID);
    print(capaNumber);

    Database db = await this.database;
    var capaObj = await db.rawQuery(
        'SELECT imageDownlaodpath,flag FROM CapaAttachment WHERE attachmentID = "$attachmentID" AND capaNumber = "$capaNumber"');
    return capaObj;
  }

  Future<List<Map<String, dynamic>>> getCapaAttachmentBase64ByCapaNumber(
      attachmentID, capaNumber) async {
    print("attachmentID");
    print(attachmentID);
    print(capaNumber);

    Database db = await this.database;
    var capaObj = await db.rawQuery(
        'SELECT imageBase64 FROM CapaAttachment WHERE attachmentID = "$attachmentID" AND capaNumber = "$capaNumber"');
    return capaObj;
  }

  Future<List<Map<String, dynamic>>> getStation(EMPNO) async {
    Database db = await this.database;
    var stationListobj = await db
        .rawQuery("SELECT * FROM $GOPAStationConfTable WHERE EMPNO = '$EMPNO'");
    return stationListobj;
  }

  Future<List<Map<String, dynamic>>> deleteGOPA(deleteauditNumber) async {
    Database db = await this.database;
    var stationListobj =
        await db.rawQuery("DELETE FROM $GOPADraftAuditsTable WHERE Sync = 0");
    await db.rawQuery(
        "DELETE FROM $GopaOverviewDetailsTable WHERE auditID = '$deleteauditNumber'");
    await db.rawQuery(
        "DELETE FROM $GOPAOverviewChecklistTable WHERE objectID = '$deleteauditNumber'");
    // await db.rawQuery("DELETE FROM $SaveFileAttachmentforChecklistTable WHERE PluginID=137 AND flag = 0");
    return stationListobj;
  }

  Future<int> deleteGOPAByID(auditID) async {
    Database db = await this.database;
    var stationListobj = await db.rawDelete(
        "DELETE FROM $GOPADraftAuditsTable WHERE auditID = '$auditID'");
    await db.rawDelete(
        "DELETE FROM $GopaOverviewDetailsTable WHERE auditID = '$auditID'");
    await db.rawDelete(
        "DELETE FROM $GOPAOverviewChecklistTable WHERE objectID = '$auditID'");
    await db.rawDelete(
        "DELETE FROM $SaveFileAttachmentforChecklistTable WHERE PluginID=137 AND AuditID = '$auditID'");
    return stationListobj;
  }

  Future<List<Map<String, dynamic>>> deleteMO(deleteannextureId) async {
    Database db = await this.database;
    var stationListobj = await db
        .rawQuery("DELETE FROM $AnnexureDraftAuditsTable WHERE Sync = 0");
    await db.rawQuery(
        "DELETE FROM $AnnexureOverviewDetailsTable WHERE annexuresID = '$deleteannextureId'");
    await db.rawQuery(
        "DELETE FROM $AnnexureOverviewChecklistTable WHERE objectID = '$deleteannextureId'");
    // await db.rawQuery("DELETE FROM $SaveFileAttachmentforChecklistTable WHERE PluginID=145 AND flag = 0");
    return stationListobj;
  }

  Future<int> deleteOfflineCAPAWorkflowRecord(capanumber) async {
    print("Welcome 3");
    Database db = await this.database;
    // var stationListobj =
    //     await db.rawQuery("DELETE FROM $capaMainDataoverviewTable");
    // await db.rawQuery("DELETE FROM $capaWorkflowDataoverviewTable");
    // await db.rawQuery("DELETE FROM $AssignedCAPATable");
    // await db.rawQuery("DELETE FROM $CapaAttachmentTable");
    var stationListobj = await db
        .rawDelete("DELETE FROM $capaWorkflowDataoverviewTable WHERE capaNumber = '$capanumber'");
    await db.rawDelete("DELETE FROM $AssignedCAPATable WHERE number = '$capanumber'");
    await db.rawDelete("DELETE FROM $CapaAttachmentTable WHERE capaNumber = '$capanumber'");
    await db.rawDelete("DELETE FROM $capaMainDataoverviewTable WHERE capaNumber = '$capanumber'");
    return stationListobj;
  }

  Future<List<Map<String, dynamic>>> deleteMODraftRecords(moId) async {
    Database db = await this.database;
    var stationListobj = await db.rawQuery(
        "DELETE FROM $AnnexureDraftAuditsTable WHERE annexureID = $moId");
    return stationListobj;
  }

  Future<List<Map<String, dynamic>>> deleteOfflineDatabaseData() async {
    Database db = await this.database;
    var tbl1 = await db.rawQuery("DELETE FROM $AnnexureOverviewChecklistTable");
    await db.rawQuery("DELETE FROM $AnnexureCheckListTable");
    await db.rawQuery("DELETE FROM $GOPACheckListDataTable");
    await db.rawQuery("DELETE FROM $AnnexureDraftAuditsTable");
    await db.rawQuery("DELETE FROM $AnnexureSearchTrackAuditsTable");
    await db.rawQuery("DELETE FROM $AnnexureSearchTrackAuditsTable");
    await db.rawQuery("DELETE FROM $AnnexureOverviewDetailsTable");
    await db.rawQuery("DELETE FROM $AnnexureOverviewDetailsTable");
    await db.rawQuery("DELETE FROM $AnnexureOverviewChecklistTable");
    await db.rawQuery("DELETE FROM $GOPADraftAuditsTable");
    await db.rawQuery("DELETE FROM $GOPASearchTrackAuditsTable");
    await db.rawQuery("DELETE FROM $GopaOverviewDetailsTable");
    await db.rawQuery("DELETE FROM $GOPAOverviewChecklistTable");
    await db.rawQuery("DELETE FROM $CapaStatusTable");
    await db.rawQuery("DELETE FROM $SaveFileAttachmentforChecklistTable");
    await db.rawQuery("DELETE FROM $capaMainDataoverviewTable");
    await db.rawQuery("DELETE FROM $capaWorkflowDataoverviewTable");
    await db.rawQuery("DELETE FROM $AssignedCAPATable");
    await db.rawQuery("DELETE FROM $CapaAttachmentTable");
    await db.rawQuery("DELETE FROM $IsMOexistsTable");
    print('Deleted successfully');
    return tbl1;
  }

  Future<List<Map<String, dynamic>>> deleteOfflineDatabaseOnlineData() async {
    Database db = await this.database;
    var tbl1 = await db.rawQuery("DELETE FROM $AnnexureOverviewChecklistTable");
    await db.rawQuery(
        "DELETE FROM $AnnexureDraftAuditsTable WHERE annexureNumber NOT LIKE '%MO%'");
    await db.rawQuery(
        "DELETE FROM $AnnexureOverviewDetailsTable WHERE annexuresID NOT LIKE '%MO%'");
    await db.rawQuery(
        "DELETE FROM $AnnexureOverviewChecklistTable WHERE annexuresNumber NOT LIKE '%MO%'");
    await db.rawQuery(
        "DELETE FROM $GOPADraftAuditsTable WHERE auditID NOT LIKE '%GOPA%'");
    await db.rawQuery(
        "DELETE FROM $GopaOverviewDetailsTable WHERE auditID NOT LIKE '%GOPA%'");
    await db.rawQuery(
        "DELETE FROM $GOPAOverviewChecklistTable WHERE objectID NOT LIKE '%GOPA%'");
    await db.rawQuery(
        "DELETE FROM $SaveFileAttachmentforChecklistTable WHERE AuditID NOT LIKE '%GOPA%'");
    await db.rawQuery(
        "DELETE FROM $GGPANumberforMOTable WHERE gopano NOT LIKE '%GOPA%'");
    print('Deleted successfully');
    return tbl1;
  }

  Future<List<Map<String, dynamic>>> deleteCAPAOfflineDatabaseData() async {
    Database db = await this.database;
    var tbl1 = await db.rawQuery("DELETE FROM $capaMainDataoverviewTable");
    await db.rawQuery("DELETE FROM $capaMainDataoverviewTable");
    await db.rawQuery("DELETE FROM $capaWorkflowDataoverviewTable");
    await db.rawQuery("DELETE FROM $capaWorkflowDataoverviewTable");
    await db.rawQuery("DELETE FROM $AssignedCAPATable");
    await db.rawQuery("DELETE FROM $CapaAttachmentTable");
    print('Deleted successfully');
    return tbl1;
  }

  // AddColumn() async {
  //
  //   Database db = await this.database;
  //
  //   db.rawQuery("ALTER TABLE $GOPADraftAuditsTable ADD Type1 TEXT");
  //   db.rawQuery("ALTER TABLE $AnnexureDraftAuditsTable ADD Type1 TEXT");
  //
  // }

  // GOPA Airline Data Inserting
  Future<int> saveorupdateAirline(airlineObj, StationID) async {
    Database db = await this.database;
    int result = 0;
    var id = airlineObj["airlineCode"];
    var exists = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPAAirlineConfTable WHERE $airlineCodeCol = "$id" AND StationID = "$StationID")');
    int? isExist = Sqflite.firstIntValue(exists);
    //var isExist = await isAirlineExist(airlineObj["airlineCode"]);
    if (isExist == 1) {
      result = await db.update(
          "$GOPAAirlineConfTable", GOPAAirlineMap(airlineObj, StationID),
          where: '$airlineCodeCol = ? AND StationID = ?',
          whereArgs: ['$id', '$StationID']);
    } else {
      result = await db.insert(
          "$GOPAAirlineConfTable", GOPAAirlineMap(airlineObj, StationID));
    }

    return result;
  }

  Map<String, dynamic> GOPAAirlineMap(airlineObj, StationID) {
    var map = Map<String, dynamic>();
    map["id"] = airlineObj["id"].toString();
    map["airlineCode"] = airlineObj["airlineCode"].toString();
    map["airlineName"] = airlineObj["airlineName"].toString();
    map["StationID"] = StationID;

    return map;
  }

  Future<bool> isAirlineExist(id) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPAAirlineConfTable WHERE $airlineCodeCol = "$id")');
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  getAirlines(StationID) async {
    Database db = await this.database;
    airlineList = await db.rawQuery(
        "SELECT * FROM $GOPAAirlineConfTable WHERE StationID = '$StationID'");
    var dbdata = [];
    for (int i = 0; i < airlineList.length; i++) {
      var body = jsonEncode({
        "id": airlineList[i]["id"].toString(),
        "airlineCode": airlineList[i]["airlineCode"].toString(),
        "airlineName": airlineList[i]["airlineName"].toString()
      });
      dbdata.add(body);
    }
    return dbdata;
  }

  //Get GOPA Numbers
  getDraftGopaNumbers() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $GopaNumberTable');
    return result;
  }

  //Get Annexure Search/Track Audits
  Future<List<Map<String, Object?>>> getAnnexureSearchTrackAudits(
      emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $AnnexureSearchTrackAuditsTable WHERE $anxrAuditDoneByCol LIKE "%$emplogin%"');
    return result;
  }

  //Get Annexure Dreaft Audits
  Future<List<Map<String, Object?>>> getAnnexureDraftAudits(emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $AnnexureDraftAuditsTable WHERE $anxrAuditDoneByCol LIKE "%$emplogin%"');
    return result;
  }

  //Get Annexure Dreaft Audits
  Future<List<Map<String, Object?>>> getAnnexureOfflineDraftAudits(
      emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $AnnexureDraftAuditsTable WHERE $anxrAuditDoneByCol LIKE "%$emplogin%" AND $Sync = 0');
    return result;
  }

  //Get GOPA Dreaft Audits
  Future<List<Map<String, Object?>>> getGOPADraftAuditRecords() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $GOPADraftAuditsTable');
    return result;
  }

  //Get GOPA Dreaft Audits
  Future<List<Map<String, Object?>>> getGOPADraftAudits(emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $GOPADraftAuditsTable WHERE $auditDoneby LIKE "%$emplogin%" AND $statusid IN (1,6)');
    return result;
  }

  //Get GOPA Dreaft Audits
  Future<List<Map<String, Object?>>> GetGOPADraftByAudtitDoneBy(
      emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $GOPADraftAuditsTable WHERE $auditDoneby LIKE "%$emplogin%"');
    return result;
  }

  Future<List<Map<String, Object?>>> getGOPAOfflineDraftAudits(emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $GOPADraftAuditsTable WHERE $auditDoneby LIKE "%$emplogin%" AND $statusid = 1 AND Sync = 0');
    return result;
  }

  //Get GOPA Dreaft Audits
  Future<List<Map<String, Object?>>> getGOPASearchTrackAudits(emplogin) async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $GOPASearchTrackAuditsTable');
    return result;
  }

  //Get GOPA Checklists
  Future<List<Map<String, Object?>>> getGOPAChecklistData() async {
    Database db = await this.database;
    var checklistresult =
        await db.rawQuery('SELECT * FROM $GOPACheckListDataTable');
    return checklistresult;
  }

  //Get Scope Checklists
  Future<List<Map<String, Object?>>> getGOPAScopeAuditData() async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery('SELECT * FROM $ScopeOfAuditTable');
    return checklistresult;
  }

  //Get PrimaryMenu data
  Future<List<Map<String, Object?>>> getPrimaryMenuData() async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery('SELECT * FROM $PrimaryMenuTable');
    return checklistresult;
  }

  //Get SecondryMenu data
  Future<List<Map<String, Object?>>> getSecondryMenuData() async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery('SELECT * FROM $secondryMenuTable');
    return checklistresult;
  }

  //Get getRatingcommonData
  Future<List<Map<String, Object?>>> getRatingcommonData() async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery('SELECT * FROM $RatingcommonTable');
    return checklistresult;
  }

  //Get getRatingcommonData
  Future<List<Map<String, Object?>>> getRatingIDbasedData() async {
    Database db = await this.database;
    var checklistresult =
        await db.rawQuery('SELECT * FROM $RatingIDbasedTable');
    return checklistresult;
  }

  //Get GOPA Checklists
  Future<List<Map<String, Object?>>> getGOPAChecklistDataByAuditId(
      auditId) async {
    print('-----------auditId---------');
    print(auditId);
    Database db = await this.database;
    var checklistresult = await db.rawQuery(
        'SELECT * FROM $GOPAOverviewChecklistTable WHERE $objectIDCol = "$auditId"');
    return checklistresult;
  }

  //Get GOPA Overview Data
  Future<List<Map<String, Object?>>> getGOPAOverviewDataByAuditId(
      auditId) async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery(
        'SELECT * FROM $GopaOverviewDetailsTable WHERE $auditID = "$auditId"');
    return checklistresult;
  }

  //Get GOPA Overview Data
  Future<List<Map<String, Object?>>> getGOPAData(
      userId, submittedBy, stationID) async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery(
        'SELECT * FROM $GopaOverviewDetailsTable WHERE userID = "$userId" AND submittedBy = "$submittedBy" AND stationID = "$stationID"');
    return checklistresult;
  }

  //Get Annexure Overview Details
  Future<List<Map<String, Object?>>> getAnnexureOverviewDetails(
      AnnexuresID, AnnexuresNumber) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $AnnexureOverviewDetailsTable WHERE $annexuresIDCol = "$AnnexuresID" AND $annexuresNumberCol = "$AnnexuresNumber"');
    return result;
  }

  //Get Annexure Overview Details

  Future<List<Map<String, Object?>>> getAnnexuresOverviewDataforgopa(
      auditID) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $AnnexuresOverviewDataforgopaTable WHERE $auditId = "$auditID"');
    return result;
  }

  //Get Annexure Overview Checklists
  Future<List<Map<String, Object?>>> getAnnexureOverviewChecklists(
      AnnexuresID, number) async {
    Database db = await this.database;
    var checklistresult = await db.rawQuery(
        'SELECT * FROM $AnnexureOverviewChecklistTable WHERE $objectIDCol = "$AnnexuresID"');
    return checklistresult;
  }

  //Get Annexure Checklists
  Future<List<Map<String, Object?>>> getAnnexureChecklists() async {
    Database db = await this.database;
    var checklistresult =
        await db.rawQuery('SELECT * FROM $AnnexureCheckListTable');
    return checklistresult;
  }

  // getAirlines() async {
  //   Database db = await this.database;
  //   airlineList = await db.rawQuery("SELECT * FROM $GOPAAirlineConfTable ");
  //   var dbdata = [];
  //   for(int i=0;i<airlineList.length;i++){
  //     var body = jsonEncode({
  //       "id":airlineList[i]["id"].toString(),
  //       "airlineCode":airlineList[i]["airlineCode"].toString(),
  //       "airlineName":airlineList[i]["airlineName"].toString()
  //     });
  //     dbdata.add(body);
  //   }
  //   return dbdata;
  // }

  // Ground Handler Data Insert

  Future<int> saveorupdateGroundHandler(groundHandlerObj, StationID) async {
    Database db = await this.database;
    var id = groundHandlerObj['id'];
    int result;
    var exist = await db.rawQuery(
        'Select EXISTS(SELECT 1 FROM $GOPAGroundHandlerConfTable WHERE id = "$id" AND StationID = "$StationID")');
    int? isExist = Sqflite.firstIntValue(exist);
    if (isExist == 1) {
      result = await db.update("$GOPAGroundHandlerConfTable",
          groundHandlerMap(groundHandlerObj, StationID),
          where: 'id = ? AND StationID = ?', whereArgs: ['$id', '$StationID']);
    } else {
      result = await db.insert("$GOPAGroundHandlerConfTable",
          groundHandlerMap(groundHandlerObj, StationID));
    }

    return result;
  }

  Map<String, dynamic> groundHandlerMap(groundHandlerObj, StationID) {
    var map = Map<String, dynamic>();
    map["id"] = groundHandlerObj['id'].toString();
    map["StationID"] = StationID;
    map["grounhandlerId"] = groundHandlerObj['grounhandlerId'].toString();
    map["groundhandlerName"] = groundHandlerObj['groundhandlerName'].toString();
    return map;
  }

  Future<bool> isExistGroundHandler(id) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'Select EXISTS(SELECT 1 FROM $GOPAGroundHandlerConfTable Where $ghCodeConfCol = "$id")');
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<List<Map<String, dynamic>>> getGroundHandler(StationID) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        "SELECT * FROM $GOPAGroundHandlerConfTable WHERE StationID = '$StationID'");
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getAnnexureDraftLastRecord() async {
    Database db = await this.database;
    var ghListobj =
        await db.rawQuery("SELECT * FROM $AnnexureDraftAuditsTable");
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> checkMoRecord(
      GopaNumber, airlineID, loginId) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        "SELECT * FROM $AnnexureOverviewDetailsTable WHERE airlineID = '$airlineID' AND submittedBy = '$loginId' AND gopaNumber = '$GopaNumber'");
    return ghListobj;
  }

  // Annexure Module

  // saveCAPASearch
  Future<int> saveCAPAStatus(capaSearchObj, statusId) async {
    int result = 0;
    Database db = await this.database;
    var Id = capaSearchObj["id"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $CapaStatusTable WHERE statusId = "$statusId" AND id = "$Id")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$CapaStatusTable", CapaStatusMap(capaSearchObj, statusId),
          where: 'statusId = ? AND id = ?', whereArgs: ['$statusId', '$Id']);
      ;
    } else {
      result = await db.insert(
          "$CapaStatusTable", CapaStatusMap(capaSearchObj, statusId));
    }
    return result;
  }

  // saveCAPASearch
  Future<int> saveMOMasterData(
      auditNumber, moIntrelinks, loadControl, passengerBoardingBridge) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $MOMasterDataTable WHERE GOPANo = "$auditNumber")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$MOMasterDataTable",
          MOMasterDataMap(
              auditNumber, moIntrelinks, loadControl, passengerBoardingBridge),
          where: 'GOPANo = ?',
          whereArgs: ['$auditNumber']);
      ;
    } else {
      result = await db.insert(
          "$MOMasterDataTable",
          MOMasterDataMap(
              auditNumber, moIntrelinks, loadControl, passengerBoardingBridge));
    }
    return result;
  }

  // saveCAPASearch
  Future<int> saveCAPASearch(capaSearchObj, emplogin, sync) async {
    int result = 0;
    Database db = await this.database;
    var capaId = capaSearchObj["id"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $SearchCAPATable WHERE id="$capaId")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$SearchCAPATable",
          assignedCAPAMasterMap(capaSearchObj, emplogin, sync),
          where: 'id = ?', whereArgs: ['$capaId']);
      ;
    } else {
      result = await db.insert("$SearchCAPATable",
          assignedCAPAMasterMap(capaSearchObj, emplogin, sync));
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getCAPAMainDataoverview(capaNumber) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $capaMainDataoverviewTable WHERE capaNumber = "$capaNumber"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getAssignedCapaList(emplogin) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $AssignedCAPATable WHERE assignedTo LIKE "%$emplogin%" ORDER BY number DESC');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getCAPAModulesTable() async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery("SELECT * FROM $CAPAModulesTable");
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getCAPAWorkflowDataoverview(
      capaNumber) async {
    Database db = await this.database;

    // var ghListobj = await db.rawQuery(
    //     'SELECT * FROM $capaWorkflowDataoverviewTable WHERE capaNumber = "$capaNumber"');

    var ghListobj = await db.rawQuery(
        'SELECT assignedFrom,assignedTo,status,statusID,capaDetails,capaComments,capaCreationDate,rejectionComments,capaNumber,CAPAID,comments,attachedBy,fileName,Sync,FilePath FROM $capaWorkflowDataoverviewTable WHERE capaNumber = "$capaNumber"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getOfflineCAPAWorkflowData() async {
    Database db = await this.database;

    var ghListobj = await db.rawQuery(
        'SELECT assignedFrom,assignedTo,status,statusID,capaDetails,capaComments,capaCreationDate,rejectionComments,capaNumber,CAPAID,comments,attachedBy,fileName,Sync,FilePath FROM $capaWorkflowDataoverviewTable WHERE Sync = 0');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getOfflineAssignedCapas(number) async {
    Database db = await this.database;
    var ghListobj = await db
        .rawQuery('SELECT * FROM $AssignedCAPATable WHERE number = "$number"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getCAPASearchData(pluginID) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $SearchCAPATable WHERE pluginID = "$pluginID" ORDER BY number DESC');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> getCAPAStatusById(id) async {
    Database db = await this.database;
    var ghListobj = await db
        .rawQuery('SELECT * FROM $CapaStatusTable WHERE statusId = "$id"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetMOMasterDataByGOPANo(id) async {
    Database db = await this.database;
    var ghListobj = await db
        .rawQuery('SELECT * FROM $MOMasterDataTable WHERE GOPANo = "$id"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetIsGOPAClosedbasedonStation(id) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $IsGOPAClosedbasedonStationTable WHERE StationID = "$id"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetIsGOPAClosedbasedGH(
      StationID, EMPNO, GHID, AuditType) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $IsGOPAClosedbasedGHTable WHERE StationID = "$StationID" AND EMPNO = "$EMPNO" AND GHID = "$GHID" AND AuditType = "$AuditType"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetIsMOexists(
      GOPAID, AirlineID, flag) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $IsMOexistsTable WHERE GOPAID = "$GOPAID" AND AirlineID = "$AirlineID" AND flag = "$flag"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetPreviousAnnexuresFlighNoandDate(
      AirlineID, SationID) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $PreviousAnnexuresFlighNoandDateTable WHERE AirlineID = "$AirlineID" AND StationID = "$SationID"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetEMPRole(EMPNo) async {
    Database db = await this.database;
    var ghListobj = await db
        .rawQuery('SELECT * FROM $GetEMPRoleTable WHERE EMPNo = "$EMPNo"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetGOPANumberforMO(
      StationID, AuditerNo) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $GGPANumberforMOTable WHERE StationID = "$StationID" AND AuditerNo = "$AuditerNo"');
    return ghListobj;
  }

  Future<List<Map<String, dynamic>>> GetMOAirlinesData(
      StationID, GOPANumber) async {
    Database db = await this.database;
    var ghListobj = await db.rawQuery(
        'SELECT * FROM $MOAirlinesDataTable WHERE StationID = "$StationID" AND GOPANumber= "$GOPANumber"');
    return ghListobj;
  }

  // saveCAPAMainDataoverview
  Future<int> saveCAPAMainDataoverview(capaSearchObj, CAPAID) async {
    int result = 0;
    Database db = await this.database;
    var capaNumber = capaSearchObj["capaNumber"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $capaMainDataoverviewTable WHERE capaNumber="$capaNumber")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$capaMainDataoverviewTable",
          CAPAMainDataoverviewMap(capaSearchObj, CAPAID),
          where: 'capaNumber = ?', whereArgs: ['$capaNumber']);
      ;
    } else {
      result = await db.insert("$capaMainDataoverviewTable",
          CAPAMainDataoverviewMap(capaSearchObj, CAPAID));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveIsGOPAClosedbasedonStation(dataObj, id) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $IsGOPAClosedbasedonStationTable WHERE StationID="$id")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$IsGOPAClosedbasedonStationTable",
          IsGOPAClosedbasedonStationMap(dataObj, id),
          where: 'StationID = ?', whereArgs: ['$id']);
      ;
    } else {
      result = await db.insert("$IsGOPAClosedbasedonStationTable",
          IsGOPAClosedbasedonStationMap(dataObj, id));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveIsGOPAClosedbasedGH(
      dataObj, StationID, EMPNO, GHID, AuditType) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $IsGOPAClosedbasedGHTable WHERE StationID = "$StationID" AND EMPNO = "$EMPNO" AND GHID = "$GHID" AND AuditType = "$AuditType")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$IsGOPAClosedbasedGHTable",
          IsGOPAClosedbasedGHMap(dataObj, StationID, EMPNO, GHID, AuditType),
          where: 'StationID = ? AND EMPNO = ? AND GHID = ? AND AuditType = ?',
          whereArgs: ['$StationID', '$EMPNO', '$GHID', '$AuditType']);
      ;
    } else {
      result = await db.insert("$IsGOPAClosedbasedGHTable",
          IsGOPAClosedbasedGHMap(dataObj, StationID, EMPNO, GHID, AuditType));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveIsMOexists(dataObj, GOPAID, AirlineID, flag) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $IsMOexistsTable WHERE GOPAID = "$GOPAID" AND AirlineID = "$AirlineID" AND flag = "$flag")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$IsMOexistsTable", IsMOexistsMap(dataObj, GOPAID, AirlineID, flag),
          where: 'GOPAID = ? AND AirlineID = ? AND flag = ?',
          whereArgs: ['$GOPAID', '$AirlineID', '$flag']);
      ;
    } else {
      result = await db.insert(
          "$IsMOexistsTable", IsMOexistsMap(dataObj, GOPAID, AirlineID, flag));
    }
    return result;
  }

  Future<int> updateIsMOexists(GOPAID, AirlineID, moExist, flag) async {
    int result = 0;
    Database db = await this.database;

    result = await db.update("$IsMOexistsTable",
        IsMOexistUpdateMap(GOPAID, AirlineID, moExist, flag),
        where: 'GOPAID = ? AND AirlineID = ? AND flag = ?',
        whereArgs: ['$GOPAID', '$AirlineID', '$flag']);

    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> savePreviousAnnexuresFlighNoandDate(
      dataObj, AirlineID, SationID) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $PreviousAnnexuresFlighNoandDateTable WHERE AirlineID = "$AirlineID" AND StationID = "$SationID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$PreviousAnnexuresFlighNoandDateTable",
          PreviousAnnexuresFlighNoandDateMap(dataObj, AirlineID, SationID),
          where: 'AirlineID = ? AND StationID = ?',
          whereArgs: ['$AirlineID', '$SationID']);
      ;
    } else {
      result = await db.insert("$PreviousAnnexuresFlighNoandDateTable",
          PreviousAnnexuresFlighNoandDateMap(dataObj, AirlineID, SationID));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveEMPRole(dataObj, EMPNo) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $GetEMPRoleTable WHERE EMPNo = "$EMPNo")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$GetEMPRoleTable", GetEMPRoleMap(dataObj, EMPNo),
          where: 'EMPNo = ?', whereArgs: ['$EMPNo']);
      ;
    } else {
      result =
          await db.insert("$GetEMPRoleTable", GetEMPRoleMap(dataObj, EMPNo));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveGOPANumberforMO(dataObj, StationID, AuditerNo) async {
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $GGPANumberforMOTable WHERE StationID = "$StationID" AND AuditerNo = "$AuditerNo")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$GGPANumberforMOTable",
          GGPANumberforMOMap(dataObj, StationID, AuditerNo),
          where: 'StationID = ? AND AuditerNo = ?',
          whereArgs: ['$StationID', '$AuditerNo']);
      ;
    } else {
      result = await db.insert("$GGPANumberforMOTable",
          GGPANumberforMOMap(dataObj, StationID, AuditerNo));
    }
    return result;
  }

  Future<int> saveGOPANumberforMOCreate(gopano, StationID, AuditerNo) async {
    int result = 0;
    Database db = await this.database;

    result = await db.insert("$GGPANumberforMOTable",
        GGPANumberforMOMapCreate(gopano, StationID, AuditerNo));

    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveMOAirlinesData(dataObj, StationId, GopaNumber) async {
    int result = 0;
    Database db = await this.database;

    var airlineId = dataObj['id'];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $MOAirlinesDataTable WHERE StationID="$StationId" AND GOPANumber="$GopaNumber" AND id="$airlineId")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$MOAirlinesDataTable",
          MOAirlinesDataMap(dataObj, StationId, GopaNumber),
          where: 'StationID = ? AND GOPANumber = ? AND id = ?',
          whereArgs: ['$StationId', '$GopaNumber', '$airlineId']);
      ;
    } else {
      result = await db.insert("$MOAirlinesDataTable",
          MOAirlinesDataMap(dataObj, StationId, GopaNumber));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveCAPAWorkflowDataoverview(
      capaSearchObj, capaNumber, sync, CAPAID) async {
    var status = capaSearchObj['status'].toString();
    var capaDetails = capaSearchObj['capaDetails'].toString();
    var capaComments = capaSearchObj['capaComments'].toString();
    var capaCreationDate = capaSearchObj['capaCreationDate'].toString();
    int result = 0;
    Database db = await this.database;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $capaWorkflowDataoverviewTable WHERE capaNumber="$capaNumber" AND status = "$status" AND capaDetails = "$capaDetails" AND capaComments = "$capaComments" AND capaCreationDate = "$capaCreationDate")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$capaWorkflowDataoverviewTable",
          CAPAWorkflowDataoverviewMap(capaSearchObj, capaNumber, sync, CAPAID),
          where:
              'capaNumber = ? AND status = ? AND capaDetails = ? AND capaComments = ? AND capaCreationDate = ?',
          whereArgs: [
            '$capaNumber',
            '$status',
            '$capaDetails',
            '$capaComments',
            '$capaCreationDate'
          ]);
      ;
    } else {
      result = await db.insert("$capaWorkflowDataoverviewTable",
          CAPAWorkflowDataoverviewMap(capaSearchObj, capaNumber, sync, CAPAID));
    }
    return result;
  }

  // saveCAPAMainDataoverview
  Future<int> saveCAPAWorkflowData(capaSearchObj, capaNumber, sync) async {
    int result = 0;
    Database db = await this.database;
    result = await db.insert("$capaWorkflowDataoverviewTable",
        CAPAWorkflowDataMap(capaSearchObj, capaNumber, sync));
    return result;
  }

  // Update Overview
  Future<int> updateCAPAOverviewData(capaSearchObj, capaNumber) async {
    int result = 0;
    Database db = await this.database;

    result = await db.update("$capaMainDataoverviewTable",
        UpdateCAPAoverviewMap(capaSearchObj, capaNumber),
        where: 'capaNumber = ?', whereArgs: ['$capaNumber']);
    return result;
  }

  // Update Overview
  Future<int> updateCAPAWorkflowSync(capaNumber) async {
    int result = 0;
    Database db = await this.database;

    result = await db.update(
        "$capaWorkflowDataoverviewTable", updateCAPAWorkflowSyncMap(capaNumber),
        where: 'capaNumber = ?', whereArgs: ['$capaNumber']);
    return result;
  }

  // Update Overview
  Future<int> updateSearchCAPAData(capaSearchObj, capaNumber, sync) async {
    int result = 0;
    Database db = await this.database;

    result = await db.update(
        "$SearchCAPATable", UpdateCAPADataMap(capaSearchObj, capaNumber, sync),
        where: 'number = ?', whereArgs: ['$capaNumber']);
    return result;
  }

  // Update Overview
  Future<int> updateAssignedCAPAData(capaSearchObj, capaNumber, sync) async {
    int result = 0;
    Database db = await this.database;

    result = await db.update("$AssignedCAPATable",
        UpdateCAPADataMap(capaSearchObj, capaNumber, sync),
        where: 'number = ?', whereArgs: ['$capaNumber']);
    return result;
  }

  Map<String, dynamic> IsGOPAClosedbasedonStationMap(dataObj, id) {
    var map = Map<String, dynamic>();
    map["StationID"] = id;
    // if(dataObj["capaFullNumbers"].toString() !=''){
    map["capaFullNumbers"] = dataObj["capaFullNumbers"].toString();
    // }else{
    //   map["capaFullNumbers"] = "";
    // }

    return map;
  }

  Map<String, dynamic> IsMOexistsMap(dataObj, GOPAID, AirlineID, flag) {
    var map = Map<String, dynamic>();
    map["GOPAID"] = GOPAID;
    map["AirlineID"] = AirlineID;
    map["flag"] = flag;
    if (flag == 1) {
      if (dataObj["moExist"].toString() != '') {
        map["moExist"] = dataObj["moExist"].toString();
      } else {
        map["moExist"] = 0;
      }
    } else {
      if (dataObj["annexuresExitID"].toString() != '') {
        map["annexuresExitID"] = dataObj["annexuresExitID"].toString();
      } else {
        map["annexuresExitID"] = 0;
      }
    }

    return map;
  }

  Map<String, dynamic> IsMOexistUpdateMap(GOPAID, AirlineID, moExist, flag) {
    var map = Map<String, dynamic>();
    map["GOPAID"] = GOPAID;
    map["AirlineID"] = AirlineID;
    map["moExist"] = moExist;
    map["flag"] = flag;

    return map;
  }

  Map<String, dynamic> PreviousAnnexuresFlighNoandDateMap(
      dataObj, AirlineID, SationID) {
    var map = Map<String, dynamic>();
    map["StationID"] = SationID;
    map["AirlineID"] = AirlineID;
    map["flightNo"] = dataObj["flightNo"].toString();
    map["flightDate"] = dataObj["flightDate"].toString();

    return map;
  }

  Map<String, dynamic> GetEMPRoleMap(dataObj, EMPNo) {
    var map = Map<String, dynamic>();
    map["EMPNo"] = EMPNo;
    map["role"] = dataObj["role"].toString();

    return map;
  }

  Map<String, dynamic> GGPANumberforMOMap(dataObj, StationID, AuditerNo) {
    var map = Map<String, dynamic>();
    map["StationID"] = StationID;
    map["AuditerNo"] = AuditerNo;
    map["gopano"] = dataObj["gopano"].toString();

    return map;
  }

  Map<String, dynamic> GGPANumberforMOMapCreate(gopano, StationID, AuditerNo) {
    var map = Map<String, dynamic>();
    map["StationID"] = StationID;
    map["AuditerNo"] = AuditerNo;
    map["gopano"] = gopano.toString();

    return map;
  }

  Map<String, dynamic> IsGOPAClosedbasedGHMap(
      dataObj, StationID, EMPNO, GHID, AuditType) {
    var map = Map<String, dynamic>();
    map["StationID"] = StationID;
    map["EMPNO"] = EMPNO;
    map["GHID"] = GHID;
    map["AuditType"] = AuditType;
    map["capaFullNumbers"] = dataObj["capaFullNumbers"].toString();

    return map;
  }

  Map<String, dynamic> MOAirlinesDataMap(dataObj, StationId, GopaNumber) {
    var map = Map<String, dynamic>();
    map["StationID"] = StationId;
    map["GOPANumber"] = GopaNumber;
    map["id"] = dataObj["id"];
    map["airlineCode"] = dataObj["airlineCode"];
    map["airlineName"] = dataObj["airlineName"];

    return map;
  }

  Map<String, dynamic> CapaStatusMap(capaSearchObj, statusId) {
    var map = Map<String, dynamic>();
    map["statusId"] = statusId;
    map["id"] = capaSearchObj["id"].toString();
    map["status"] = capaSearchObj["status"].toString();
    map["flag"] = '0';
    return map;
  }

  Map<String, dynamic> MOMasterDataMap(
      auditNumber, moIntrelinks, loadControl, passengerBoardingBridge) {
    var map = Map<String, dynamic>();
    map["GOPANo"] = auditNumber;
    map["moIntrelinks"] = moIntrelinks;
    map["loadControl"] = loadControl;
    map["passengerBoardingBridge"] = passengerBoardingBridge;
    return map;
  }

  Map<String, dynamic> UpdateCAPAoverviewMap(capaSearchObj, capaNumber) {
    var map = Map<String, dynamic>();
    map["capaDetails"] = capaSearchObj["CAPADetails"].toString();
    map["capaComments"] = capaSearchObj["CAPAComments"].toString();
    map["dueDate"] = capaSearchObj["DueDate"].toString();
    map["status"] = capaSearchObj["StatusName"].toString();
    map["statusID"] = capaSearchObj["Status"].toString();
    map["rejectionComments"] = capaSearchObj["RejectionComments"].toString();
    map["submittedDate"] = capaSearchObj["DateTime.Now"].toString();
    map["assignedFrom"] = capaSearchObj["AssignedFrom"].toString();
    map["assignedTo"] = capaSearchObj["AssignedTo"].toString();
    return map;
  }

  Map<String, dynamic> UpdateCAPADataMap(capaSearchObj, capaNumber, sync) {
    var map = Map<String, dynamic>();
    map["capaDetails"] = capaSearchObj["CAPADetails"].toString();
    map["capaComments"] = capaSearchObj["CAPAComments"].toString();
    //map["dueDate"] = capaSearchObj["DueDate"].toString();
    map["status"] = capaSearchObj["StatusName"].toString();
    map["LoginEMPNumber"] = capaSearchObj["LoginEmpNumber"].toString();
    map["assignedFrom"] = capaSearchObj["AssignedFrom"].toString();
    map["assignedTo"] = capaSearchObj["AssignedTo"].toString();
    map["Sync"] = sync;
    // map["rejectionComments"] = capaSearchObj["RejectionComments"].toString();
    // map["submittedDate"] = capaSearchObj["DateTime.Now"].toString();
    return map;
  }

  Map<String, dynamic> updateCAPAWorkflowSyncMap(capaNumber) {
    var map = Map<String, dynamic>();
    map["Sync"] = 1;

    return map;
  }

  Map<String, dynamic> CAPAMainDataoverviewMap(capaSearchObj, CAPAID) {
    var map = Map<String, dynamic>();
    map["capaNumber"] = capaSearchObj["capaNumber"].toString();
    map["CAPAID"] = CAPAID;
    map["number"] = capaSearchObj["number"].toString();
    map["auditQuestionID"] = capaSearchObj["auditQuestionID"].toString();
    map["capaType"] = capaSearchObj["capaType"].toString();
    map["capaTitle"] = capaSearchObj["capaTitle"].toString();
    map["capaDetails"] = capaSearchObj["capaDetails"].toString();
    map["capaComments"] = capaSearchObj["capaComments"].toString();
    map["submittedDate"] = capaSearchObj["submitDate"].toString();
    map["submitDate"] = capaSearchObj["submitDate"].toString();
    map["dueDate"] = capaSearchObj["dueDate"].toString();
    map["priority"] = capaSearchObj["priority"].toString();
    map["status"] = capaSearchObj["status"].toString();
    map["statusID"] = capaSearchObj["statusID"].toString();
    map["assignedFrom"] = capaSearchObj["assignedFrom"].toString();
    map["assignedTo"] = capaSearchObj["assignedTo"].toString();
    map["rejectionComments"] = capaSearchObj["rejectionComments"].toString();
    map["level"] = capaSearchObj["level"].toString();
    return map;
  }

  Map<String, dynamic> CAPAWorkflowDataoverviewMap(
      capaSearchObj, capaNumber, sync, CAPAID) {
    var map = Map<String, dynamic>();
    map["capaNumber"] = capaNumber;
    map["CAPAID"] = CAPAID;
    map["assignedFrom"] = capaSearchObj["assignedFrom"].toString();
    map["assignedTo"] = capaSearchObj["assignedTo"].toString();
    map["status"] = capaSearchObj["status"].toString();

    if (capaSearchObj["status"].toString() == "Create CAPA") {
      map["statusID"] = '1';
    } else if (capaSearchObj["status"].toString() == "CAPA Completed") {
      map["statusID"] = '2';
    } else if (capaSearchObj["status"].toString() == "CAPA Forward") {
      map["statusID"] = '3';
    } else if (capaSearchObj["status"].toString() == "CAPA In-Progress") {
      map["statusID"] = '4';
    } else if (capaSearchObj["status"].toString() == "Re-Assign CAPA") {
      map["statusID"] = '5';
    } else if (capaSearchObj["status"].toString() == "CAPA Closed") {
      map["statusID"] = '6';
    } else {
      map["statusID"] = '0';
    }

    map["capaDetails"] = capaSearchObj["capaDetails"].toString();
    map["capaComments"] = capaSearchObj["capaComments"].toString();
    map["capaCreationDate"] = capaSearchObj["capaCreationDate"].toString();
    map["rejectionComments"] = capaSearchObj["rejectionComments"].toString();
    map["comments"] = capaSearchObj["comments"].toString();
    map["Sync"] = sync;
    return map;
  }

  Map<String, dynamic> CAPAWorkflowDataMap(capaSearchObj, capaNumber, sync) {
    var map = Map<String, dynamic>();
    map["capaNumber"] = capaNumber;
    map["assignedFrom"] = capaSearchObj["AssignedFrom"].toString();
    map["assignedTo"] = capaSearchObj["AssignedTo"].toString();
    map["status"] = capaSearchObj["StatusName"].toString();
    map["statusID"] = capaSearchObj["Status"].toString();
    map["capaDetails"] = capaSearchObj["CAPADetails"].toString();
    map["capaComments"] = capaSearchObj["CAPAComments"].toString();
    map["capaCreationDate"] = capaSearchObj["DateTime.Now"].toString();
    map["rejectionComments"] = capaSearchObj["RejectionComments"].toString();
    map["comments"] = capaSearchObj["Comments"].toString();
    if (sync == 0) {
      map["fileName"] = capaSearchObj["fileName"].toString();
      map["attachedBy"] = capaSearchObj["attachedBy"].toString();
      map["imageBase64"] = capaSearchObj["imageBase64"].toString();
      map["FilePath"] = capaSearchObj["imageDownlaodpath"].toString();
    }
    map["Sync"] = sync;
    return map;
  }

  // Gopa Number Saving
  Future<int> saveGopaNumber(gopanumObj) async {
    int result = 0;
    Database db = await this.database;
    var gopaNumber = gopanumObj["gopaNumber"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $GopaNumberTable WHERE gopaNumber="$gopaNumber")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$GopaNumberTable", gopaNumberMap(gopanumObj),
          where: '$gopaNumberCol = ?', whereArgs: ['$gopanumObj']);
      ;
    } else {
      result = await db.insert("$GopaNumberTable", gopaNumberMap(gopanumObj));
    }
    return result;
  }

  Map<String, dynamic> gopaNumberMap(gopanumObj) {
    var map = Map<String, dynamic>();
    map["gopaNumber"] = gopanumObj["gopaNumber"].toString();
    map["gopaNumberwithGGH"] = gopanumObj["gopaNumberwithGGH"].toString();
    return map;
  }

  // Scope of audit for table Saving
  Future<int> saveScopeOfAuditMasterData(scopeObj) async {
    int result = 0;
    Database db = await this.database;
    var id = scopeObj["id"];
    var name = scopeObj["name"];
    var dropdownID = scopeObj["dropdownID"];
    var dropdownName = scopeObj["dropdownName"];
    var interlinks = scopeObj["interlinks"];
    var scopeName = scopeObj["scopeName"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $ScopeOfAuditTable WHERE id="$id" AND name="$name" AND dropdownID="$dropdownID" AND dropdownName="$dropdownName" AND interlinks="$interlinks" AND scopeName="$scopeName")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$ScopeOfAuditTable", scopeAuditMasterMap(scopeObj),
          where:
              'id = ? AND name =?  AND dropdownID =?  AND dropdownName =?  AND interlinks =?  AND interlinks =?',
          whereArgs: [
            '$id',
            '$name',
            '$dropdownID',
            '$dropdownName',
            '$interlinks',
            '$scopeName'
          ]);
    } else {
      result =
          await db.insert("$ScopeOfAuditTable", scopeAuditMasterMap(scopeObj));
    }
    return result;
  }

  Map<String, dynamic> scopeAuditMasterMap(scopeObj) {
    var map = Map<String, dynamic>();
    map["id"] = scopeObj["id"].toString();
    map["name"] = scopeObj["name"].toString();
    map["dropdownID"] = scopeObj["dropdownID"].toString();
    map["dropdownName"] = scopeObj["dropdownName"].toString();
    map["interlinks"] = scopeObj["interlinks"].toString();
    map["scopeName"] = scopeObj["scopeName"].toString();
    return map;
  }

  // Primary Menu for table Saving
  Future<int> savePrimaryMenuMasterData(menuObj) async {
    int result = 0;
    Database db = await this.database;

    var pMenuID = menuObj["pMenuID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $PrimaryMenuTable WHERE pMenuID="$pMenuID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$PrimaryMenuTable", primaryMenuMasterMap(menuObj),
          where: '$pMenuIDCol = ?', whereArgs: ['$menuObj']);
    } else {
      result =
          await db.insert("$PrimaryMenuTable", primaryMenuMasterMap(menuObj));
    }
    return result;
  }

  Map<String, dynamic> primaryMenuMasterMap(menuObj) {
    var map = Map<String, dynamic>();
    map["pMenuID"] = menuObj["pMenuID"].toString();
    map["pPluginID"] = menuObj["pPluginID"].toString();
    map["pDisplayName"] = menuObj["pDisplayName"].toString();
    map["pModuleID"] = menuObj["pModuleID"].toString();
    return map;
  }

  // Secondry Menu for table Saving
  Future<int> saveSecondryMenuMasterData(menuObj) async {
    int result = 0;
    Database db = await this.database;

    var fMenuID = menuObj["fMenuID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $secondryMenuTable WHERE fMenuID="$fMenuID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$secondryMenuTable", secondryMenuMasterMap(menuObj),
          where: '$fMenuIDCol = ?', whereArgs: ['$menuObj']);
    } else {
      result =
          await db.insert("$secondryMenuTable", secondryMenuMasterMap(menuObj));
    }
    return result;
  }

  Map<String, dynamic> secondryMenuMasterMap(menuObj) {
    var map = Map<String, dynamic>();
    map["fMenuID"] = menuObj["fMenuID"].toString();
    map["fPluginID"] = menuObj["fPluginID"].toString();
    map["fFeatureID"] = menuObj["fFeatureID"].toString();
    map["fDisplayName"] = menuObj["fDisplayName"].toString();
    return map;
  }

  // Common Rating  for table Saving
  Future<int> saveChecklistRatingcommnMasterData(menuObj) async {
    int result = 0;
    Database db = await this.database;
    var ratingID = menuObj["ratingID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $RatingcommonTable WHERE ratingID="$ratingID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$RatingcommonTable", ratingMasterMap(menuObj),
          where: '$ratingIDCol = ?', whereArgs: ['$menuObj']);
    } else {
      result = await db.insert("$RatingcommonTable", ratingMasterMap(menuObj));
    }
    return result;
  }

  // ChecklistRatingIDbased for table Saving
  Future<int> saveChecklistRatingIDbasedMasterData(menuObj) async {
    int result = 0;
    Database db = await this.database;
    var ratingID = menuObj["ratingID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $RatingIDbasedTable WHERE ratingID="$ratingID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$RatingIDbasedTable", ratingMasterMap(menuObj),
          where: '$ratingIDCol = ?', whereArgs: ['$menuObj']);
    } else {
      result = await db.insert("$RatingIDbasedTable", ratingMasterMap(menuObj));
    }
    return result;
  }

  Map<String, dynamic> ratingMasterMap(menuObj) {
    var map = Map<String, dynamic>();
    map["ratingID"] = menuObj["ratingID"].toString();
    map["ratingName"] = menuObj["ratingName"].toString();
    map["checklistID"] = menuObj["checklistID"].toString();
    map["subChecklistID"] = menuObj["subChecklistID"].toString();
    return map;
  }

  // ChecklistRatingIDbased for table Saving
  Future<int> saveAssignedCAPAMasterData(menuObj, LoginEMPNumber, sync) async {
    int result = 0;
    Database db = await this.database;
    var AcId = menuObj["id"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $AssignedCAPATable WHERE id="$AcId")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$AssignedCAPATable",
          assignedCAPAMasterMap(menuObj, LoginEMPNumber, sync),
          where: '$ACidCol = ?', whereArgs: ['$AcId']);
    } else {
      result = await db.insert("$AssignedCAPATable",
          assignedCAPAMasterMap(menuObj, LoginEMPNumber, sync));
    }
    return result;
  }

  Map<String, dynamic> assignedCAPAMasterMap(menuObj, LoginEMPNumber, sync) {
    var map = Map<String, dynamic>();
    map["id"] = menuObj["id"].toString();
    map["pluginID"] = menuObj["pluginID"].toString();
    map["featureID"] = menuObj["featureID"].toString();
    map["capaFeatureID"] = menuObj["capaFeatureID"].toString();
    map["number"] = menuObj["number"].toString();
    map["objectNumber"] = menuObj["objectNumber"].toString();
    map["auditQuestionID"] = menuObj["auditQuestionID"].toString();
    map["capaType"] = menuObj["capaType"].toString();
    map["capaTitle"] = menuObj["capaTitle"].toString();
    map["capaDetails"] = menuObj["capaDetails"].toString();
    map["capaComments"] = menuObj["capaComments"].toString();
    map["submittedDate"] = menuObj["submittedDate"].toString();
    map["dueDate"] = menuObj["dueDate"].toString();
    map["priority"] = menuObj["priority"].toString();
    map["status"] = menuObj["status"].toString();
    map["assignedFrom"] = menuObj["assignedFrom"].toString();
    map["assignedTo"] = menuObj["assignedTo"].toString();
    map["LoginEMPNumber"] = LoginEMPNumber;
    map["Sync"] = sync;
    return map;
  }

  // CapaModules for table config
  Future<int> saveCapaModulesListMasterData(menuObj) async {
    int result = 0;
    Database db = await this.database;
    var capamoduleID = menuObj["moduleID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $CAPAModulesTable WHERE moduleID="$capamoduleID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update(
          "$CAPAModulesTable", capaModulesMasterMap(menuObj),
          where: '$CmoduleIDCol = ?', whereArgs: ['$capamoduleID']);
    } else {
      result =
          await db.insert("$CAPAModulesTable", capaModulesMasterMap(menuObj));
    }
    return result;
  }

  Map<String, dynamic> capaModulesMasterMap(menuObj) {
    var map = Map<String, dynamic>();
    map["moduleID"] = menuObj["moduleID"].toString();
    map["moduleName"] = menuObj["moduleName"].toString();

    return map;
  }

  // Annexure Draft Audits Saving
  Future<int> saveAnnexureDraftAudits(annexureDetailsObj, type) async {
    int result = 0;
    Database db = await this.database;
    var annexureID = annexureDetailsObj["annexureID"];

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $AnnexureDraftAuditsTable WHERE annexureID="$annexureID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$AnnexureDraftAuditsTable",
          annexureDetailsMap(annexureDetailsObj, type),
          where: '$annexureIDCol = ?', whereArgs: ['$annexureID']);
      ;
    } else {
      result = await db.insert("$AnnexureDraftAuditsTable",
          annexureDetailsMap(annexureDetailsObj, type));
    }
    return result;
  }

  // GOPA Draft Audits Saving
  Future<int> saveGOPADraftAudits(overviewObj, type) async {
    Database db = await this.database;
    var id = overviewObj['auditID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPADraftAuditsTable WHERE $auditID = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    print('isExist');
    print(isExist);
    print('isExist');
    if (isExist == 1) {
      result = await db.update(
          "$GOPADraftAuditsTable", saveGopaDraftDetailsMap(overviewObj, type),
          where: '$auditIDCol = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert(
          "$GOPADraftAuditsTable", saveGopaDraftDetailsMap(overviewObj, type));
    }
    return result;
  }

  // GOPA Draft Audits Saving
  Future<int> saveGOPASearchTrackAudits(gopaDetailsObj) async {
    int result = 0;
    Database db = await this.database;
    var auditID = gopaDetailsObj["auditID"];
    var type = 1;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $GOPASearchTrackAuditsTable WHERE auditID="$auditID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$GOPASearchTrackAuditsTable",
          saveGopaDraftDetailsMap(gopaDetailsObj, type),
          where: '$auditIDCol = ?', whereArgs: ['$auditID']);
      ;
    } else {
      result = await db.insert("$GOPASearchTrackAuditsTable",
          saveGopaDraftDetailsMap(gopaDetailsObj, type));
    }
    return result;
  }

  Future<int> saveGOPAChecklistData(checkListObj) async {
    Database db = await this.database;
    var id = checkListObj['itemID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPACheckListDataTable WHERE $itemIDCol = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    if (isExist == 1) {
      result = await db.update(
          "$GOPACheckListDataTable", AnnexureCheckListMap(checkListObj),
          where: '$itemIDCol = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert(
          "$GOPACheckListDataTable", AnnexureCheckListMap(checkListObj));
    }

    return result;
  }

  saveGOPAOverviewChecklistData(
      overviewchecklistdataObj, auditId, auditNumber, flag) async {
    Database db = await this.database;
    var id = overviewchecklistdataObj['checklistItemID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPAOverviewChecklistTable WHERE $checklistItemIDCol = "$id" AND $objectIDCol = "$auditId")');
    int? isExist = Sqflite.firstIntValue(exist);

    if (isExist == 1) {
      result = await db.update("$GOPAOverviewChecklistTable",
          GOPAOverviewCheckListMap(overviewchecklistdataObj, auditId, flag),
          where: '$checklistItemIDCol = ? AND $objectIDCol=?',
          whereArgs: ['$id', '$auditId']);
    } else {
      result = await db.insert("$GOPAOverviewChecklistTable",
          GOPAOverviewCheckListMap(overviewchecklistdataObj, auditId, flag));
    }
    return result;
  }

  Future<int> saveGopaChecklistData(gopaChecklistBodyObj) async {
    Database db = await this.database;
    var id = gopaChecklistBodyObj['checklistItemID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPAcheckListQstnTable WHERE $itemIDQstnCol = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);

    if (isExist == 1) {
      result = await db.update(
          "$GOPAcheckListQstnTable", GopaCheckListDataMap(gopaChecklistBodyObj),
          where: '$itemIDQstnCol = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert("$GOPAcheckListQstnTable",
          GopaCheckListDataMap(gopaChecklistBodyObj));
    }
    return result;
  }

  Future<int> saveGOPAOverviewDetails(overviewObj) async {
    Database db = await this.database;
    var id = overviewObj['auditID'];
    print("overviewObj----------");
    print(overviewObj);
    print(id);
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GopaOverviewDetailsTable WHERE $auditID = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    print(isExist);
    if (isExist == 1) {
      result = await db.update(
          "$GopaOverviewDetailsTable", saveGopaDetailsMap(overviewObj),
          where: '$auditID = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert(
          "$GopaOverviewDetailsTable", saveGopaDetailsMap(overviewObj));
    }
    return result;
  }

  Future<int> saveAnnexuresOverviewDataforgopa(overviewObj, auditId) async {
    Database db = await this.database;
    var id = overviewObj['annexureID'];
    print("overviewObj----------");
    print(overviewObj);
    print(id);
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $AnnexuresOverviewDataforgopaTable WHERE $auditID = "$auditId" AND annexureID = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    print(isExist);
    if (isExist == 1) {
      result = await db.update("$AnnexuresOverviewDataforgopaTable",
          AnnexuresOverviewDataforgopaMap(overviewObj, auditId),
          where: '$auditID = ? AND annexureID = ?',
          whereArgs: ['$auditId', '$id']);
    } else {
      result = await db.insert("$AnnexuresOverviewDataforgopaTable",
          AnnexuresOverviewDataforgopaMap(overviewObj, auditId));
    }
    return result;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> GopaCheckListDataMap(response) {
    var map = Map<String, dynamic>();
    map["checklistID"] = response["checklistID"].toString();
    map["checkListName"] = response["checkListName"].toString();
    map["itemID"] = response["checklistItemID"].toString();
    map["itemName"] = response["itemName"].toString();
    map["subchecklistID"] = response["subchecklistID"].toString();
    map["subchecklistname"] = response["subchecklistname"].toString();
    map["checklistItemDataID"] = response["checklistItemDataID"].toString();
    map["empID"] = response["empID"].toString();
    map["comments"] = response["comments"].toString();
    map["checklistorder"] = response["checklistorder"].toString();
    map["subChecklistorder"] = response["subChecklistorder"].toString();
    return map;
  }

  Map<String, dynamic> saveGopaDraftDetailsMap(gopaDetailsObj, type) {
    var map = Map<String, dynamic>();
    map["stationName"] = gopaDetailsObj["stationName"].toString();
    map["auditID"] = gopaDetailsObj["auditID"].toString();
    map["gghName"] = gopaDetailsObj["gghName"].toString();
    map["auditDate"] = gopaDetailsObj["auditDate"].toString();
    map["auditDoneby"] = gopaDetailsObj["auditDoneby"].toString();
    map["airlineIDs"] = gopaDetailsObj["airlineIDs"].toString();
    map["statusid"] = gopaDetailsObj["statusid"].toString();
    map["statusName"] = gopaDetailsObj["statusName"].toString();
    map["auditNumber"] = gopaDetailsObj["auditNumber"].toString();
    map["Sync"] = type;
    return map;
  }

  Map<String, dynamic> AnnexuresOverviewDataforgopaMap(
      gopaDetailsObj, auditId) {
    var map = Map<String, dynamic>();
    map["auditId"] = auditId.toString();
    map["id"] = gopaDetailsObj["id"].toString();
    map["annexureID"] = gopaDetailsObj["annexureID"].toString();
    map["airlines"] = gopaDetailsObj["airlines"].toString();
    map["auditDoneBy"] = gopaDetailsObj["auditDoneBy"].toString();
    map["auditDate"] = gopaDetailsObj["auditDate"].toString();
    map["moFullnumber"] = gopaDetailsObj["moFullnumber"].toString();
    map["statusName"] = gopaDetailsObj["statusName"].toString();
    map["statusID"] = gopaDetailsObj["statusID"].toString();
    return map;
  }

  Map<String, dynamic> saveGopaDetailsMap(gopaDetailsObj) {
    var map = Map<String, dynamic>();
    map["stationName"] = gopaDetailsObj["stationName"].toString();
    map["auditID"] = gopaDetailsObj["auditID"].toString();
    map["HoNumber"] = gopaDetailsObj["HoNumber"].toString();
    map["groundHandler"] = gopaDetailsObj["groundHandler"].toString();
    map["auditDate"] = gopaDetailsObj["auditDate"].toString();
    map["auditDoneby"] = gopaDetailsObj["auditDoneby"].toString();
    map["airlineIDs"] = gopaDetailsObj["airlineIDs"].toString();
    map["statusid"] = gopaDetailsObj["statusid"].toString();
    map["statusName"] = gopaDetailsObj["statusName"].toString();
    map["auditNumber"] = gopaDetailsObj["auditNumber"].toString();
    map["restartOperations"] = gopaDetailsObj["restartoperations"].toString();
    map["allAirlinesSameServiceProvider"] =
        gopaDetailsObj["allAirlinesSameServiceProvider"].toString();
    map["gghid"] = gopaDetailsObj["gghid"].toString();
    map["stationID"] = gopaDetailsObj["stationID"].toString();
    map["submittedBy"] = gopaDetailsObj["submittedBy"].toString();
    map["userID"] = gopaDetailsObj["userID"].toString();
    map["msg"] = gopaDetailsObj["msg"].toString();
    map["submittedDate"] = gopaDetailsObj["submittedDate"].toString();
    map["restartoperations"] = gopaDetailsObj["restartoperations"].toString();
    map["sameserviceprovider"] =
        gopaDetailsObj["sameserviceprovider"].toString();
    map["gopaNumber"] = gopaDetailsObj["gopaNumber"].toString();
    map["pBhandling"] = gopaDetailsObj["pBhandling"].toString();
    map["ramphandling"] = gopaDetailsObj["ramphandling"].toString();
    map["cargohandling"] = gopaDetailsObj["cargohandling"].toString();
    map["deicingoperations"] = gopaDetailsObj["deicingoperations"].toString();
    map["aircraftMarshalling"] =
        gopaDetailsObj["aircraftMarshalling"].toString();
    map["loadcontrol"] = gopaDetailsObj["loadcontrol"].toString();
    map["aircraftmovement"] = gopaDetailsObj["aircraftmovement"].toString();
    map["headsetcommunication"] =
        gopaDetailsObj["headsetcommunication"].toString();
    map["passengerbridge"] = gopaDetailsObj["passengerbridge"].toString();
    map["isago"] = gopaDetailsObj["isago"].toString();
    map["duedate"] = gopaDetailsObj["duedate"].toString();
    map["pBhandlingID"] = gopaDetailsObj["pBhandlingID"].toString();
    map["ramphandlingID"] = gopaDetailsObj["ramphandlingID"].toString();
    map["cargohandlingID"] = gopaDetailsObj["cargohandlingID"].toString();
    map["deicingoperationsID"] =
        gopaDetailsObj["deicingoperationsID"].toString();
    map["aircraftMarshallingID"] =
        gopaDetailsObj["aircraftMarshallingID"].toString();
    map["loadcontrolID"] = gopaDetailsObj["loadcontrolID"].toString();
    map["aircraftmovementID"] = gopaDetailsObj["aircraftmovementID"].toString();
    map["headsetcommunicationID"] =
        gopaDetailsObj["headsetcommunicationID"].toString();
    map["passengerbridgeID"] = gopaDetailsObj["passengerbridgeID"].toString();
    map["isagoid"] = gopaDetailsObj["isagoid"].toString();
    map["restartoperationsID"] =
        gopaDetailsObj["restartoperationsID"].toString();
    map["sameserviceproviderID"] =
        gopaDetailsObj["sameserviceproviderID"].toString();
    map["duedateID"] = gopaDetailsObj["duedateID"].toString();
    map["reason"] = gopaDetailsObj["reason"].toString();
    map["pBhandlingServiceProvider"] =
        gopaDetailsObj["pBhandlingServiceProvider"].toString();
    map["ramphandlingServiceProvider"] =
        gopaDetailsObj["ramphandlingServiceProvider"].toString();
    map["cargohandlingServiceProvider"] =
        gopaDetailsObj["cargohandlingServiceProvider"].toString();
    map["deicingoperationsServiceProvider"] =
        gopaDetailsObj["deicingoperationsServiceProvider"].toString();
    map["aircraftMarshallingServiceProvider"] =
        gopaDetailsObj["aircraftMarshallingServiceProvider"].toString();
    map["loadcontrolServiceProvider"] =
        gopaDetailsObj["loadcontrolServiceProvider"].toString();
    map["aircraftmovementServiceProvider"] =
        gopaDetailsObj["aircraftmovementServiceProvider"].toString();
    map["headsetcommunicationServiceProvider"] =
        gopaDetailsObj["headsetcommunicationServiceProvider"].toString();
    map["passengerbridgeServiceProvider"] =
        gopaDetailsObj["passengerbridgeServiceProvider"].toString();
    return map;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> GOPAOverviewCheckListMap(response, auditId, flag) {
    var map = Map<String, dynamic>();

    map["objectID"] = response["objectID"].toString();
    map["checklistID"] = response["checklistID"].toString();
    map["checklistItemID"] = response["checklistItemID"].toString();
    map["checklistItemDataID"] = response["checklistItemDataID"].toString();
    map["empID"] = response["empID"].toString();
    map["comments"] = response["comments"].toString();
    map["checkListName"] = response["checkListName"].toString();
    map["itemName"] = response["itemName"].toString();
    map["subchecklistID"] = response["subchecklistID"].toString();
    map["subchecklistname"] = response["subchecklistname"].toString();
    map["checklistorder"] = response["checklistorder"].toString();
    map["subChecklistorder"] = response["subChecklistorder"].toString();
    map["attachfileManadatory"] = response["attachfileManadatory"].toString();

    if (response["imagename"].toString() != "") {
      // if(flag == 1){
      //   map["attachmentBaseImg"] = attachedBaseImg;
      // }else{
      //
      // }
      map["imagename"] = response["imagename"].toString();
      map["attachmentName"] = response["attachmentName"].toString();
      map["attachmentBaseImg"] = response["attachmentBaseImg"].toString();
    } else {
      map["imagename"] = "";
      map["attachmentName"] = "";
      map["attachmentBaseImg"] = "";
    }

    return map;
  }

  // Annexure Search Track Audits Saving
  Future<int> saveAnnexureSearchTrackAudits(annexureTrackAuditsObj) async {
    int result = 0;
    Database db = await this.database;
    var annexureID = annexureTrackAuditsObj["annexureID"];
    var type = 1;

    var exists = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $AnnexureSearchTrackAuditsTable WHERE annexureID="$annexureID")',
    );
    int? isExist = Sqflite.firstIntValue(exists);
    if (isExist == 1) {
      result = await db.update("$AnnexureSearchTrackAuditsTable",
          annexureDetailsMap(annexureTrackAuditsObj, type),
          where: '$annexureIDCol = ?', whereArgs: ['$annexureTrackAuditsObj']);
      ;
    } else {
      result = await db.insert("$AnnexureSearchTrackAuditsTable",
          annexureDetailsMap(annexureTrackAuditsObj, type));
    }
    return result;
  }

  Map<String, dynamic> annexureDetailsMap(annexureDetailsObj, type) {
    var map = Map<String, dynamic>();
    map["annexureID"] = annexureDetailsObj["annexureID"].toString();
    map["annexureNumber"] = annexureDetailsObj["annexureNumber"].toString();
    map["stationName"] = annexureDetailsObj["stationName"].toString();
    map["airlineName"] = annexureDetailsObj["airlineName"].toString();
    map["status"] = annexureDetailsObj["status"].toString();
    map["auditDoneBy"] = annexureDetailsObj["auditDoneBy"].toString();
    map["msg"] = annexureDetailsObj["msg"].toString();
    map["auditDate"] = annexureDetailsObj["auditDate"].toString();
    map["Sync"] = type;
    return map;
  }

  Future<int> saveAnnexureChecklist(checkListObj) async {
    Database db = await this.database;
    var id = checkListObj['itemID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $AnnexureCheckListTable WHERE $itemIDCol = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    if (isExist == 1) {
      result = await db.update(
          "$AnnexureCheckListTable", AnnexureCheckListMap(checkListObj),
          where: '$itemIDCol = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert(
          "$AnnexureCheckListTable", AnnexureCheckListMap(checkListObj));
    }
    return result;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> AnnexureCheckListMap(response) {
    var map = Map<String, dynamic>();
    map["checkListID"] = response["checkListID"].toString();
    map["checkListName"] = response["checkListName"].toString();
    map["itemID"] = response["itemID"].toString();
    map["itemName"] = response["itemName"].toString();
    map["subchecklistID"] = response["subchecklistID"].toString();
    map["subchecklistname"] = response["subchecklistname"].toString();
    map["checklistorder"] = response["checklistorder"].toString();
    map["subChecklistorder"] = response["subChecklistorder"].toString();
    map["attachfileManadatory"] = response["attachfileManadatory"].toString();
    return map;
  }

  Future<int> saveAnnexureOverviewChecklist(
      overviewchecklistdataObj, annexuresNumber) async {
    Database db = await this.database;
    var id = overviewchecklistdataObj['checklistItemID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $AnnexureOverviewChecklistTable WHERE $checklistItemIDCol = "$id" AND $annexuresNumberCol = "$annexuresNumber")');
    int? isExist = Sqflite.firstIntValue(exist);

    if (isExist == 1) {
      result = await db.update(
          "$AnnexureOverviewChecklistTable",
          AnnexureOverviewCheckListMap(
              overviewchecklistdataObj, annexuresNumber),
          where: '$checklistItemIDCol = ? AND $annexuresNumberCol=?',
          whereArgs: ['$id', '$annexuresNumber']);
    } else {
      result = await db.insert(
          "$AnnexureOverviewChecklistTable",
          AnnexureOverviewCheckListMap(
              overviewchecklistdataObj, annexuresNumber));
    }
    return result;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> AnnexureOverviewCheckListMap(response, annexuresNumber) {
    var map = Map<String, dynamic>();
    map["objectID"] = response["objectID"].toString();
    map["annexuresNumber"] = annexuresNumber;
    map["checklistID"] = response["checklistID"].toString();
    map["checklistItemID"] = response["checklistItemID"].toString();
    map["checklistItemDataID"] = response["checklistItemDataID"].toString();
    map["empID"] = response["empID"].toString();
    map["comments"] = response["comments"].toString();
    map["checkListName"] = response["checkListName"].toString();
    map["itemName"] = response["itemName"].toString();
    map["subchecklistID"] = response["subchecklistID"].toString();
    map["subchecklistname"] = response["subchecklistname"].toString();
    map["checklistorder"] = response["checklistorder"].toString();
    map["subChecklistorder"] = response["subChecklistorder"].toString();
    map["attachfileManadatory"] = response["attachfileManadatory"].toString();
    if (response["imagename"].toString().isNotEmpty) {
      map["imagename"] = response["imagename"].toString();
    } else {
      map["imagename"] = 0;
    }
    return map;
  }

  Future<int> saveAnnexureOverviewDetails(overviewObj) async {
    Database db = await this.database;
    var id = overviewObj['annexuresID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $AnnexureOverviewDetailsTable WHERE $annexuresIDCol = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    print(isExist);
    if (isExist == 1) {
      result = await db.update("$AnnexureOverviewDetailsTable",
          AnnexureOverviewDetailsMap(overviewObj),
          where: '$annexuresIDCol = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert("$AnnexureOverviewDetailsTable",
          AnnexureOverviewDetailsMap(overviewObj));
    }
    return result;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> AnnexureOverviewDetailsMap(response) {
    var map = Map<String, dynamic>();
    map["stationID"] = response["stationID"].toString();
    map["stationName"] = response["stationName"].toString();
    map["annexuresID"] = response["annexuresID"].toString();
    map["flightDate"] = response["flightDate"].toString();
    map["flightNo"] = response["flightNo"].toString();
    map["auditDate"] = response["auditDate"].toString();
    map["auditDoneBy"] = response["auditDoneby"].toString();
    map["marshallingaircraftdoneby"] =
        response["marshallingaircraftdoneby"].toString();
    map["marshallingaircraftdonebyId"] =
        response["marshallingaircraftdonebyId"].toString();
    map["statusid"] = response["statusid"].toString();
    map["statusName"] = response["statusName"].toString();
    map["airlineID"] = response["airlineID"].toString();
    map["airlineName"] = response["airlineName"].toString();
    map["submittedBy"] = response["submittedBy"].toString();
    map["userID"] = response["userID"].toString();
    map["gopaNumber"] = response["gopaNumber"].toString();
    map["annexuresNumber"] = response["annexuresNumber"].toString();
    map["previousAuditFlightNo"] = response["previousAuditFlightNo"].toString();
    map["previousAuditDate"] = response["previousAuditDate"].toString();
    map["passengerHandlingstaff"] =
        response["passengerHandlingstaff"].toString();
    map["loadControlstaff"] = response["loadControlstaff"].toString();
    map["rampHandlingstaff"] = response["rampHandlingstaff"].toString();
    map["equipmentOperators"] = response["equipmentOperators"].toString();
    map["passengerBoardingBridge"] =
        response["passengerBoardingBridge"].toString();
    map["passengerBoardingBridgeId"] =
        response["passengerBoardingBridgeId"].toString();
    return map;
  }

  /*Configuratio Tables End*/

  Future<int> saveorupdateCheckListQstns(checkListObj) async {
    Database db = await this.database;
    var id = checkListObj['itemID'];
    int result = 0;
    var exist = await db.rawQuery(
        'SELECT EXISTS(SELECT 1 FROM $GOPAcheckListQstnTable WHERE $itemIDQstnCol = "$id")');
    int? isExist = Sqflite.firstIntValue(exist);
    if (isExist == 1) {
      result = await db.update(
          "$GOPAcheckListQstnTable", ChekListQstnsMap(checkListObj),
          where: '$itemIDQstnCol = ?', whereArgs: ['$id']);
    } else {
      result = await db.insert(
          "$GOPAcheckListQstnTable", ChekListQstnsMap(checkListObj));
    }
    return result;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> ChekListQstnsMap(response) {
    var map = Map<String, dynamic>();
    map["checkListID"] = response["checkListID"].toString();
    map["checkListName"] = response["checkListName"].toString();
    map["itemID"] = response["itemID"].toString();
    map["itemName"] = response["itemName"].toString();
    /*NEW ADDED */
    // map["subchecklistID"] = response["subchecklistID"].toString();
    // map["subchecklistname"] = response["subchecklistname"].toString();
    // map["checklistorder"] = response["checklistorder"].toString();
    // map["subChecklistorder"] = response["subChecklistorder"].toString();

    return map;
  }

  Future<List<Map<String, dynamic>>> getGOPAcheckListQstn() async {
    Database db = await this.database;
    var chkLisQstnstobj = await db.rawQuery(
        "SELECT * FROM $GOPAcheckListQstnTable group by $itemIDQstnCol");
    return chkLisQstnstobj;
  }

  //GOPA Check List saving
  Future<int> saveGOPAcheckList(checkDetails, checkListObj, requestbody) async {
    Database db = await this.database;

    var requestbodyObj = jsonDecode(requestbody);
    var checkDetailsObj = jsonDecode(checkDetails);
    var auditId = checkDetailsObj['auditId'];

    int result = 0;

    var exist = await db.rawQuery(
        'Select EXISTS(SELECT 1 FROM $GOPAcheckListTable Where $auditIDCol = "$auditId")');

    int? isExist = Sqflite.firstIntValue(exist);

    // for (int i = 0; i < checkListObj.length; i++) {
    //   var chkListobj = jsonDecode(checkListObj[i]);
    //    var checkId= chkListobj['chkId'];
    //
    //
    //   if(isExist == 1){
    //
    //      result= await db.update("$GOPAcheckListTable",GOPACheckListToMap(chkListobj, checkDetailsObj, requestbodyObj),where:'$chkIdCol = ? AND $auditIDCol=?',whereArgs: ['$checkId','$auditId']);
    //    }else{
    //
    //      if(auditId !=""){
    //        checkDetailsObj['auditId']=auditId;
    //      }else{
    //        checkDetailsObj['auditId']="OFF1";
    //      }
    //        result = await db.insert("$GOPAcheckListTable",
    //         GOPACheckListToMap(chkListobj, checkDetailsObj, requestbodyObj));
    //    }
    //
    // }
    //}

    if (isExist == 1) {
      result = await db.update("$GOPAcheckListTable",
          GOPACheckListToMap(checkListObj, checkDetailsObj, requestbodyObj),
          where: '$chkIdCol = ? AND $auditIDCol=?', whereArgs: ['$auditId']);
    } else {
      if (auditId != "") {
        checkDetailsObj['auditId'] = auditId;
      } else {
        checkDetailsObj['auditId'] = "OFF1";
      }
      result = await db.insert("$GOPAcheckListTable",
          GOPACheckListToMap(checkListObj, checkDetailsObj, requestbodyObj));
    }

    return result;
  }

  Map<String, dynamic> GOPACheckListToMap(
      obj, checkDetailsObj, requestbodyObj) {
    var map = Map<String, dynamic>();
    // map['chkName'] = obj['chkName'].toString();
    // map['chkId'] = obj['chkId'].toString();
    // map['uploadFileName'] = obj['uploadFileName'].toString();
    // map['followUp'] = obj['followUp'].toString();
    // map['ratingStatus'] = obj['ratingStatus'].toString();
    // map['id'] = obj['id'].toString();
    // map['subHeading'] = obj['subHeading'].toString();
    map['airlineIds'] = checkDetailsObj['airlineIds'].toString();
    map['airlineCode'] = checkDetailsObj['airlineCode'].toString();
    map['auditId'] = checkDetailsObj['auditId'].toString();
    // map['auditNumber'] = obj['auditNumber'].toString();
    map['stationId'] = checkDetailsObj['stationId'].toString();
    map['Statusid'] = requestbodyObj['Statusid'].toString();
    map['stationAirport'] = checkDetailsObj['stationAirport'].toString();
    map['groundHandlerId'] = checkDetailsObj['groundHandlerId'].toString();
    map['groundHandler'] = checkDetailsObj['groundHandler'].toString();
    map['auditDate'] = checkDetailsObj['auditDate'].toString();
    map['conductedId'] = requestbodyObj['AuditDoneby'].toString();
    map['userID'] = requestbodyObj['SubmittedBy'].toString();
    map['conductAudit'] = checkDetailsObj['conductAudit'].toString();
    map['isSynched'] = requestbodyObj['isSynched'].toString();
    // map['isDeleted'] = checkDetailsObj['conductAudit'].toString();

    return map;
  }

  //GopA draft data by Empnumber

  Future<List<Map<String, dynamic>>> getGOPAItemImageData(
      AuditID, AuditNumber, ChecklistID, ChecklistItemID, FileName) async {
    Database db = await this.database;

    var draftObj = await db.rawQuery(
        'SELECT * from $SaveFileAttachmentforChecklistTable WHERE AuditID="$AuditID" AND AuditNumber="$AuditNumber" AND ChecklistID="$ChecklistID" AND ChecklistItemID="$ChecklistItemID"');

    return draftObj;
  }

  Future<List<Map<String, dynamic>>> getOfflineGOPAItemImageData(
      auditNumber) async {
    Database db = await this.database;

    var draftObj = await db.rawQuery(
        'SELECT *  from $SaveFileAttachmentforChecklistTable WHERE AuditNumber = "$auditNumber" AND flag = "0"');
    // var draftObj = await db.rawQuery(
    //     'SELECT PluginID,AuditID,AuditNumber,featurID, ChecklistID, ChecklistItemID,SubchecklistID,FileName, AttachedBy, flag from $SaveFileAttachmentforChecklistTable WHERE AuditNumber = "$auditNumber" AND flag = "0" ');

    return draftObj;
  }

  Future<List<Map<String, dynamic>>> getOfflineGOPAItemImageJsonData(
      auditNumber) async {
    Database db = await this.database;

    var draftObj = await db.rawQuery(
        'SELECT PluginID,AuditID,AuditNumber,featurID, ChecklistID, ChecklistItemID,SubchecklistID,FileName,FilePath, AttachedBy, flag from $SaveFileAttachmentforChecklistTable WHERE AuditNumber = "$auditNumber" AND flag = "0" ');

    return draftObj;
  }

  Future<List<Map<String, dynamic>>> getOfflineGOPAItemImageDataBasedIDS(
      PluginID,
      AuditID,
      AuditNumber,
      featurID,
      ChecklistID,
      ChecklistItemID,
      SubchecklistID,
      FileName,
      AttachedBy,
      flag) async {
    Database db = await this.database;
    var draftObj = db.rawQuery(
        'SELECT ImageBase64 from $SaveFileAttachmentforChecklistTable WHERE PluginID= "$PluginID" AND AuditID= "$AuditID" AND AuditNumber = "$AuditNumber" AND  featurID= "$featurID" AND ChecklistID= "$ChecklistID"  AND ChecklistItemID= "$ChecklistItemID" AND SubchecklistID= "$SubchecklistID" AND FileName= "$FileName" AND AttachedBy= "$AttachedBy" AND flag = "0" ');
    print("draftObj");

    return draftObj;
  }

  //GOPA Check List Obj
  Future<List<Map<String, dynamic>>> getGOPACheckListByAuditId(
    auditId,
  ) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $GOPAcheckListTable Where $auditIdChkCol = "$auditId" ');
    return result;
  }

  //GopA draft data by Empnumber

  Future<List<Map<String, dynamic>>> getGOPADraftByEmpNumber(
      empNumber, statusId) async {
    Database db = await this.database;

    var draftObj = await db.rawQuery(
        'SELECT * from $GOPAcheckListTable Where $conductedIdCol="$empNumber" AND $statusIdGOPACol="$statusId"  group by $auditIdChkCol');
    //var draftObj = await db.rawQuery('SELECT * from $GOPAcheckListTable Where $conductedIdCol="$empNumber" AND $statusIdGOPACol="$statusId"  group by "$stationIdCol"');

    return draftObj;
  }

  //GOPA Check List By Filters
  Future<List<Map<String, dynamic>>> getGOPACheckList() async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $GOPAcheckListTable group by $auditIdChkCol');
    return result;
  }

  //GOPA Check List By Filters
  Future<List<Map<String, dynamic>>> getGOPADraftCheckList() async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'SELECT * FROM $GOPAcheckListTable where $isSynchedCol="1" group by $auditIdChkCol');
    return result;
  }

  //GOPA Check List By Filters
  Future<List<Map<String, dynamic>>> getGOPADraftCheckLists() async {
    Database db = await this.database;
    var result = await db
        .rawQuery('SELECT * FROM $GOPAcheckListTable where $isSynchedCol="1"');
    return result;
  }

  //GOPA Delete
  deleteCheckList(auditId) async {
    Database db = await this.database;
    db.rawDelete(
        'DELETE FROM $GOPAcheckListTable WHERE  $auditIdChkCol =$auditId');
  }

  //GOPA Delete
  // deleteIsMOExistsByAirlineID(airlineID) async {
  //   Database db = await this.database;
  //   await db
  //       .rawQuery('UPDATE $IsMOexistsTable SET moExist = '0' WHERE  $AirlineID  ="$airlineID" AND flag = 1');
  //   db.rawDelete(
  //       'DELETE FROM $IsMOexistsTable WHERE  $AirlineID ="$airlineID" AND flag = 1');
  // }

  Future<int> UpdateIsMOExists(airlineID) async {
    int result = 0;
    Database db = await this.database;

    result = await db.update("$IsMOexistsTable", UpdateIsMOExistsMap(airlineID),
        where: 'AirlineID = ? AND flag = 1', whereArgs: ['$airlineID']);
    return result;
  }

  Map<String, dynamic> UpdateIsMOExistsMap(airlineID) {
    var map = Map<String, dynamic>();
    map["moExist"] = 0;
    return map;
  }

  //GOPA Delete
  Future<int> deleteDraftedGOPAS(auditID, auditNumber) async {
    print("Deleted1111 data");
    print(auditID);
    print(auditNumber);
    Database db = await this.database;
    var tbl1 = await db.rawDelete(
        'DELETE FROM $GOPADraftAuditsTable WHERE auditID ="$auditID" AND auditNumber = "$auditNumber"');
    await db.rawDelete(
        'DELETE FROM $GopaOverviewDetailsTable WHERE auditID ="$auditID"');
    await db.rawDelete(
        'DELETE FROM $GOPAOverviewChecklistTable WHERE objectID ="$auditID"');

    return tbl1;
  }

  //GOPA Delete
  Future<int> deleteDraftedMOs(moID) async {
    print("Deleted data");
    print(moID);
    Database db = await this.database;
    var tbl2 = await db.rawDelete(
        'DELETE FROM $AnnexureDraftAuditsTable WHERE annexureID ="$moID"');
    await db.rawDelete(
        'DELETE FROM $AnnexureOverviewDetailsTable WHERE annexuresID ="$moID"');
    await db.rawDelete(
        'DELETE FROM $AnnexureOverviewChecklistTable WHERE objectID ="$moID"');
    await db.rawDelete(
        "DELETE FROM $SaveFileAttachmentforChecklistTable WHERE AuditID = '$moID'");
    return tbl2;
  }

  // Insert Operation: Insert a CheckList object to database
  Future<int> saveUserDetails(response) async {
    Database db = await this.database;
    var result =
        await db.insert("$userdetailsTable", toUserDetailsMap(response));
    return result;
  }

  // Convert a UserLogin object into a Map object
  Map<String, dynamic> toUserDetailsMap(response) {
    var map = Map<String, dynamic>();
    map["employeeID"] = response["employeeID"].toString();
    map["firstName"] = response["firstName"].toString();
    map["lastName"] = response["lastName"].toString();
    map["employeeCode"] = response["employeeCode"].toString();
    map["contactNo"] = response["contactNo"].toString();
    map["employeeType"] = response["employeeType"].toString();
    map["userID"] = response["userID"].toString();
    map["emailID"] = response["emailID"].toString();
    map["imageBase64"] = response["imageBase64"].toString();

    return map;
  }

  //Insert employee data into  database
  Future<int> saveEmployee(response) async {
    Database db = await this.database;
    var result =
        await db.insert("$employeeTable", toEmployeeDetailsMap(response));

    return result;
  }

  // Convert a Employee object into a Map object
  Map<String, dynamic> toEmployeeDetailsMap(response) {
    var map = Map<String, dynamic>();
    map["employeeID"] = response["employeeID"].toString();
    map["employeeNumber"] = response["employeeNumber"].toString();
    map["employeeName"] = response["employeeName"].toString();
    map["employeeNamewithNumber"] =
        response["employeeNamewithNumber"].toString();

    return map;
  }

  //Insert employee data into  database
  Future<int> saveFlightDetails(response) async {
    Database db = await this.database;
    var result = await db.insert("$flightTable", toFlightDetailsMap(response));

    return result;
  }

  //I sExist or Not
  Future<bool> getFlightById(value) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'Select Exists(Select 1 from "$flightTable" where "$flightNumberCol"= "$value")');
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  //getFlight Details
  Future getFlightDetailsByNum(flightNum) async {
    Database db = await this.database;
    var flightObj = await db.rawQuery(
        'Select * from "$flightTable" where $flightNumberCol="$flightNum"');

    return flightObj;
  }

  // Convert a Employee object into a Map object
  Map<String, dynamic> toFlightDetailsMap(response) {
    var map = Map<String, dynamic>();
    map["id"] = response["id"].toString();
    map["flightNumber"] = response["flightNumber"].toString();
    map["destinationFrom"] = response["destinationFrom"].toString();
    map["sector"] = response["sector"].toString();
    map["flightDateandTime"] = response["flightDateandTime"].toString();
    map["aircraftType"] = response["aircraftType"].toString();
    map["destinationTo"] = response["destinationTo"].toString();

    return map;
  }

  Future<int> saveOrUpdateAuditSummary(response) async {
    Database db = await this.database;
    int result = 0;
    var empNumber = response["cabicrewNo"].toString();
    var itemId = response["itemID"].toString();
    var auditID = response["auditID"].toString();
    var isExist = await getSummaryByEmpItem(empNumber, itemId, auditID);
    if (isExist) {
      result = await db.update(
          "$auditSummaryTable", toAuditSummaryMap(response),
          where:
              '$cabicrewNoCol = ? AND $summaryItemIDCol =?  AND $auditIDCol =?',
          whereArgs: ['$empNumber', '$itemId', '$auditID']);
    } else {
      result =
          await db.insert("$auditSummaryTable", toAuditSummaryMap(response));
    }
    return result;
  }

  Future<List<Map<String, Object?>>> getCheckListByEmp(empNumber) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        'select famTypeID,checkListName,itemName,famOne,famTwo,famThree  from $auditSummaryTable where $cabicrewNoCol = "$empNumber"');
    return result;
  }
  // Update Operation: Update a Note object and save it to database
//   Future<int> updateNote(Note note) async {
//     var db = await this.database;
//     var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
//     return result;
//   }

  // Future<List<Map<String, Object?>>> getSummaryByEmpItem(empNumber,itemId) async{
  //   Database db = await this.database;
  //
  //   //var  result = await db.rawQuery("select cabicrewNo from $auditSummaryTable where cabicrewNo = ? and itemID =?", new String []{"hjj","hgjgj"});
  //   var  result = await db.rawQuery(
  //       'SELECT count(flightScheduleID) FROM auditSummary WHERE cabicrewNo=? and itemID=? ',
  //       ['Andrew Benjamin (100422)', '1847']
  //   );
  //   print("output");
  //   return result;
  // }

// get Checklist Summary based on emp Item
  Future<bool> getSummaryByEmpItem(empNumber, itemId, auditID) async {
    Database db = await this.database;
    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM auditSummary WHERE cabicrewNo="$empNumber" AND itemID="$itemId" AND  auditID="$auditID")',
    );
    int? exists = Sqflite.firstIntValue(result);

    return exists == 1;
  }

  // Audit Summary obj to map
  Map<String, dynamic> toAuditSummaryMap(response) {
    var map = Map<String, dynamic>();
    map["cabicrewNo"] = response["cabicrewNo"].toString();
    map["auditID"] = response["auditID"].toString();
    map["auditStatus"] = response["auditStatus"].toString();
    map["auditDoneBy"] = response["auditDoneBy"].toString();
    map["flightScheduleID"] = response["flightScheduleID"].toString();
    map["famTypeID"] = response["famTypeID"].toString();
    map["famTypeName"] = response["famTypeName"].toString();
    map["famStatusID"] = response["famStatusID"].toString();
    map["famStatusName"] = response["famStatusName"].toString();
    map["checklistID"] = response["checklistID"].toString();
    map["checklistName"] = response["checklistName"].toString();
    map["itemID"] = response["itemID"].toString();
    map["itemName"] = response["itemName"].toString();

    switch (response["famTypeID"]) {
      case "1":
        map["famOne"] = response["itemDataID"].toString();
        break;
      case "2":
        map["famTwo"] = response["itemDataID"].toString();
        break;
      case "3":
        map["famThree"] = response["itemDataID"].toString();
        break;
      case "4":
        map["famFour"] = response["itemDataID"].toString();
        break;
      case "5":
        map["famFive"] = response["itemDataID"].toString();
        break;
      case "6":
        map["checkFlightOne"] = response["itemDataID"].toString();
        break;
      case "7":
        map["checkFlightTwo"] = response["itemDataID"].toString();
        break;
    }

    return map;
  }

  //save or update Check List

  Future<int> saveorupdateCheckList(checkList) async {
    var db = await this.database;
    var result = 0;
    var len = checkList['CCAChecklistsList'].length;
    var CabicrewNo = checkList['CabicrewNo'].toString();
    var FAMType = checkList['FAMType'].toString();
    //var FAMType= 4;
    var isExist = await getCheckListObjByEmp(CabicrewNo, FAMType);
    if (isExist) {
      for (int i = 0; i < len; i++) {
        var checklistItemID =
            checkList['CCAChecklistsList'][i]['checklistItemID'];
        result = await db.update("$AuditCheckListTable",
            toCheckListMap(checkList, checkList['CCAChecklistsList'][i]),
            where: '$ChecklistItemIDCol=?', whereArgs: ['$checklistItemID']);
      }
    } else {
      for (int i = 0; i < len; i++) {
        result = await db.insert("$AuditCheckListTable",
            toCheckListMap(checkList, checkList['CCAChecklistsList'][i]));
      }
    }

    return result;
  }

//convert Check list onject to Map
  Map<String, dynamic> toCheckListMap(checkListObj, checkListItem) {
    var map = Map<String, dynamic>();
    map['CCAID'] = checkListObj['CCAID'].toString();
    map['CabicrewNo'] = checkListObj['CabicrewNo'].toString();
    map['AuditDoneby'] = checkListObj['AuditDoneby'].toString();
    map['Statusid'] = checkListObj['Statusid'].toString();
    map['FlightSceduleID'] = checkListObj['FlightSceduleID'].toString();
    map['FAMType'] = checkListObj['FAMType'].toString();
    map['FAMStatus'] = checkListObj['FAMStatus'].toString();
    map['Comments'] = checkListObj['Comments'].toString();
    map['UserID'] = checkListObj['UserID'].toString();

    map['ObjectID'] = checkListItem['ObjectID'].toString();
    map['ChecklistID'] = checkListItem['ChecklistID'].toString();
    map['checklistItemID'] = checkListItem['checklistItemID'].toString();
    map['ChecklistItemDataID'] =
        checkListItem['ChecklistItemDataID'].toString();
    map['EmpID'] = checkListItem['EmpID'].toString();
    map['Comments'] = checkListItem['Comments'].toString();

    return map;
  }

  // is check list availble based on employee number or not
  Future<bool> getCheckListObjByEmp(CabicrewNo, FAMType) async {
    Database db = await this.database;
    var result = await db.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM $AuditCheckListTable WHERE $CabicrewNoCol="$CabicrewNo" AND $FAMTypeCol= "$FAMType")',
    );
    int? exists = Sqflite.firstIntValue(result);

    return exists == 1;
  }

  // save online checklist
  Future<int> saveOnlineCheckList(checkList) async {
    var db = await this.database;
    var result = 0;
    var len = checkList['crewcheckList'].length;

    var heading = checkList['heading'];
    for (int i = 0; i < len; i++) {
      var inner = jsonDecode(checkList['crewcheckList'][i]);
      var chkName = inner['chkName'].toString();
      var ratingStatus = inner['ratingStatus'].toString();
      result = await db.insert("$AuditCheckListTable",
          toOnlineCheckListMap(heading, chkName, ratingStatus));
    }

    return result;
  }

  Map<String, dynamic> toOnlineCheckListMap(heading, chkName, ratingStatus) {
    var map = Map<String, String>();
    map['ChecklistID'] = heading.toString();
    map['checklistItemID'] = chkName.toString();
    map['ChecklistItemDataID'] = ratingStatus.toString();
    return map;
  }

  Future<List<Map<String, dynamic>>> getCheckListbyFam() async {
    Database db = await this.database;
    var checkListobj = await db.rawQuery("SELECT * FROM $AuditCheckListTable ");
    return checkListobj;
  }
}
