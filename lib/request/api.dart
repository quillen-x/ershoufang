import 'package:ershoufang/model/history_price_model.dart';
import 'package:ershoufang/sql/db_helper.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import '../model/house_model.dart';
import 'http_request.dart';

class HouseListApi {
  static Future<List<HouseModel>> fetchHouseList(String pubName, int page, {bool isSearch = false}) async {
    List<HouseModel> books = [];
    var response = await DioHouseFactory.fetchRegionHouseListHtml(pubName, page, isSearch: isSearch);
    var document = parse(response);
    Element? content = document.querySelector(".sellListContent");

    if (content != null) {
      var lefts = content.querySelectorAll(".unitPrice");

      var titles = content.querySelectorAll(".title");

      var houseInfo = content.querySelectorAll(".houseInfo");

      var totalPrice = content.querySelectorAll(".totalPrice2");

      var flood = content.querySelectorAll('.flood');

      var followInfo = content.querySelectorAll('.followInfo');

      List<Element>? contents = content.querySelectorAll(".lj-lazy");

      NodeList? nodeList = content.nodes;

      for (var i = 0; i < lefts.length; i++) {
        List houseInfos = houseInfo[i].text.split('|');
        List floods = flood[i].text.split('-');
        List followInfos = followInfo[i].text.split('/');

        String id = nodeList[i].attributes['data-lj_action_housedel_id'].toString().trim();
        List<HistoryPriceModel> prices = [];
        List<HistoryPriceModel> historyList = await DbHelper.instance.houseTable.queryHousePrices(id);

        if (historyList.isNotEmpty) {
          HistoryPriceModel historyPriceModel = historyList.first;

          if (historyPriceModel.price != lefts[i].text.trim()) {
            //价格变化

            historyList.add(HistoryPriceModel(houseId: id, price: lefts[i].text.trim(), time: DateTime.now().millisecondsSinceEpoch, totalPrice: totalPrice[i].text.trim()));

            prices = historyList;
          } else {
            prices = [HistoryPriceModel(houseId: id, price: lefts[i].text.trim(), time: DateTime.now().millisecondsSinceEpoch, totalPrice: totalPrice[i].text.trim())];
          }
        } else {
          prices = [HistoryPriceModel(houseId: id, price: lefts[i].text.trim(), time: DateTime.now().millisecondsSinceEpoch, totalPrice: totalPrice[i].text.trim())];
        }

        String area = houseInfos[1].trim();
        // 删除最后两位
        String modifiedString = area.substring(0, area.length - 2);

        books.add(HouseModel(
            houseId: id,
            cover: contents[i].attributes['data-original'].toString(),
            description: titles[i].text.trim(),
            houseType: houseInfo[i].text.split('|').first,
            area: modifiedString,
            floor: houseInfos[4].trim(),
            priceList: prices,
            region: floods.last.trim(),
            buildName: floods.first.trim(),
            url: "https://wh.lianjia.com/ershoufang/$id.html",
            follows: followInfos.first.trim(),
            publishTime: followInfos.last.trim()));
      }
    }

    return books;
  }
}

class HouseUpdateApi {
  static Future<List<HouseModel>> fetchHouseList(String pubName, int page, {bool isSearch = false}) async {
    List<HouseModel> books = [];
    var response = await DioHouseFactory.fetchCellHouseListHtml(pubName, page, isSearch: isSearch);
    var document = parse(response);
    Element? content = document.querySelector(".sellListContent");

    if (content != null) {
      var lefts = content.querySelectorAll(".unitPrice");

      var titles = content.querySelectorAll(".title");

      var houseInfo = content.querySelectorAll(".houseInfo");

      var totalPrice = content.querySelectorAll(".totalPrice2");

      var flood = content.querySelectorAll('.flood');

      var followInfo = content.querySelectorAll('.followInfo');

      List<Element>? contents = content.querySelectorAll(".lj-lazy");

      NodeList? nodeList = content.nodes;

      for (var i = 0; i < lefts.length; i++) {
        List houseInfos = houseInfo[i].text.split('|');
        List floods = flood[i].text.split('-');
        List followInfos = followInfo[i].text.split('/');

        String id = nodeList[i].attributes['data-lj_action_housedel_id'].toString().trim();
        List<HistoryPriceModel> prices = [];
        List<HistoryPriceModel> historyList = await DbHelper.instance.houseTable.queryHousePrices(id);

        if (historyList.isNotEmpty) {
          HistoryPriceModel historyPriceModel = historyList.first;

          if (historyPriceModel.price != lefts[i].text.trim()) {
            //价格变化
            String oldPrice = historyPriceModel.price;
            String newPrice = lefts[i].text.trim();
            print('上次价格：${oldPrice},最新价格:${newPrice}');
            historyList.add(HistoryPriceModel(houseId: id, price: lefts[i].text.trim(), time: DateTime.now().millisecondsSinceEpoch, totalPrice: totalPrice[i].text.trim()));

            prices = historyList;
          } else {
            prices = [HistoryPriceModel(houseId: id, price: lefts[i].text.trim(), time: DateTime.now().millisecondsSinceEpoch, totalPrice: totalPrice[i].text.trim())];
          }
        } else {
          prices = [HistoryPriceModel(houseId: id, price: lefts[i].text.trim(), time: DateTime.now().millisecondsSinceEpoch, totalPrice: totalPrice[i].text.trim())];
          print('新房价格 $id：${lefts[i].text.trim()}');
        }

        String area = houseInfos[1].trim();
        // 删除最后两位
        String modifiedString = area.substring(0, area.length - 2);

        books.add(HouseModel(
            houseId: id,
            cover: contents[i].attributes['data-original'].toString(),
            description: titles[i].text.trim(),
            houseType: houseInfo[i].text.split('|').first,
            area: modifiedString,
            floor: houseInfos[4].trim(),
            priceList: prices,
            region: floods.last.trim(),
            buildName: floods.first.trim(),
            url: "https://wh.lianjia.com/ershoufang/$id.html",
            follows: followInfos.first.trim(),
            publishTime: followInfos.last.trim()));
      }
    }

    return books;
  }
}


