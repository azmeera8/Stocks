class CSEThumbnail {
  String? src;
  int width;
  int height;
  CSEThumbnail({this.src, this.width = 300, this.height = 200});

  @override
  String toString() {
    return 'CSEThumbnail \n src: $src \n width:$width , height $height';
  }
}
