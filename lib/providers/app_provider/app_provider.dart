import 'package:SerialMan/providers/serviceTaker_provider/service_center_search_provider/service_center_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addButtonServiceType_Provider/deleteServiceTypeProvider/deleteServiceTypeProvider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addButton_provider/deleteServiceCenter/delete_serviceCenter.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addUser_serviceCenter_provider/addUser_serviceCenter_provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addUser_serviceCenter_provider/deleteUserProvider/deleteUserProvider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addUser_serviceCenter_provider/getAddUser_serviceCenterProvider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/addUser_serviceCenter_provider/update_addUser_serviceCenter/update_addUser_serviceCenter.dart';
import 'package:SerialMan/providers/serviceCenter_provider/divisionProvider/divisionProvider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/update_organization_settingScreen/get_update_organization/get_update_organization_provider.dart';
import 'package:SerialMan/providers/serviceCenter_provider/update_organization_settingScreen/update_organization_Provider.dart';

import '../auth_provider/auth_providers.dart';
import '../auth_provider/password_upadate_provider.dart';
import '../profile_provider/getprofile_provider.dart';
import '../profile_provider/profile_update_provider.dart';
import '../serviceCenter_provider/addButtonServiceType_Provider/addButtonServiceType_Provider.dart';
import '../serviceCenter_provider/addButtonServiceType_Provider/getAddButtonServiceType.dart';
import '../serviceCenter_provider/addButton_provider/add_Button_serviceCanter_provider.dart';
import '../serviceCenter_provider/addButton_provider/get_AddButton_provider.dart';
import '../serviceCenter_provider/addUser_serviceCenter_provider/SingleUserInfoProvider/singleUserInfoProvider.dart';
import '../serviceCenter_provider/add_service_center_serviceType_provider/add_service_center_service_type_provider.dart';
//import '../serviceCenter_provider/all_delete_service/delete_service_type_service_type_provider.dart';
import '../serviceCenter_provider/business_type_provider/business_type_provider.dart';
import '../serviceCenter_provider/company_details_provider/company_details_provider.dart';
//import '../serviceCenter_provider/delete_service_type_service_type_provider/delete_service_type_service_type_provider.dart';
import '../serviceCenter_provider/delete_device_type_service_typeProvider/delete_service_type_service_type_provider.dart';
import '../serviceCenter_provider/editButtonServiceType_provider/editButtonServiceType_provider.dart';
import '../serviceCenter_provider/editButtonServiceType_provider/getEditButtonServiceType_Provider.dart';
import '../serviceCenter_provider/editButton_serviceCenter_provider/edit_Button_serviceCenter_Provider.dart';
import '../serviceCenter_provider/editButton_serviceCenter_provider/get_EditButton_provider.dart';
import '../serviceCenter_provider/get_serviceCenter_serviceType_provider/get_service_center_service_type_provider.dart';
import '../serviceCenter_provider/location_provider/location_provider.dart';
import '../serviceCenter_provider/newSerialButton_provider/getNewSerialButton_provider.dart';
import '../serviceCenter_provider/newSerialButton_provider/newSerialProvider.dart';
import '../serviceCenter_provider/newSerialButton_provider/queue_edit_list_provider/queue_edit_list_provider.dart';
import '../serviceCenter_provider/nextButton_provider/get_nextButton_provider.dart';
import '../serviceCenter_provider/nextButton_provider/nextButton_provider.dart';
import '../serviceCenter_provider/roles_service_center_provider/roles_service_center_provider.dart';

import '../serviceCenter_provider/service_types_de_faultif_not_set_provider/service_types_de_faultif_not_set_provider.dart';
import '../serviceCenter_provider/statusButtonProvider/get_status_updateButtonButton_provider.dart';
import '../serviceCenter_provider/statusButtonProvider/status_UpdateButton_provider.dart';
import '../serviceCenter_provider/update_service_center_service_type_provider/update_service_center_service_type_provider.dart';
import '../serviceTaker_provider/ServiceCenterByTypeProvider.dart';
import '../serviceTaker_provider/bookSerialButtonProvider/bookSerialButton_provider.dart';
import '../serviceTaker_provider/bookSerialButtonProvider/getBookSerial_provider.dart';
import '../serviceTaker_provider/commentCancelProvider/commentCancelButton_provider.dart';
//import '../serviceTaker_provider/getBookSerialButtonProvider/getBookSerial_provider.dart';
import '../serviceTaker_provider/commentCancelProvider/getCommentCancelButtonProvider.dart';
import '../serviceTaker_provider/serviceCenter_serialBookProvider/serviceCenter_serialBookProvider.dart';
import '../serviceTaker_provider/service_types_de_fault_provider/service_types_de_fault_provider.dart';
import '../serviceTaker_provider/update_bookserialProvider/getUpdate_bookSerial_provider.dart';
import '../serviceTaker_provider/mySerials/mySerial_provider.dart';
import '../serviceTaker_provider/organaizationProvider/organization_provider.dart';
import '../serviceTaker_provider/serviceType_serialbook_provider.dart';
import '../serviceTaker_provider/update_bookserialProvider/update_bookserial_provider.dart';

