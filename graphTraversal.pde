ArrayList<Vertex> visited = new ArrayList<Vertex>();
ArrayList<Link> queue = new ArrayList<Link>();
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