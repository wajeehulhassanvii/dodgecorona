import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackcorona/presentation/models/access_token/access_token.dart';
import 'package:trackcorona/services/injector/injector.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';
import 'package:trackcorona/utilities/constants.dart';

class ApiProvider {
  final Dio dio = Dio();
  final String _baseUrl = kBaseUrl;
  final String clientId = 'bengkel-robot-client';
  final String clientSecret = 'bengkel-robot-secret';

  ApiProvider();

  // returns a dio object which always have either a dio obect with header
  // or an error
  Future<Dio> getDioHttpClient() async {
    print('before shared preference');
    var _baseUrl = kBaseUrl;
    SharedPreferencesManager sharedPreferenceManager =
        await SharedPreferencesManager.getInstance();

    print('before access toekn fetch');
    var _accessToken = sharedPreferenceManager.getString('access_token');
    log('--------fetched access token ----------');
    Dio dio = Dio();
    Dio tokenDio = Dio();


    dio.options.baseUrl = _baseUrl;
    tokenDio.options.baseUrl = _baseUrl;
    dio.interceptors.requestLock;
    if (_accessToken != null) {
      log('-----------inside _accessToken != null -----------');
      log("_accessToken inside _accessToken != null: $_accessToken");
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          await addAccessTokenToHeader(options, _accessToken);
        },
        onError: (DioError error) async {

          if (error.response?.statusCode == 401) {
            log('-----------error.response?.statusCode == 401 -----------');
            return await refreshToken(error, dio, tokenDio);
          }
          return error;
        },
      ));
    } else {
      log('-----------access token is null -----------');
    }
    return dio;

  }

  Future<Object> refreshToken(DioError error, Dio dio, Dio tokenDio) async {
    print('inside refresh block');
    var _baseUrl = kBaseUrl;

    RequestOptions refreshOptions = error.response.request;

//    SharedPreferencesManager sharedPreferenceManager =
//        await SharedPreferencesManager.getInstance();

    getIt = GetIt.instance;
    SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();

    if(sharedPreferenceManager!=null){
      log('shared preference loaded in _refreshToken method');}

    var _refreshToken = sharedPreferenceManager.getString('refresh_token');
    var _accessToken = sharedPreferenceManager.getString('access_token');

    log('----------------- refresh token ----------------');
//    log(_refreshToken.runtimeType.toString());
    log('_accessToken in refreshToken: $_accessToken');
    log('_refreshToken in refreshToken: $_refreshToken');


    String refreshToken = "Bearer " + _refreshToken;

    refreshOptions.headers["Authorization"] = refreshToken;

    if (refreshToken != null) {
      lockRequest(dio);

      return tokenDio
          .post("/refresh", data: jsonEncode({"refresh_token": _refreshToken,
      "access_token": _accessToken}), options: refreshOptions)
          .then((response) async {
            log('---------got /new access response------------');
        var accessToken = AccessToken.fromJson(response.data);
            log('accessToken.value.toString() ${accessToken.value.toString()}');
        await sharedPreferenceManager.putString(
            "access_token", accessToken.value.toString());

      }).whenComplete(() {
        log('------------new access token put into sharepreference');
        unlockRequest(dio);
      }).then((_) {
        log('doing dio.request(refreshOptions.path, options: refreshOptions)');
        return tokenDio.request(refreshOptions.path, options: refreshOptions);
      });
    }
    return error;
  }

  void unlockRequest(Dio dio) {
    dio.unlock();
    dio.interceptors.responseLock.unlock();
    dio.interceptors.errorLock.unlock();
  }

  void lockRequest(Dio dio) {
    dio.lock();
    dio.interceptors.responseLock.lock();
    dio.interceptors.errorLock.lock();
  }

  Future addAccessTokenToHeader(
      RequestOptions options, String accessToken) async {
    accessToken = "Bearer " + accessToken;
    options.headers["Authorization"] = accessToken;
  }

  Future addRefreshTokenToHeader(
      RequestOptions options, String refreshToken) async {
    refreshToken = "Bearer " + refreshToken;
    options.headers["Authorization"] = refreshToken;
  }

}
