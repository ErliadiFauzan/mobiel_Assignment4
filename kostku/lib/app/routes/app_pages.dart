import 'package:get/get.dart';

import '../modules/Home/Login/bindings/Login_binding.dart';
import '../modules/Home/Login/View/Login_view.dart';
import '../modules/Home/views/Register/View/Register_view.dart';

//home
import '../modules/Home/views/Home/View/Home_view.dart';
import '../modules/Home/views/Home/Deskription/view/Deskription_view.dart';
import '../modules/Home/views/Home/Deskription/sub/Chat/view/chat_view.dart';
import '../modules/Home/views/Home/Deskription/sub/Review/View/Review_view.dart';
import '../modules/Home/views/even/view/even_view.dart';

//setings
import '../modules/Home/views/setings/View/Setings_view.dart';
import '../modules/Home/views/setings/submenu/PasswordChange/PassChange_view/Password_Change_view.dart';
import '../modules/Home/views/setings/submenu/ProfilEdit/View/ProfileEdit_view.dart';
import '../modules/Home/views/setings/submenu/Editkamar/View/EditKamar_view.dart';
import '../modules/Home/views/setings/submenu/Editkamar/subfile/EditKamarEdit/view/EditkamarEdit_view.dart';
import '../modules/Home/views/setings/submenu/Editkamar/subfile/Tambahkamar_view/View/TambahKamar_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () =>  HomeView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () =>  LoginView(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () =>  RegisterView(),
    ),
    GetPage(
      name: _Paths.SETINGS,
      page: () =>  SettingsView(),
    ),
    GetPage(
      name: _Paths.PASWORDEDIT,
      page: () =>  ChangePasswordView(),
    ),
    GetPage(
      name: _Paths.PROFILEEDIT,
      page: () =>  ProfileEditView(),
    ),
    GetPage(
      name: _Paths.EDITKAMAR,
      page: () =>  EditKamarView(),
    ),
    GetPage(
      name: _Paths.EDITKAMAREDIT,
      page: () =>  EdiEtKamarView(),
    ),

    GetPage(
      name: _Paths.TAMBAHKAMAR,
      page: () =>  TambahKamarView(),
    ),
    GetPage(
      name: _Paths.DESCRIPTION,
      page: () =>  KosDetailPage(),
    ),
    GetPage(
      name: _Paths.REVIEW,
      page: () =>  ReviewPage(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () =>  ChatView(),
    ),
    GetPage(
      name: _Paths.EVENT,
      page: () =>  PromoDetailView(),
    ),
  ];
}
