boolean doing = true;
public class Switch
{
  PVector position;
  PVector dimensions;
  color colors[];
  int state;
  String text = "";
  private int nOfStates;
  
  public Switch(int nOfStates) 
  {
    this.nOfStates = nOfStates;
    state = 0;
    position = new PVector(width / 2, height / 2);
    dimensions = new PVector(200, 100);
    
    colors = new color[nOfStates];
    colorMode(HSB);
    for (int i = 0; i < colors.length; i++) 
    {
      colors[i] = color(random(255), 255, 255);
    }
    colorMode(RGB);
  }
  
  public void update()
  {
    press();
    display();
  }
  public void display()
  {
    fill(colors[state]);
    rect(position, dimensions);
    
    textSize(30);
    fill(0);
    text(text, position.x, position.y);
  }
  public boolean press()
  {
    if (mousePressed)
    {
      if (abs(position.x - mouseX) < dimensions.x 
       && abs(position.y - mouseY) < dimensions.y
       && doing)
      {
        doing = false;
        state++;
        if (state > nOfStates - 1) state = 0;
        return true;
      }
    }
    return false;
  }
  
  public void setPosition(float x, float y)
  {
    position.set(x, y);
  }
  public void setDimensions(float w, float h)
  {
    dimensions.set(w, h);
  }
  public void setColors(color ...cols)
  {
    colors = cols;
  }
  public void setText(String text)
  {
    this.text = text;
  }
}

void mouseReleased()
{
  doing = true;
}