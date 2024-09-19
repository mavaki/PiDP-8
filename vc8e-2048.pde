float x = 0, y = 0;
long time = 0;

import processing.net.*;
Client s;

//import processing.serial.*;
//Serial s;

short old_sr = 0;
short sr = 0;

void setup()
{
  size(2048, 2048);
  background(0);
  frameRate(60);
  s = new Client(this, "10.7.21.225", 2222);
  //s = new Serial(this, "/dev/ttyVID", 230400);

  Runtime.getRuntime().addShutdownHook(new Thread()
  {
    @Override public void run() 
    {
      s.stop();
    }
  }
  );
}

char coord[] = new char[4];
int i = 0;

void draw()
{
  while (millis () - time < 30)
  {
    if (s.available() >= 5)
    {
      if (s.readChar() == 0)
        i++;
      else
        i = 0;
      if (i == 2)
      {
        i = 0;
        for (int k = 0; k < 4; k++)
          coord[k] = char(s.readChar() & 0x3F);
        x = ((((coord[0] | (coord[1] << 6)) / 2.0) + 256) % 512) * 4;
        y = ((((coord[2] | (coord[3] << 6)) / 2.0) + 256) % 512) * 4;

        stroke(0, 255, 0);
        point(x, y);
        
        for (int i = 0; i < 4; i++) {
          for (int j = 0; j < 4; j++) {
              point(x-2+i,y-2+j);
          }
        }
        
      }
    }
  }
  time = millis();
  stroke(0, 30);
  fill(0, 30);
  rect(0, 0, 2048, 2048);
}
/*
void keyPressed()
{
  s.write(key);
}
*/
void keyPressed()
{
  old_sr = sr;
  switch (key)
  {
  case '1':
    sr |= 0x800;
    break;
  case '2':
    sr |= 0x400;
    break;
  case '3':
    sr |= 0x200;
    break;
  case '4':
    sr |= 0x100;
    break;
  case '5':
    sr |= 0x80;
    break;
  case '6':
    sr |= 0x40;
    break;
  case '7':
    sr |= 0x20;
    break;
  case '8':
    sr |= 0x10;
    break;
  case '9':
    sr |= 0x8;
    break;
  case '0':
    sr |= 0x4;
    break;
  case '-':
    sr |= 0x2;
    break;
  case '=':
    sr |= 0x1;
    break;
  default:
    break;
  }
  if (old_sr != sr)
  {
    s.write((sr & 0xF) | ((sr & 0xF00) >> 4));
  }
}

void keyReleased()
{
  old_sr = sr;
  switch (key)
  {
  case '1':
    sr &= ~0x800;
    break;
  case '2':
    sr &= ~0x400;
    break;
  case '3':
    sr &= ~0x200;
    break;
  case '4':
    sr &= ~0x100;
    break;
  case '5':
    sr &= ~0x80;
    break;
  case '6':
    sr &= ~0x40;
    break;
  case '7':
    sr &= ~0x20;
    break;
  case '8':
    sr &= ~0x10;
    break;
  case '9':
    sr &= ~0x8;
    break;
  case '0':
    sr &= ~0x4;
    break;
  case '-':
    sr &= ~0x2;
    break;
  case '=':
    sr &= ~0x1;
    break;
  default:
    break;
  }
  if (old_sr != sr)
  {
    s.write((sr & 0xF) | ((sr & 0xF00) >> 4));
  }
}
