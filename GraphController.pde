class GraphController {
  GraphController() {}
  
  void displayInfo() {
    fill(0);
    text("Вершина " + chosen.value, width / 2, 800);
    int power = 0;
    int in = 0;
    int out = 0;
    for (Vertex v: chosen.linked) out++;
    for (Vertex v: vertexes) {
      for (Vertex link: v.linked) {
        if (link == chosen) in++;
      }
    }
    power = in + out;
    if (DIRECTED) {
      fill(255, 0, 0);
      text("Вихід " + out, width / 4 - 50, 800);
      fill(0, 0, 255);
      text("Захід " + in, 3 * width / 4 + 50, 800);
      fill(0);
    }
    text("Степінь " + power, width / 2, 850);
    if (power == 0) text("Ізольована", width / 2, 900);
    else if (power == 1) text("Висяча", width / 2, 900);
  }
  
  
  void writeGraphIsRegular() {
    int powers[] = new int[vertexes.size()];
    for (int i = 0; i < vertexes.size(); i++) {
      int in = 0;
      int out = 0;
      for (Vertex v: vertexes.get(i).linked) out++;
      for (Vertex v: vertexes) {
        for (Vertex link: v.linked) {
          if (link == vertexes.get(i)) in++;
        }
      }
      powers[i] = in + out;
    }
    
    int basePower = powers[0];
    for (int a : powers) {
      if (basePower != a) {
        text("Граф неоднорідний", width / 2, 1000);
        return;
      }
    }
    text("Граф однорідний. Степінь однорідності " + basePower, width / 2, 1000);
  }
}