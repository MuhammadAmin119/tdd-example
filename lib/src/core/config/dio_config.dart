import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class DioConfig extends Interceptor {
  static final Dio client = Dio(
    BaseOptions(
      baseUrl: 'https://api-service.fintechhub.uz',
      sendTimeout: Duration(minutes: 2), // * borish -> 2 | stop
      receiveTimeout: Duration(minutes: 2), // * kelish -> 2 | stop
      connectTimeout: Duration(minutes: 2), // * oshxona -> 2 | stop
    ),
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('Interceptor error dio $err');
    if (err.response?.statusCode == 401) {
      // * expire -> eskirgan token
      try {
        final newToken = await refresh();
        if (newToken != null) {
          GetStorage().write('accessToken', newToken);
          return handler.next(err); // * oxrigi zaprosni davom etradi
        }
      } catch (e) {
        return handler.next(err);
      }
    }
  }

  Future<String?> refresh() async {
    try {
      final res = await client.post(
        '/token/refresh/',
        data: {"refresh": GetStorage().read('refreshToken')},
      );

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return res.data['access'];
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
