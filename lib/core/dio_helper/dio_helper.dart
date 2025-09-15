import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioHelper {
  static final Dio dio = Dio();

  static void init({String? baseUrl}) {
    dio.options.baseUrl = baseUrl ?? "https://api.example.com";
    dio.options.connectTimeout = const Duration(minutes: 1);
    dio.options.receiveTimeout = const Duration(minutes: 1);
    dio.options.headers = {"Content-Type": "application/json"};

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Token'] = 'Route__$token';
          }
          return handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(url, queryParameters: query);
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return await dio.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String url,
    dynamic data,
    Map<String, dynamic>? query,
    bool isRaw = false,
  }) async {
    return await dio.put(
      url,
      data: isRaw ? data : data,
      queryParameters: query,
      options: Options(headers: {"Content-Type": "application/json"}),
    );
  }

  static Future<Response> patchData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return await dio.patch(url, data: data, queryParameters: query);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return await dio.delete(url, data: data, queryParameters: query);
  }

  /// Upload file or image
  /*static Future<Response> uploadFile({
    required String url,
    required File file,
    String fileFieldName = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      fileFieldName: await MultipartFile.fromFile(file.path, filename: fileName),
      ...?data,
    });

    return await dio.post(
      url,
      data: formData,
      queryParameters: query,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  /// Upload multiple files
  static Future<Response> uploadMultipleFiles({
    required String url,
    required List<File> files,
    String fileFieldName = 'files',
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    List<MultipartFile> fileList = [];
    for (File file in files) {
      String fileName = file.path.split('/').last;
      fileList.add(await MultipartFile.fromFile(file.path, filename: fileName));
    }

    FormData formData = FormData.fromMap({
      fileFieldName: fileList,
      ...?data,
    });

    return await dio.post(
      url,
      data: formData,
      queryParameters: query,
      options: Options(contentType: 'multipart/form-data'),
    );
  }*/
}
