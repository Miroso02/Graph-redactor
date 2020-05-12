void draw() {
  background(200);
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    vertexes.get(i).display();
    if (moveVertex.state == 0 && travel.state == 0)
      vertexes.get(i).select();
  }
  
  travel.display();
  if (travel.press())
  {
    travelIndex = 0;
    
    queue = new ArrayList<Link>();
    visited = new ArrayList<Vertex>();
    basis = new ArrayList<Link>();
    vertexQueue = new ArrayList<Vertex>();
    chosenVert = null;
    changedVert = null;
    currentLink = null;
    
    if (travel.state == 1)
    {
      if (chosen == null) 
        chosen = vertexes.get(0);
      vertexQueue.add(chosen);
      chosen.pathLength = 0;
    }
    else
    {
      for (Vertex v: vertexes)
      {
        v.col = color(255);
        v.opp = 255;
        v.pathLength = 1000;
        for(Link l: v.links)
          l.opp = 255;
      }
      
      queue = new ArrayList<Link>();
      visited = new ArrayList<Vertex>();
      basis = new ArrayList<Link>();
    }
    chosen = null;
  }
  if (travel.state == 1)
  {
    next.display();
    
    String vq = "Черга вершин: ";
    for (Vertex v: vertexQueue) {
      vq = vq + v.value + " ";
    }
    textAlign(LEFT);
    text(vq, 100, height / 2 + 180);
    textAlign(CENTER, CENTER);
    if (travelIndex >= GRAPH_COUNT)
    {
      chosenVert.setColor(0, 255, 0);
      text("Найкоротші шляхи знайдено", width / 2, height / 2 + 120);
    }
    else if (next.press())
    {
      changedVert = null;
      findShortestPath();
      for (Vertex v: visited)
        v.setColor(0, 255, 0);
    }
    return;
  }
  
  if (chosen != null) 
  {
    /*linkLength.display();
    if (linkLength.press())
      linkLength.setText("Шляхи \n довжиною " + (linkLength.state + 1));*/
    moveVertex.update();
    gc.displayInfo();
    
    if (moveVertex.state == 1)
    {
      chosen.position.add(mouseX - pmouseX, mouseY - pmouseY);
    }
  }
  //gc.writeGraphIsRegular();
}