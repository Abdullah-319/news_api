import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_api/models/news_channel_headlines_model.dart';

class HeadlinesRepositoty {
  Future<NewsChannelHeadlinesModel> fetchNewsHeadlinesApi() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=888ef9840bcb4bc7bcba2d3c5da79ccb";

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
}
