import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/models/category_news_model.dart';
import 'package:news_api/models/news_channel_headlines_model.dart';

class HeadlinesRepositoty {
  Future<NewsChannelHeadlinesModel> fetchNewsHeadlinesApi(String source) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=888ef9840bcb4bc7bcba2d3c5da79ccb";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (kDebugMode) {
        print(body);
      }
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=888ef9840bcb4bc7bcba2d3c5da79ccb";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (kDebugMode) {
        print(body);
      }
      return CategoryNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
