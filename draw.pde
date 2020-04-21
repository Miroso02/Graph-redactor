void draw() {
  background(200);
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    vertexes.get(i).display();
    if (moveVertex.state == 0 && travel.state == 0)
      vertexes.get(i).select();
  }
  /*text("Граф конденсації:", width - 200, height / 2 + 300);
  text("1-7 9-12", width - 270, height / 2 + 370);
  text("8", width - 250, height / 2 + 520);
  for (Vertex v: condensVert) {
    v.display();
  }*/
  
  travel.display();
  if (travel.press())
  {
    travelIndex = 0;
    queue = new ArrayList<Link>();
    visited = new ArrayList<Vertex>();
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
      text("Обхід завершено", width / 2, height / 2 + 120);
    }
    next.display();
    if (next.press())
    {
      for (Vertex v: visited)
      {
        v.opp = 255;
        v.setColor(255, 100, 100);
      }
      for (Link l: queue)
        l.opp = 255;
      if (!travelGraph()) 
      {
        
      }
       // travel.state = 0;
    }
    return;
  }
  
  if (chosen != null) 
  {
    linkLength.display();
    if (linkLength.press())
      linkLength.setText("Шляхи \n довжиною " + (linkLength.state + 1));
    moveVertex.update();
    gc.displayInfo();
    
    if (moveVertex.state == 1)
    {
      chosen.position.add(mouseX - pmouseX, mouseY - pmouseY);
    }
  }
  //gc.writeGraphIsRegular();
}