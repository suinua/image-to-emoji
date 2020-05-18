import 'dart:html';
showEmojSelect(event){
  var convertType = querySelector("#convertType").value;
  
  if (convertType == "color"){
    querySelector("#emojiSelect").style.display = "none";  

  }else{
    querySelector("#emojiSelect").style.display = "";  

  }
}