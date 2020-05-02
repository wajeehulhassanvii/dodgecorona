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

  ApiProvider();

  Future<Dio> getDioHttpClient() async {
    SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();

    var _accessToken = sharedPreferenceManager.getString('access_token');
    Dio dio = Dio();
    Dio tokenDio = Dio();


    dio.options.baseUrl = _baseUrl;
    tokenDio.options.baseUrl = _baseUrl;
    dio.interceptors.requestLock;

    if (_accessToken != null) {

      log('-----------inside _accessToken != null -----------');

      dio.interceptors.add(InterceptorsWrapper(

        onRequest: (RequestOptions options) async {
          await addAccessTokenToHeader(options, _accessToken);
          return options;
        },

        onError: (DioError error) async {
          if (error.response?.statusCode == 401) {
            log('-----------error.response?.statusCode == 401 -----------');
            return await refreshToken(error, dio, tokenDio);
          }
          log('returning error from onError');
          return error;
        },

        onResponse: (Response response){
          if(response.statusCode==405){
            log('log onResponse when statusCode 405 $response');
          }
          return response;
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
    log('error object in refreshToken ${error.toString()}');
    RequestOptions refreshOptions = error.response.request;

    RequestOptions newOptions = error.response.request;

    SharedPreferencesManager sharedPreferenceManager= getIt<SharedPreferencesManager>();

    var _refreshToken = sharedPreferenceManager.getString('refresh_token');
    var _accessToken = sharedPreferenceManager.getString('access_token');

    _refreshToken = "Bearer " + _refreshToken;

    newOptions.headers["Authorization"] = _refreshToken;

    if (_refreshToken != null) {
      lockRequest(dio);

      return tokenDio
          .post("/refresh", data: jsonEncode({"refresh_token": _refreshToken,
      "access_token": _accessToken}), options: newOptions)
          .then((response) {

            log('---------got /new access response------------');

        var accessToken = AccessToken.fromJson(response.data);
            log('accessToken.value.toString() ${accessToken.value.toString()}');

         sharedPreferenceManager.putString(
            "access_token", accessToken.value.toString());

            String newAccessToken = "Bearer " + accessToken.value;

            dio.options.headers["Authorization"] = newAccessToken;

            tokenDio.options.headers["Authorization"] = newAccessToken;
            tokenDio.options.method=dio.options.method;

            refreshOptions.headers["Authorization"] = newAccessToken;
            refreshOptions.method=dio.options.method;
            log(dio.toString());



      }).whenComplete(() {
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
