import 'cse_thumbnail.dart';

class NewsModel {
  String? title;
  String? link;
  String? displayLink;
  String? snippet;
  String? description;
  CSEThumbnail? cseThumbnail;

  NewsModel(
      {this.title,
      this.link,
      this.displayLink,
      this.snippet,
      this.description,
      this.cseThumbnail});

  @override
  String toString() {
    return 'NewsModel title:$title \n link :$link \n snippet:$snippet \n cseThumbnail : $cseThumbnail';
  }
}
