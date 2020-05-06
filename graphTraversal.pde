ArrayList<Vertex> visited = new ArrayList<Vertex>();
ArrayList<Link> queue = new ArrayList<Link>();
ArrayList<Link> basis = new ArrayList<Link>();
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