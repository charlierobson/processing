int _startX, _startY, _startMillis;
PVector _projectileSpeed = null;
PVector _projectilePos = null;

int projSize, _collisionSize;
boolean _pushing;
boolean _lineTest;

int oc = 0;
int obstacles[];

void setup()
{
  size(displayWidth,displayHeight);
  projSize = displayWidth / 10;
  _pushing = false;

  obstacles = new int[300];
  oc = 0;
}

int CMASK_LEFT = 1;
int CMASK_RIGHT = 2;
int CMASK_TOP = 4;
int CMASK_BOTTOM = 8;
int CMASK_LR = CMASK_LEFT|CMASK_RIGHT;
int CMASK_TB = CMASK_TOP|CMASK_BOTTOM;
int CMASK_EDGE = CMASK_LR|CMASK_TB;


int getCollisionMask(PVector position, int size)
{
  int mask = 0;
  if (position.x - (size / 2) <= 0) mask |= CMASK_LEFT;
  if (position.x + (size / 2) >= displayWidth) mask |= CMASK_RIGHT;
  if (position.y - (size / 2) <= 0) mask |= CMASK_TOP;
  if (position.y + (size / 2) >= (displayHeight*3/4)) mask |= CMASK_BOTTOM;

  return mask;
}


int flingFunction()
{
  ellipse(mouseX, mouseY, projSize, projSize);
  if (mouseY < (displayHeight*3/4) && _pushing)
  {
    releasePuck();
   return 1;
  }
  if (_projectilePos != null)
  {
    return 1;
  }
  return 0;
}

int moveFunction()
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
        if ((collisionMask & CMASK_LR) != 0)
        {
            _projectileSpeed.x = -_projectileSpeed.x;
            if ((collisionMask & CMASK_LEFT) != 0) _projectilePos.x = projSize / 2 + 1;
            if ((collisionMask & CMASK_RIGHT) != 0) _projectilePos.x = displayWidth - (projSize / 2) - 1;
        }
        if ((collisionMask & CMASK_TOP) != 0)
        {
            _projectileSpeed.y = -_projectileSpeed.y;
            _projectilePos.y = projSize / 2 + 1;
        }

        _projectileSpeed.setMag(_projectileSpeed.mag() * 0.85);
      }
    }

    _projectileSpeed.setMag(_projectileSpeed.mag() * 0.98);
    
    ellipse(_projectilePos.x, _projectilePos.y, projSize, projSize);

    // 
    if (_projectilePos.y < (displayHeight*3/4)) 
    {
      _lineTest = true;
    }

    if (_lineTest && _projectilePos.y > (displayHeight*3/4))
    {
      _projectilePos = null;
      _lineTest = false;
      return 0;
    }
    if(_projectileSpeed.mag() < 0.4)
    {
      _collisionSize = projSize;
      return 2;      
    }
    return 1;
}

int inflateFunction()
{
  int mask = getCollisionMask(_projectilePos, _collisionSize);
  if (mask != 0)
  {
    if ((mask & CMASK_BOTTOM) != 0)
    {
      oc = 0;
    }
    else
    {
      obstacles[oc*3] = (int)_projectilePos.x;
      obstacles[oc*3+1] = (int)_projectilePos.y;
      obstacles[oc*3+2] = _collisionSize;
      ++oc;
    }
    
    _projectilePos = null;
    _pushing = false;
    return 0;
  }

  ++_collisionSize;
  ellipse(_projectilePos.x, _projectilePos.y, _collisionSize, _collisionSize);

  return 2;
}


int mode = 0;

void draw()
{
  background(150);
  line (0,(displayHeight*3/4),displayWidth,(displayHeight*3/4));

  for (int i = 0; i < oc; ++i)
  {
    ellipse(obstacles[i*3], obstacles[i*3+1], obstacles[i*3+2], obstacles[i*3+2]);
  }
  
  switch(mode)
  {
    case 0:
      mode = flingFunction();
      break;
    case 1:
      mode = moveFunction();
      break;
    case 2:
      mode = inflateFunction();
      break;
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
    _lineTest = false;
  }
  _pushing = false;
}

void mouseReleased()
{
  releasePuck();
}