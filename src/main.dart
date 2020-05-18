import 'dart:html';
import 'image.dart';
import 'ui.dart';

main() {
  querySelector("#file").onChange.listen(loadImage);
  querySelector("#convertType").onChange.listen(showEmojSelect);

}
