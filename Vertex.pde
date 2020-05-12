public class Vertex {
  int value;
  color col;
  int opp;
  PVector position;
  int pathLength;
  ArrayList<Link> links = new ArrayList<Link>();
  ArrayList<ArrayList<Integer>> paths2 = new ArrayList<ArrayList<Integer>>();
  ArrayList<ArrayList<Integer>> paths3 = new ArrayList<ArrayList<Integer>>();

  public Vertex(int value, float x, float y) {
    this.value = value;
    position = new PVector(x, y);
    col = color(255);
    opp = 255;
    pathLength = 1000;
  }
  public Vertex(int value, PVector position) {
    this.value = value;
    this.position = position.copy();
    col = color(255);
    opp = 255;
    pathLength = 1000;
  }

  void display() {
    for (Link l: links)
      l.display();
    fill(col, opp);
    stroke(0, opp);
    circle(position, VERTEX_DIAMETER);
    
    fill(0, opp);
    textSize(40);
    text(value, position.x, position.y);
    
    if (travel.state == 1)
    {
      fill(0, 0, 255, opp);
      if (changedVert == this)
        fill(255, 0, 0);
      textSize(30);
      text(pathLength, position.x, position.y - 55);
    }
  }

  void addLinks(Vertex ...newLinks) {
    for (Vertex link : newLinks) {
      links.add(new Link(this, link));
    }
  }
  
  void addLink(Vertex vertex, int weight) {
    Link newL = new Link(this, vertex);
    newL.weight = weight;
    links.add(newL);
  }
  
  void move() {
    if (mousePressed) {
      if (sq(mouseX - position.x) + sq(mouseY - position.y) < sq(VERTEX_DIAMETER)) {
        if (chosen == null) chosen = this;
        if (chosen != this) return;
        position.add(mouseX - pmouseX, mouseY - pmouseY);
      } 
    } else chosen = null;
  }
  void select() 
  {
    if (mousePressed)
    {
      if (sq(mouseX - position.x) + sq(mouseY - position.y) < sq(VERTEX_DIAMETER)) 
      {
        chosen = this;
      }
    }
  }
  
  void findPathsWithLength(
    ArrayList<ArrayList<Integer>> paths,
    ArrayList<Integer> path, 
    int length, Vertex current) 
  {
    path.add(current.value);
    if (length-- == 0) 
    {
      paths.add(path);
      return;
    }
    for (Link link: current.links) {
      findPathsWithLength(paths, copy(path), length, link.end);
    }
  }
  
  void colorizePaths()
  {
    int len = linkLength.state;
    if (len == 1)
    {
      for (ArrayList<Integer> path: paths2)
      {
        colorizePath(path, len);
      }
    }
    else if (len == 2)
    {
      for (ArrayList<Integer> path: paths3)
      {
        colorizePath(path, len);
      }
    }
  }
  void colorizePath(ArrayList<Integer> path, int colIndex)
  {
    //print(9);
    for (int i = 0; i < path.size() - 1; i++)
    {
      vertexes.get(path.get(i) - 1)
              .getLinkTo(vertexes.get(path.get(i+1) - 1))
              .col = linkLength.colors[colIndex];
    }
  }
  
  //---------------------------------------

  public Link getLinkTo(Vertex v) {
    for (Link l: links) 
      if (l.end == v) return l;
    return null;
  }
  
  public void setColor(int r, int g, int b)
  {
    col = color(r, g, b);
  }
}
