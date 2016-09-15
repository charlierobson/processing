int _startX, _startY, _startMillis;
PVector _projectileSpeed = null;
PVector _projectilePos = null;

int projSize;
boolean _pushing;

void setup()
{
  size(displayWidth,displayHeight);
  projSize = displayWidth / 10;
  _pushing = false;
}

int CMASK_LEFT = 1;
int CMASK_RIGHT = 3;
int CMASK_TOP = 4;
int CMASK_SIDES = CMASK_LEFT|CMASK_RIGHT;
int CMASK_EDGE = CMASK_LEFT|CMASK_RIGHT|CMASK_TOP;


int getCollisionMask(PVector position, int size)
{
  int mask = 0;
  if (position.x - (size / 2) <= 0) mask |= CMASK_LEFT;
  if (position.x + (size / 2) >= displayWidth) mask |= CMASK_RIGHT;
  if (position.y - (size / 2) <= 0) mask |= CMASK_TOP;

  return mask;
}

void draw()
{
  background(150);
  line (0,(displayHeight*3/4),displayWidth,(displayHeight*3/4));
  if (_projectilePos == null)
  {
    ellipse(mouseX, mouseY, projSize, projSize);
    if (mouseY < (displayHeight*3/4) && _pushing)
    {
      releasePuck();
    }
  }
  else
  {
    _projectilePos.x += _projectileSpeed.x;
    _projectilePos.y += _projectileSpeed.y;

    int collisionMask = getCollisionMask(_projectilePos, projSize);
    if (collisionMask != 0)
    {
      // we've collided with something
      if ((collisionMask & CMASK_EDGE) != 0)
      {
        // edge collision of some sort
        if ((collisionMask & CMASK_SIDES) != 0)
        {
            _projectileSpeed.x = -_projectileSpeed.x;
        }
        else
        {
            _projectileSpeed.y = -_projectileSpeed.y;
        }

        _projectileSpeed.setMag(_projectileSpeed.mag() * 0.95);
      }
    }

    _projectileSpeed.setMag(_projectileSpeed.mag() * 0.992);
    
    ellipse(_projectilePos.x, _projectilePos.y, projSize, projSize);

    if (_projectileSpeed.mag() < 0.4 ||_projectilePos.y > (displayHeight*3/4))
    {
      ellipse(_projectilePos.x, _projectilePos.y, projSize*1.5, projSize*1.5);
      _projectilePos = null;
      println("stopped");
    }
  }
}

void mousePressed()
{
  if (mouseY > (displayHeight*3/4))
  {
    _pushing = true;
    _startX = mouseX;
    _startY = mouseY;
    _startMillis = millis();
  }
}

void releasePuck()
{
  if (_projectilePos == null && _pushing)
  {
    _projectilePos = new PVector(mouseX, mouseY);
    _projectileSpeed = new PVector(mouseX - _startX, mouseY - _startY);
    _projectileSpeed.setMag(_projectileSpeed.mag() / (millis() - _startMillis) * 20);
    println(millis() - _startMillis, _projectileSpeed.mag());
  }
  _pushing = false;
}

void mouseReleased()
{
  releasePuck();
}