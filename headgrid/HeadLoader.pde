// Loads the 3D shape of the head
// type: 0 - default head, 1 - joe, 2 - bieber 
HeadModel loadHead(int type) {
  PShape modelShape;
  HeadModel hm = new HeadModel();

  if (type == 0) {
    hm.model = loadShape("heads/head.obj");
    hm.rx = HALF_PI;

  } else if (type == 1) {
    hm.model = loadShape("heads/joe/TheRock2.obj");

    hm.scale = 0.1;
    hm.rz = PI;
  }
  
  return hm;
}
