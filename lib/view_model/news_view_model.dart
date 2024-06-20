import 'package:news_api/models/news_channel_headlines_model.dart';
import 'package:news_api/repository/headlines_repositoty.dart';

class NewsViewModel {
  final repo = HeadlinesRepositoty();

  Future<NewsChannelHeadlinesModel> fetchNewsHeadlinesApi(String source) async {
    final response = await repo.fetchNewsHeadlinesApi(source);
    return response;
  }
}
