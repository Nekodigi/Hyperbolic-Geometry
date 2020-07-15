//based on this site https://github.com/unused/hyperbolic-tree-browser
float dispScale = 500;
Node node;

void setup(){
  fullScreen();
  //size(1000, 1000);
  textSize(dispScale/10);
  translate(width/2, height/2);
  node = new Node();
  node.addChild("E", 0, 0.5, true);
  node.addChild("S", HALF_PI, 0.5, true);
  node.addChild("W", PI, 0.5, true);
  node.addChild("N", HALF_PI*3, 0.5, true);
  for(int i=0; i<4; i++){
    for(int j=0; j<4; j++){
      float theta = map(j, 0, 3, -.5, .5);
      node.children.get(i).addChild(theta, 0.5, true);
    }
  }
  for(int i=0; i<4; i++){
    for(int j=0; j<4; j++){
      float theta = map(j, 0, 3, -.2, .2);
      node.children.get(0).children.get(i).addChild(theta, 0.3, true);
    }
  }
}

void draw(){
  background(255);
  translate(width/2, height/2);
  node.poss = new PVector(map(mouseX, 0, width, -1, 1), map(mouseY, 0, height, -1, 1));
  //float bdist = map(mouseX, 0, width, -1, 1);
  noFill();marker(0, 0, 1, "poincare disk");
  node.show();
}
