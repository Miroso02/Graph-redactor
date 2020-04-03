class GraphController {
  GraphController() {}
  
  void displayInfo() {
    fill(0);
    textSize(40);
    text("Вершина " + chosen.value, width / 2, 800);
    int power = 0;
    int in = 0;
    int out = 0;
    for (Link l: chosen.links) out++;
    for (Vertex v: vertexes) {
      if (v.getLinkTo(chosen) != null) in++;
    }
    power = in + out;
    switch (linkLength.state) 
    {
      case 0:
        if (DIRECTED) 
        {
          fill(255, 0, 0);
          text("Вихід " + out, width / 4 - 50, 800);
          fill(0, 0, 255);
          text("Захід " + in, 3 * width / 4 + 50, 800);
          fill(0);
        }
        break;
      case 1:
        fill(0);
        textSize(30);
        for (int i = 0; i < chosen.paths2.size(); i++)
        {
          String text = "";
          for (int a: chosen.paths2.get(i))
          {
            text = text + a + " ";
          }
          text(text, 100, height / 2 + 270 + 35 * i);
        }
        break;
      case 2:
        fill(0);
        textSize(30);
        for (int i = 0; i < chosen.paths3.size(); i++)
        {
          String text = "";
          for (int a: chosen.paths3.get(i))
          {
            text = text + a + " ";
          }
          text(text, 100, height / 2 + 270 + 35 * i);
        }
        break;
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
      for (Link l: vertexes.get(i).links) out++;
      for (Vertex v: vertexes) {
        if (v.getLinkTo(vertexes.get(i)) != null) in++;
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