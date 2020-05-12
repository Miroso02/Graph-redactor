ArrayList<Vertex> visited = new ArrayList<Vertex>();
ArrayList<Link> queue = new ArrayList<Link>();
ArrayList<Link> basis = new ArrayList<Link>();
ArrayList<Vertex> vertexQueue = new ArrayList<Vertex>();
Vertex chosenVert, changedVert;
Link currentLink;
int travelIndex = 0;
int opp = 0;
public boolean travelGraph()
{
  if (travelIndex < queue.size())
  {
    Link link = queue.get(travelIndex++);
    link.end.setColor(0, 255, 100);
    link.end.opp = 255;
    if (!visited.contains(link.end))
    {
      visited.add(link.end);
      for (Link plink: link.end.links)
      {
        if (!visited.contains(plink.end))
        {
          boolean adding = true;
          for (Link elink: queue)
          {
            if (elink.end == plink.end)
            {
              adding = false;
              break;
            }
          }
          if (adding) queue.add(plink);
        }
      }
    }
  }
  else return false;
  println(travelIndex);
  return true;
}

public boolean travelBasis()
{
  while (true)
  {
    if (visited.size() == GRAPH_COUNT)
      return false;
    Link chosen = queue.get(0);
    for (Link link: queue)
    {
      if (visited.contains(link.start) 
       && visited.contains(link.end))
        continue;
      if (chosen == null || link.weight < chosen.weight)
        chosen = link;
    }
    Vertex newV = visited.contains(chosen.end) ? chosen.start: chosen.end;
    visited.add(newV);
    for (Vertex v: vertexes)
      for (Link l: v.links)
        if (l.start == newV || l.end == newV)
          queue.add(l);
    newV.setColor(0, 100, 255);
    newV.opp = 255;
    basis.add(chosen);
    queue.remove(chosen);
    return true;
  }
}

public void findShortestPath()
{
  if (queue.size() == 0)
  {
    currentLink = null;
    if (chosenVert != null) {
      visited.add(chosenVert);
      chosenVert.setColor(255, 255, 255);
    }
    chosenVert = vertexQueue.get(travelIndex++);
    chosenVert.setColor(150, 150, 255);
    for (Vertex v: vertexes)
      for (Link l: v.links)
        if (l.start == chosenVert && !visited.contains(l.end)
         || l.end == chosenVert && !visited.contains(l.start))
          queue.add(l);
    return;
  }
  currentLink = queue.get(0);
  for (Link l: queue)
  {
    if (currentLink == null || l.weight < currentLink.weight)
      currentLink = l;
  }
  Vertex nextV = chosenVert == currentLink.start ? currentLink.end : currentLink.start;
  if (!vertexQueue.contains(nextV))
    vertexQueue.add(nextV);
  int len = chosenVert.pathLength + currentLink.weight;
  if (len < nextV.pathLength)
  {
    nextV.pathLength = len;
    changedVert = nextV;
  }
  queue.remove(currentLink);
}