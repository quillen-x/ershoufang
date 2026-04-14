import 'package:dio/dio.dart';

class DioHouseFactory {
  static Future<String> fetchRegionHouseListHtml(param, page,
      {isSearch = false, options, cancelToken, data}) async {
    var dio = Dio(); // with default Options

    dio.options.baseUrl = 'https://wh.lianjia.com/ershoufang/';

    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);

    try {
      String url = page == 1 ? '$param/sf1/' : '$param/pg${page}sf1/';

      print('请求地址：$url，时间戳：${DateTime.now()}');
      Response response =
          await dio.get(url, cancelToken: cancelToken, options: options);
      return response.data.toString();
    } catch (e) {
      return '';
    }
  }

  static Future<String> fetchCellHouseListHtml(param, page,
      {isSearch = false, options, cancelToken, data}) async {
    var dio = Dio(); // with default Options

    dio.options.baseUrl = 'https://wh.lianjia.com/ershoufang/';

    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);

    try {
      // https://wh.lianjia.com/ershoufang/baishazhou/pg100sf1/
      // String url = isSearch
      //     ? '?$param&page=$page'
      //     : page == 1
      //         ? 'rs$param/'
      //         : 'pg${page}rs$param/';
      String url = page == 1 ? 'sf1rs$param/' : 'pg2sf1rs$param/';

      print('请求地址：$url，时间戳：${DateTime.now()}');
      Response response =
          await dio.get(url, cancelToken: cancelToken, options: options);
      return response.data.toString();
    } catch (e) {
      return '';
    }
  }



}
