import 'dart:html';
var scale = 1.0;

scaleDown(event){
  if (scale != 0.20000000000000015){
    scale -= 0.1;
    changeScale(scale);
  }
}

scaleUp(event){
  if (scale != 1.0){
    scale += 0.1;
    changeScale(scale);
  }
}

scaleReset(event){
  scale = 1.0;
  changeScale(scale);
}

changeScale(scale){
  querySelector("#container").style
  ..setProperty("-webkit-transform","scale(${scale})")
  ..setProperty("-moz-transform   ","scale(${scale})")
  ..setProperty("-ms-transform    ","scale(${scale})")
  ..setProperty("-o-transform     ","scale(${scale})")
  ..setProperty("transform        ","scale(${scale})");
}