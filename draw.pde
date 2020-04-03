void draw() {
  background(200);
  //translate(mouseX - pmouseX, mouseY - pmouseY);
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    vertexes.get(i).display();
    if (moveVertex.state == 0)
      vertexes.get(i).select();
  }
  text("Граф конденсації:", width - 200, height / 2 + 300);
  text("1-7 9-12", width - 270, height / 2 + 370);
  text("8", width - 250, height / 2 + 520);
  for (Vertex v: condensVert) {
    v.display();
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