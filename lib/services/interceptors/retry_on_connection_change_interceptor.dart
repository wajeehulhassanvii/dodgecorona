import 'dart:io';

import 'package:dio/dio.dart';
import 'package:trackcorona/services/connections/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor{
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor(this.requestRetrier);
  // CASE1 error exception
  @override
  Future onError(DioError err) async{
    if(_shouldRetry(err)){
      try{
        return requestRetrier.scheduleRequestRetry(err.request);
      } catch (e){
        return e;
      }
    }
    return err;
  }

  // CASE1 check if its not null exception or socket exception
  bool _shouldRetry(DioError err){
    return err.type == DioErrorType.DEFAULT &&
    err.error != null &&
    err.error is SocketException;
  }


}