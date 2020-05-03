import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:trackcorona/presentation/models/access_token/access_token.dart';
import 'package:trackcorona/services/injector/injector.dart';
import 'package:trackcorona/services/shared_preference_manager.dart';
import 'package:trackcorona/utilities/constants.dart';

class ApiProvider {
  final String _baseUrl = kBaseUrl;

  ApiProvider();

  Future<Dio> getDioHttpClient() async {
    SharedPreferencesManager sharedPreferenceManager =
        getIt<SharedPreferencesManager>();

    String _accessToken = sharedPreferenceManager.getString('access_token');
    Dio dio = Dio();
    Dio tokenDio = Dio();
    String methodType = "GET";

    dio.options.baseUrl = _baseUrl;
    tokenDio.options.baseUrl = _baseUrl;

    if (_accessToken != null) {
      log('-----------inside _accessToken != null -----------');

      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          await addAccessTokenToHeader(options, _accessToken);
          log('options.method is ${options.method}');
          methodType = options.method;
          return options;
        },
        onError: (DioError error) async {
          if (error.response?.statusCode == 401) {
            log('-----------error.response?.statusCode == 401 -----------');
            return await refreshToken(error, dio, tokenDio, methodType);
          }
          log('returning error from onError');
          return error;
        },
        onResponse: (Response response) {
          return response;
        },
      ));
    } else {
      log('-----------access token is null -----------');
    }

    return dio;
  }

  Future<Object> refreshToken(
      DioError error, Dio dio, Dio tokenDio, String methodType) async {
    print('inside refresh block');
    RequestOptions refreshOptions = error.response.request;
    RequestOptions newOptions = error.response.request;

    SharedPreferencesManager sharedPreferenceManager =
        getIt<SharedPreferencesManager>();

    String _refreshToken = sharedPreferenceManager.getString('refresh_token');
    String _accessToken = sharedPreferenceManager.getString('access_token');

    _refreshToken = "Bearer " + _refreshToken;

    newOptions.headers["Authorization"] = _refreshToken;

    if (_refreshToken != null) {
      lockRequest(dio);

      return tokenDio
          .post("/refresh",
              data: jsonEncode({
                "refresh_token": _refreshToken,
                "access_token": _accessToken
              }),
              options: newOptions)
          .then((response) async {
        log('---------got /new access response------------');

        var accessToken = AccessToken.fromJson(response.data);
        log('accessToken.value.toString() ${accessToken.value.toString()}');
        await sharedPreferenceManager.putString(
            "access_token", accessToken.value.toString());

        String newAccessToken = "Bearer " + accessToken.value;

        dio.options.headers["Authorization"] = newAccessToken;

        refreshOptions.headers["Authorization"] = newAccessToken;
        refreshOptions.method = methodType;
        refreshOptions.contentType = dio.options.contentType;
      }).whenComplete(() {
        unlockRequest(dio);
      }).then((_) {
        log('doing dio.request(refreshOptions.path, options: refreshOptions)');
        Dio newDio = Dio();
        return newDio.request(refreshOptions.path,
            options: refreshOptions, data: error.request.data);
      });
    }
    return error;
  }

  void unlockRequest(Dio dio) {
    dio.unlock();
    dio.interceptors.requestLock.unlock();
    dio.interceptors.responseLock.unlock();
    dio.interceptors.errorLock.unlock();
  }

  void lockRequest(Dio dio) {
    dio.lock();
    dio.interceptors.requestLock.lock();
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
