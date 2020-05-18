import 'dart:html';
import 'scale.dart';
import 'dart:js' as js;

loadImage(Event event) async{
  scaleReset(event);
  querySelector("#convertedTextArea").text = "";
  querySelector("#scaleArea").setInnerHtml("<div id='scaleUp'><i class='fas fa-plus-circle'></i></div><div id='scaleDown'><i class='fas fa-minus-circle'></i></div><div id='scaleReset'><i class='fas fa-redo-alt'></i></div>");

  querySelector("#scaleDown")
  ..style.display = "inline"
  ..onClick.listen(scaleDown);
  querySelector("#scaleUp")
  ..style.display = "inline"
  ..onClick.listen(scaleUp);
  querySelector("#scaleReset")
  ..style.display = "inline"
  ..onClick.listen(scaleReset);

  var files = (event.target as FileUploadInputElement).files;
  var reader = new FileReader();
  var resultReceived = reader.onLoad.first;  
  reader.readAsDataUrl(files[0]);
  await resultReceived;
  imageProcessing(reader.result);

}

imageProcessing(src){
  var canvas = document.getElementById('canvas');
  var context = canvas.getContext('2d');
  ImageElement img = new ImageElement(src:src);
  img.onLoad.listen((e){
    var height = img.height;
    var width = img.width;
    if (img.height + img.width > 1400){
      height = int.parse((img.height/((img.height+img.width)/600)).toString().replaceAll(new RegExp("\\.(.*)"), ""));
      width  = int.parse((img.width/ ((img.height+img.width)/600)).toString().replaceAll(new RegExp("\\.(.*)"), ""));
    } 
    canvas
      ..height = height
      ..width = width;
    context.drawImageScaled(img, 0, 0,width,height);
    var imageData = context.getImageData(0,0,width,height); 
    
    var fontSize = querySelector("#fontSize").value;
    querySelector("#convertedTextArea").style.fontSize = "${fontSize}mm";

    var data = imageData.data;
    var convertType = querySelector("#convertType").value;
    if (convertType == "emoji"){
      convertToEmoji(data,width);
    }else{
      convertToColor(data, width);
    }
  });
}

convertToEmoji(data,width){
  var threshold = int.parse(querySelector("#threshold").value);
  var emoji1 = querySelector("#emoji1").value;
  var emoji2 = querySelector("#emoji2").value;
  var convertedTextArea = querySelector("#convertedTextArea");
  for (var i = 0; i < data.length; i += 4) {
    
    if(data[i+3]==0) {
      convertedTextArea.insertAdjacentHtml("beforeend", emoji1);
	  } else if(data[i]<threshold) {
      convertedTextArea.insertAdjacentHtml("beforeend", emoji2);
	  } else {
      convertedTextArea.insertAdjacentHtml("beforeend", emoji1);
    }
    if ((i/4 + 1)%width == 0 && i+1 > width){
      convertedTextArea.insertAdjacentHtml("beforeend", "<br>");
    }
  }
}

convertToColor(data,width){
  var convertedTextArea = querySelector("#convertedTextArea");
  var downloadFileName = (querySelector("#file").value).toString().replaceAll(".png", "").replaceAll("C:\\fakepath\\", "");
  var downloadText = "";
  for (var i = 0; i < data.length; i += 4) {

    var rgba = "rgba(${data[i]},${data[i+1]},${data[i+2]},${data[i+3]})";
    convertedTextArea.insertAdjacentHtml("beforeend", "<font id='${i}'>■</font>");
    document.getElementById("${i}").style.color = rgba;
    downloadText += "<font style='color:${rgba}'>■</font>";
    if ((i/4 + 1)%width == 0 && i+1 > width){
      convertedTextArea.insertAdjacentHtml("beforeend", "<br>");
      downloadText += "<br>";
    }
  }
  download("$downloadFileName.html",downloadText);
}

download(saveFileName,saveText) {    
  Blob blob = new Blob([saveText]);
  if (js.context['navigator']['msSaveBlob'] != null) {
      msSaveBlob(blob, 'svg_contents.svg');
  } else { 
      AnchorElement downloadLink =  querySelector("#download");
      downloadLink.href = Url.createObjectUrlFromBlob(blob);
      downloadLink.text = "Download";
      downloadLink.download = saveFileName;
      downloadLink.style.display = '';

  }
}