int _startX, _startY, _startMillis;
PVector _projectileSpeed = null;
PVector _projectilePos = null;

int projSize;

void setup()
{
  size(displayWidth,displayHeight);
  projSize = displayWidth / 10;
}


void draw()
{
  if (_projectilePos != null)
  {
    ellipse(_projectilePos.x, _projectilePos.y, projSize, projSize);
    _projectilePos.x += _projectileSpeed.x;
    _projectilePos.y += _projectileSpeed.y;
    _projectileSpeed.setMag(_projectileSpeed.mag() * 0.99);
    
    if (_projectileSpeed.mag() < 0.4 || _projectilePos.x < 0 || _projectilePos.x > displayWidth || _projectilePos.y < 0 || _projectilePos.y > displayHeight)
    {
      ellipse(_projectilePos.x, _projectilePos.y, projSize*1.5, projSize*1.5);
      _projectilePos = null;
      println("stopped");
    }
  }
}

void mousePressed()
{
  _startX = mouseX;
  _startY = mouseY;
  _startMillis = millis();
}

void mouseReleased()
{
  _projectilePos = new PVector(mouseX, mouseY);
  _projectileSpeed = new PVector(mouseX - _startX, mouseY - _startY);
  _projectileSpeed.setMag(_projectileSpeed.mag() / (millis() - _startMillis) * 10);
  println(millis() - _startMillis, _projectileSpeed.mag());
}