class AppProviders {
  static List<SingleChildWidget> get providers {
    return [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ChangeNotifierProvider(create: (context) => Getprofileprovider()),
      ChangeNotifierProvider(create: (context) => PasswordUpdateProvider()),
      ChangeNotifierProvider(create: (context) => OrganizationProvider()),

      ChangeNotifierProvider(create: (context) => AddButtonProvider()),
      ChangeNotifierProvider(create: (context) => GetAddButtonProvider()),
      ChangeNotifierProvider(create: (_) => DeleteServiceCenterProvider()),

      ChangeNotifierProvider(create: (context) => EditButtonProvider()),
      ChangeNotifierProvider(create: (context) => GetEditButtonProvider()),

      ChangeNotifierProvider(
        create: (context) => GetAddButtonServiceType_Provider(),
      ),
      ChangeNotifierProvider(
        create: (context) => AddButtonServiceTypeProvider(),
      ),
      ChangeNotifierProvider(create: (_) => DeleteServiceTypeProvider()),

      ChangeNotifierProvider(
        create: (context) => EditButtonServiceTypeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => GetEditButtonServiceTypeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => service_types_de_faultif_not_setProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => add_service_center_service_type_provider(),
      ),

      ChangeNotifierProvider(
        create: (context) => get_service_center_service_type_provider(),
      ),

      ChangeNotifierProvider(
        create: (context) => UpdateServiceCenterServiceTypeProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => DeleteServiceTypeServiceTypeProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => DeleteServiceCenterProvider(),
      ),

      ChangeNotifierProvider(create: (context) => NewSerialButtonProvider()),
      ChangeNotifierProvider(create: (context) => GetNewSerialButtonProvider()),
      ChangeNotifierProvider(create: (context) => QueueListEditProvider()),
      ChangeNotifierProvider(create: (context) => getStatusUpdate_Provider()),
      ChangeNotifierProvider(create: (context) => statusUpdateButton_provder()),
      ChangeNotifierProvider(create: (context) => nextButtonProvider()),
      ChangeNotifierProvider(create: (context) => GetNextButtonProvider()),

      ChangeNotifierProvider(create: (context) => BusinessTypeProvider()),
      ChangeNotifierProvider(create: (context) => CompanyDetailsProvider()),

      ///
      ChangeNotifierProvider(
        create: (context) => serviceTypeSerialbook_Provider(),
      ),

      ChangeNotifierProvider(create: (context) => RolesProvider()),

      ChangeNotifierProvider(
        create: (context) => CommentCancelButtonProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => GetCommentCancelButtonProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => AddUserServiceCenterProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => GetAdduserServiceCenterProvider(),
      ),

      ChangeNotifierProvider(create: (_) => SingleUserInfoProvider()),
      ChangeNotifierProvider(create: (_) => UpdateAddUserProvider()),
      ChangeNotifierProvider(create: (_) => DeleteUserProvider()),
      ChangeNotifierProvider(create: (_) => DivisionProvider()),
      ChangeNotifierProvider(create: (context) => LocationProvider()),

      ChangeNotifierProvider(create: (_) => UpdateOrganizationInfoProvider()),
      ChangeNotifierProvider(create: (context) => getUpdateOrganization()),

      /// serviceTaker provider
      ChangeNotifierProvider(create: (context) => bookSerialButton_provider()),
      ChangeNotifierProvider(create: (context) => GetBookSerialProvider()),
      ChangeNotifierProvider(
        create: (context) => MySerialServiceTakerProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => service_types_de_fault_provider(),
      ),

      ///BusinessType Provider
      ChangeNotifierProvider(
        create: (context) => ServiceCenterByTypeProvider(),
      ),

      ChangeNotifierProvider(create: (context) => UpdateBookSerialProvider()),
      ChangeNotifierProvider(
        create: (context) => GetUpdate_bookSerialProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => serviceCenter_serialBookProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => ServiceCenterSearchProvider(),
      ),
    ];
  }
}
