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
    if (basis.size() > 0)
    {
      int[][] basisMatrix = new int[GRAPH_COUNT][GRAPH_COUNT];
      for (Link l: basis)
      {
        int a = l.start.value - 1;
        int b = l.end.value - 1;
        basisMatrix[a][b] = 1;
        basisMatrix[b][a] = 1;
      }
      println();
      for (int i = 0; i < GRAPH_COUNT; i++) {
        println();
        for (int j = 0; j < GRAPH_COUNT; j++) {
          print(basisMatrix[i][j] + " ");
        }
      }
    }
    queue = new ArrayList<Link>();
    visited = new ArrayList<Vertex>();
    basis = new ArrayList<Link>();
    chosen = null;
    for (Vertex v: vertexes)
    {
      if (v.links.size() > 0)
      {
        v.opp = 255;
        v.setColor(0, 255, 100);
        visited.add(v);
        break;
      }
    }
    queue.addAll(visited.get(0).links);
    for (Link l: queue)
      if (l.start == l.end)
      {
        queue.remove(l);
        break;
      }
    
    if (travel.state == 1)
    {
      for (Vertex v: vertexes)
      {
        v.opp = 80;
        for(Link l: v.links)
          l.opp = 30;
      }
    }
    else
    {
      for (Vertex v: vertexes)
      {
        v.col = color(255);
        v.opp = 255;
        for(Link l: v.links)
          l.opp = 255;
      }
      
      queue = new ArrayList<Link>();
      visited = new ArrayList<Vertex>();
      basis = new ArrayList<Link>();
    }
  }
  if (travel.state == 1)
  {
    fill(0);
    textSize(40);
    String vis = "";
    for (Vertex v: visited)
    {
      vis = vis + v.value + " ";
    }
    textAlign(LEFT);
    text(vis, width / 2 - 200, height / 2 + 200);
    textAlign(CENTER, CENTER);
    if (travelIndex >= queue.size())
    {
      //queue.add(new Link(null, null));
      text("Кістяк побудовано", width / 2, height / 2 + 120);
    }
    next.display();
    if (next.press())
    {
      for (Vertex v: visited)
      {
        v.opp = 255;
        v.setColor(255, 100, 100);
      }
      
      ArrayList<Link> uselessLinks = new ArrayList<Link>();
      for (Link link: queue)
      {
        if (visited.contains(link.start) 
         && visited.contains(link.end))
          uselessLinks.add(link);
      }
      for (Link l: uselessLinks)
      {
        l.opp = 30;
        queue.remove(l);
      }
      travelBasis();
       // travel.state = 0;
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