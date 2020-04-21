enum MyPageRoutes{
  login,
  registration,
  map,
}

_pageRouteToString(MyPageRoutes myPageRoutes){

  switch(myPageRoutes){
    case MyPageRoutes.login:
      return "/login";
    case MyPageRoutes.registration:
      return '/registration';
    case MyPageRoutes.map:
      return '/map';
  }

}

_stringToMyPageRoute(String pageString){
  switch(pageString){
    case "/login":
      return MyPageRoutes.login;
    case "/registration":
      return MyPageRoutes.registration;
    case "/map":
      return MyPageRoutes.map;

  }
}