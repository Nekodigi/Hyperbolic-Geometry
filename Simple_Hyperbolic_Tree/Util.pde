PVector projectionHtoE(PVector p){//projection hyperbolic geometry to euclidian
  return new PVector((float)Math.tanh(p.x), (float)Math.tanh(p.y));
}

PVector translatePoint(PVector A, PVector B) {//translate vector A origin to B in hyperbolic geometry and return end of translated A
  // z = (z + t) / (1 + z * conj(t))

  // first the denominator
  float denX = (A.x * B.x) + (A.y * B.y) + 1;
  float denY = (A.y * B.x) - (A.x * B.y);
  float dd   = (denX * denX) + (denY * denY);

  // and the numerator
  float numX = A.x + B.x;
  float numY = A.y + B.y;

  // then the division (bell)
  float x = ((numX * denX) + (numY * denY)) / dd;
  float y = ((numY * denX) - (numX * denY)) / dd;
  return new PVector(x, y);
}
