void keyPressed(){
  if(keyCode==UP){
    p++;
  }else if(p > 3 && keyCode==DOWN){
    p--;
  }
  if(keyCode==RIGHT){
    q++;
  }else if(q > 3 && keyCode==LEFT){
    q--;
  }
  //calc const
  d = sqrt((tan(HALF_PI - PI / q) - tan(PI / p)) / (tan(HALF_PI - PI / q) + tan(PI / p)));
}
