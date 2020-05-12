public class Link 
{
  Vertex start;
  Vertex end;
  color col;
  int opp;
  int weight;
  float koef;
  
  public Link(Vertex start, Vertex end)
  {
    this.start = start;
    this.end = end;
    weight = int(random(10));
    col = color(0);
    opp = 255;
    koef = random(0.6, 1.7);
  }
  
  public void setColor(int r, int g, int b)
  {
    col = color(r, g, b);
  }
  
  void display() 
  {
    boolean crossed = false;
    Link crossedLink = end.getLinkTo(start);
    if (crossedLink != null && end != start) 
    {
      if (DIRECTED) crossed = true;
      else end.links.remove(crossedLink);
      commonLink(end, DIRECTED);
    }
    if (crossed) return;
    commonLink(end, false);
  }

  private void commonLink(Vertex graph, boolean imaginary) {
    PVector startPoint = start.position;
    PVector endPoint = graph.position;
    ArrayList<PVector> points = new ArrayList<PVector>();
    points.add(startPoint);

    Vertex touched = linkTouchVertex(startPoint, endPoint);
    if (touched != null && getDistSq(touched.position, startPoint) < sq(VERTEX_DIAMETER)) return;
    
    if (startPoint == endPoint) {
      points.add(start.position.copy().add(VERTEX_DIAMETER / 2 + 5, VERTEX_DIAMETER / 2));
      PVector lastP = start.position.copy().add(VERTEX_DIAMETER / 2 + 10, -VERTEX_DIAMETER / 2);
      points.add(lastP);
      startPoint = lastP;
      touched = null;
    }
    
    if (imaginary) {
      if (touched == null || touched.value == graph.value) {
        vertexes.set(12, new Vertex(0, startPoint.copy().add(endPoint).div(2)));
        touched = vertexes.get(12);
        //touched.display();
      }
    }

    while (touched != null) {
      if (touched.value == graph.value) break;
      final float indent = VERTEX_DIAMETER * (0.75 + (float)(start.value + graph.value) / 30);
      
      PVector transfPoint = new PVector(0, 0);
      PVector touchedPos = touched.position.copy();
      
      if (startPoint.x >= touchedPos.x && startPoint.y < touchedPos.y) {
        transfPoint = touchedPos.add(indent, 0);
      } else if (startPoint.x <= touchedPos.x && startPoint.y > touchedPos.y) {
        transfPoint = touchedPos.add(-indent, 0);
      } else if (startPoint.x > touchedPos.x && startPoint.y >= touchedPos.y) {
        transfPoint = touchedPos.add(0, indent);
      } else if (startPoint.x < touchedPos.x && startPoint.y <= touchedPos.y) {
        transfPoint = touchedPos.add(0, -indent);
      }
      
      touched = linkTouchVertex(startPoint, transfPoint);
      if (touched != null) continue;
      
      points.add(transfPoint);
      startPoint = transfPoint;

      touched = linkTouchVertex(startPoint, graph.position);
    }
    
    vertexes.get(12).position.set(-100, 0);
    PVector lastPoint = findIntersectPoint(startPoint, endPoint);
    points.add(lastPoint);
    
    boolean blueArr = (graph == chosen
                    && graph != start);
    drawArrow(points, blueArr);
  }

  private Vertex linkTouchVertex(PVector pos0, PVector pos1) {
    Vertex intersected = null;
    float leastDist = 5000;

    for (Vertex other: vertexes) {
      if (other.position.x - VERTEX_DIAMETER / 2 > max(pos0.x, pos1.x)
        || other.position.y - VERTEX_DIAMETER / 2 > max(pos0.y, pos1.y)
        || other.position.x + VERTEX_DIAMETER / 2 < min(pos0.x, pos1.x)
        || other.position.y + VERTEX_DIAMETER / 2 < min(pos0.y, pos1.y)) continue;
      if (other == start) continue;

      float distToVertex = getDist(other.position, pos0);
      // (x - x1) * (y2 - y1) = (y - y1) * (x2 - x1)
      // x(y2 - y1) + y(x1 - x2) + y1(x2 - x1) - x1(y2 - y1) = 0
      float dist = 
        abs(other.position.x * (pos1.y - pos0.y) + other.position.y * (pos0.x - pos1.x) + pos0.y * pos1.x - pos0.x * pos1.y)
        / sqrt(sq(pos1.x - pos0.x) + sq(pos1.y - pos0.y));
      if (dist < VERTEX_DIAMETER / 2 && distToVertex < leastDist) {
        intersected = other;
        leastDist = distToVertex;
      }
    }
    return intersected;
  }
  
  //----------------------------------------------------------
  
  float getDistSq(PVector p1, PVector p2) {
    return sq(p1.x - p2.x) + sq(p1.y - p2.y);
  }
  float getDist(PVector p1, PVector p2) {
    return sqrt(getDistSq(p1, p2));
  }
  private PVector findIntersectPoint(PVector p1, PVector p2) {
    float dist = getDist(p1, p2);
    final int r = VERTEX_DIAMETER / 2;
    float x = (p1.x * r + p2.x * (dist - r)) / dist;
    float y = (p1.y * r + p2.y * (dist - r)) / dist;
    return new PVector(x, y);
  }
  void drawArrow(ArrayList<PVector> points, boolean blue) {
    col = color(0);
    if (linkLength.state == 0)
    {
      if (chosen == start)
        col = color(255, 0, 0);
      if (chosen == end)
        col = DIRECTED ? color(0, 0, 255) :
                         color(255, 0, 0);
    }
    if (chosen != null) chosen.colorizePaths();
    if (travel.state == 1)
    {
      if (queue.contains(this))
      {
        opp = 255;
        col = color(150, 0, 255);
      }
      if (currentLink == this)
      {
        opp = 255;
        col = color(255, 0, 0);
      }
      if (basis.contains(this))
      {
        opp = 255;
        col = color(255, 100, 100);
      }
      if (basis.size() > 0 && basis.get(basis.size() - 1) == this)
      {
        opp = 255;
        col = color(0, 100, 255);
      }
    }
    stroke(col, opp);
    fill(col, opp);
    for (int i = 0; i < points.size() - 1; i++) {
      line(points.get(i), points.get(i + 1));
    }
    PVector pLast = points.get(points.size() - 1);
    PVector pPreLast = points.get(points.size() - 2);
    
    float k = -(pLast.x - pPreLast.x) / (pLast.y - pPreLast.y);
    Arrow arr = new Arrow();
    if (pLast.y < pPreLast.y) arr.rotate(atan(k));
    else arr.rotate(PI + atan(k));
    arr.translate(pLast.x, pLast.y);
    if (DIRECTED) arr.display();
    
    if (chosen == start || chosen == end
     || queue.contains(this) || currentLink == this)
    {
      textSize(25);
      if (points.size() > 2)
      {
        int a = int(points.size() - 1 - koef);
        
        text(weight, (points.get(a).x + koef * points.get(a + 1).x) / (1 + koef),
                     (points.get(a).y + koef * points.get(a + 1).y) / (1 + koef));
      }
      else
        text(weight, (start.position.x + koef * end.position.x) / (1 + koef),
                     (start.position.y + koef * end.position.y) / (1 + koef));
    }
  }
}