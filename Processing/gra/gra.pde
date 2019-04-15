int pts=4; //liczba punktów
int ptRozmiar=6; //rozmiar punktów
int nowePts = 6;
float []x=new float[pts];                //x dla punktow kontrolnych
float []y=new float[pts];                //y dla punktow kontrolnych
float []x1 = new float[nowePts+pts];     //x dla wszystkich 9 punktow
float []y1 = new float[nowePts+pts];     //y dla wszystkich 9 punktow
float []xHelp = new float[nowePts+pts];  //tablica pomocnicza dla x do wyznaczania punktow krzywej beziera
float []yHelp = new float[nowePts+pts];  //tablica pomocnicza dla y do wyznaczania punktow krzywej beziera
float []punktyxB = new float[1000];      //x punktow krzywej beziera
float []punktyyB = new float[1000];      //y punktow krzywej beziera
PFont czcionka;
float u=0.5;
int rb=255, gb=255, bb=255;
int roznica = 200;
boolean []Przesuniecie = new boolean[pts]; //przesuwanie punktów
boolean playGuard = false, startGuard = false, napis=false, wyswietl=false, napis2=false;
boolean poziom1 = true, poziom2=false, proba=false, rysujBeziera=false, czyPunktyBeziera=false;

void setup() {
  size(700, 900);
  smooth();
  losujPunktyBazowe();                      //losujemy punkty kontrolne krzywej
  czcionka = loadFont("Verdana-14.vlw");    //gdyby tutaj przy pierwszym starcie wysąapił błąd, należy dodać czcionkę, Tools->Create Font->Verdana, size 14
  textFont(czcionka);
};

void draw() {
  naStart();
  przepiszPunkty();                        //przepisanie punktow kontrolnych do nowej tablicy 
  wyliczPunkty(u);                         //wyliczenie punktów dla wieloboku Casteljou dla parametru u
  wypisz();                                //wypisanie wszelkich tekstow na ekranie
  rysujStartMeta();                        //rysowanie pol START i META
  rysujPunktyKontrolne();                  //rysowanie punktów kontrolnych
  numeryPunktowKontrolnych();              //wypisanie numerów punktów kontrolnych
  przepiszPunktyB();                       //przepisanie punktów do nowej tablicy w celu liczenia na ich podstawie punktów Beziera
  punktyBeziera();                         //wyznaczenie punktow na krzywej Beziera
  if (poziom1 && napis==false)             
  {
    wyswietl=false;
    sprawdzStart();                        //sprawdzamy, czy 1 punkt na starcie, 4 na mecie
    poziomRys1(300, 0, 50, 450, 1);        //rysowanie 1 poziomu
    rysujPunktyKontrolne();                //rysowanie punktow kontrolnych, aby byly widoczne
    numeryPunktowKontrolnych();            //wypisanie numerów punktow kontrolnych, aby byly widoczne
    if (playGuard && startGuard)
    {
      if (czyZaliczony1(300, 0, 50, 450))
      {
        napis=true;
        playGuard=false;
        poziom1=false;
        poziom2=true;
        wyswietl=true;
      } else
      {
        playGuard=false;
        napis2=true;
      }
    }
  };
  if (poziom2 && napis==false)
  {
    wyswietl=false;
    poziomRys2(300, 0, 50, 320, 300, 350, 50, 350, 2);          //rysujemy poziom 2
    rysujPunktyKontrolne();
    numeryPunktowKontrolnych();
    if (playGuard && startGuard)
    {
      if (czyZaliczony2(300, 0, 50, 320, 300, 350, 50, 350))
      {
        napis=true;
        playGuard=false;
        poziom1=true;
        poziom2=false;
        wyswietl=true;
      } else
      {
        playGuard=false;
        napis2=true;
      }
    }
  };
  if (wyswietl)
  {
    rysujLinie();
    rysujPunkty();
    bezierRysuj();
  }  
  if (napis)
  {
    wypisz2();
  }
  if (napis2)
  {
    wypisz3();
  };

  if (proba)              //poziom sprawdzania krzywej
  {
    naStart();
    rysujLinie();
    rysujPunkty();
    rysujPunktyKontrolne();
    numeryPunktowKontrolnych();
    bezierRysuj();
    wypisz();
    wypisz4();
    if(czyPunktyBeziera)      //wyswietlanie punktow beziera
    {
      rysujPB();
    }
  };
  for (int i=0; i<pts; i++) {
    if (Przesuniecie[i]) {
      x[i] = mouseX;
      y[i] = mouseY;
    };
 };
};
void sprawdzStart()      //sprawdza, czy pkt 1 jest na starcie i pkt 4 na mecie
{
  if (x[0]>=10 && x[0]<=60 && y[0]>=630 && y[0]<=680 && x[3]>=640 && x[3]<=690 && y[3]>=20 && y[3]<=70)
    startGuard=true;
  else
  {
    startGuard=false;
    playGuard=false;
  }
};

void poziomRys1(int x, int y, int w, int h, int poziom)    //tworzenie rysowanie przeszkod dla poziomu
{
  fill(100);
  rect(x, y, w, h);
  text("Poziom: "+poziom, 10, 20);
};

boolean czyZaliczony1(int x, int y, int w, int h)      //sprawdzenie czy poziom moze byc zaliczony
{
  boolean guard=true;
  for (int i=0; i<1000; i++)
  {
    if ((punktyxB[i]<=x+w && punktyxB[i]>=x && punktyyB[i]>=y && punktyyB[i]<=y+h) || (punktyyB[i]>=700))
    {
      guard=false;
      return guard;
    };
  }
  return true;
};

void poziomRys2(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2, int poziom)
{
  fill(100);
  rect(x1, y1, w1, h1);
  rect(x2, y2, w2, h2);
  text("Poziom: "+poziom, 10, 20);
};

boolean czyZaliczony2(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2)
{
  boolean guard=true;
  for (int i=0; i<1000; i++)
  {
    if ((punktyxB[i]<=x1+w1 && punktyxB[i]>=x1 && punktyyB[i]>=y1 && punktyyB[i]<=y1+h1) || (punktyyB[i]>=700) || (punktyxB[i]<=x2+w2 && punktyxB[i]>=x2 && punktyyB[i]>=y2 && punktyyB[i]<=y2+h2))
    {
      guard=false;
      return guard;
    };
  }
  return true;
};
void przepiszPunkty()      //funkcja przepisuje punkty kontrolne do tablicy wszystkich punktow
{
  for (int i=0; i<pts; i++)
  {
    x1[i]=x[i];
    y1[i]=y[i];
  }
};

void wyliczPunkty(float u)    //liczy punkty dla wieloboku Casteljou dla parametru u
{
  int j=0;
  for (int i=0; i<nowePts; i++)
  {
    x1[pts+i] = x1[j]+((x1[j+1]-x1[j])*u);
    y1[pts+i] = y1[j]+((y1[j+1]-y1[j])*u);
    j++;
    if (j == 3 || j == 6)
    {
      j++;
    }
  }
};

void przepiszPunktyB()    //przepisuje punkty do tabeli pomocniczej
{
  for (int i=0; i<pts; i++)
  {
    xHelp[i]=x[i];
    yHelp[i]=y[i];
  }
};

void punktyBeziera()    //wyznaczenie punktow krzywej Beziera
{
  int k=0;
  for (float z = 0.001; z<1; z+=0.001)
  {
    int j=0;
    for (int i=0; i<nowePts; i++)
    {
      xHelp[pts+i] = xHelp[j]+((xHelp[j+1]-xHelp[j])*z);
      yHelp[pts+i] = yHelp[j]+((yHelp[j+1]-yHelp[j])*z);
      j++;
      if (j == 3 || j == 6)
      {
        j++;
      }
    }
    punktyxB[k]=xHelp[9];
    punktyyB[k]=yHelp[9];
    k++;
  }
};

void losujPunktyBazowe()    //losuje punkty startowe w odpowiednich ćwiartkach
{
  x[0] = random(0, width/2);
  y[0] = random((height-roznica)/2, height-roznica-1);

  x[1] = random(0, width/2);
  y[1] = random(0, (height-roznica)/2);

  x[2] = random(width/2, width-1);
  y[2] = random(0, (height-roznica)/2);

  x[3] = random(width/2, width-1);
  y[3] = random((height-roznica)/2, height-roznica-1);

  for (int i=0; i<4; i++)
  {

    Przesuniecie [i]=false; //blokowanie punktów
  }
};
void keyPressed()      //reakcje na klawisze
{
  switch(key)
  {
  case '4':
    {
      u*=1000;
      u++;
      u/=1000;
    }
    break;
  case '1':
    {
      u*=1000;
      u--;
      u/=1000;
    }
    break;
  case '5':
    {
      u*=100;
      u++;
      u/=100;
    }
    break;
  case '2':
    {
      u*=100;
      u--;
      u/=100;
    }
    break;
  case '6':
    {
      u*=10;
      u++;
      u/=10;
    }
    break;
  case '3':
    {
      u*=10;
      u--;
      u/=10;
    }
    break;
  case '0':
    u=0.5;
    break;

  case 'q':
    rb+=5;
    break;
  case 'a':
    rb-=5;
    break;
  case 'w':
    gb+=5;
    break;
  case 's':
    gb-=5;
    break;
  case 'e':
    bb+=5;
    break;
  case 'd':
    bb-=5;
    break;
  case 'z':
    {
      rb=255;
      gb=255;
      bb=255;
    }
    break;

  case 'p':
    playGuard = true;        //po wcisnieciu p zaczynamy gre
    break;

  case 'l':                  //po wcisnieciu l resetujemy
    {
      wyswietl=false;
      playGuard = false;
    }
    break;
  case 'm':                //wlaczenie trybu sprawdzania krzywej
    proba=true;
    break;
  case 'n':              //wylaczenie trybu sprawdzania krzywej
    proba=false;
    break;
  case 'b':
    czyPunktyBeziera=true;
    break;
  case 'v':
    czyPunktyBeziera=false;
    break;
  }
  if (u<0) u=0;           //u ma zawsze byc w przedziale <0,1>, tutaj jest to sprawdzane i w razie przekroczenia przedzialu, nastepuje powrót do wartości brzegowej
  if (u>1) u=1;

  if (rb<0) rb=0;        //to samo co powyżej, wartosci RGB moga byc z przedzialu <0,255.
  if (rb>255) rb=255;
  if (gb<0) gb=0;
  if (gb>255) gb=255;
  if (bb<0) bb=0;
  if (bb>255) bb=255;
};
void mousePressed() 
{
  for (int i=0; i<pts; i++) {
    if (mouseX>=x[i]-5&&mouseX<=x[i]+ ptRozmiar +5 && mouseY>=y[i]-5&&mouseY<=y[i]+ ptRozmiar +5)   //warunek na to, ktory punkt ma byc odblokowany
    {
      Przesuniecie[i]=true;          //odblokowanie wybranego punktu
    };
  };
};


void mouseReleased() 
{
  for (int i=0; i<pts; i++)
  {
    Przesuniecie[i]=false;           //zablokowanie punktu
  };
};


void mouseMoved () {
  cursor(ARROW);    //zmiana ikony kursora na ikonę strzałki
  for (int i=0; i<pts; i++) {
    if (mouseX>=x[i]-5&&mouseX<=x[i]+ptRozmiar+5 && mouseY>=y[i]-5&&mouseY<=y[i]+ ptRozmiar +5)
    {
      cursor(HAND);    //zmiana ikony kursora na ikonę ręki
    };
  };
};

void mouseClicked()
{
  napis=false;
  napis2=false;
};
void naStart()
{
  background(rb, gb, bb); //nadawanie tla
  noFill();
  strokeWeight(2);
  stroke(0);
  line(0, height-roznica-1, width-1, height-roznica-1);
}


void rysujPunkty()      //rysuje punkty
{
  for (int i=pts; i<nowePts+pts; i++)
  {
    fill(0, 0, 255);
    ellipse(x1[i], y1[i], 5, 5);
  }
};


void rysujPunktyKontrolne()    //rysuje punkty kontrolne
{
  for (int i=0; i<pts; i++)
  {
    fill(0, 0, 255);
    ellipse(x1[i], y1[i], 5, 5);
  }
};


void bezierRysuj()        //rysuje krzywa beziera dla punktow kontrolnych
{        
  noFill();
  stroke(0, 0, 255);
  bezier (x[0], y[0], x[1], y[1], x[2], y[2], x[3], y[3]);
};


void rysujLinie()    //rysuje wielobok Casteljou
{
  stroke(255, 0, 0);
  line(x1[0], y1[0], x1[1], y1[1]);
  line(x1[1], y1[1], x1[2], y1[2]);
  line(x1[2], y1[2], x1[3], y1[3]);
  line(x1[4], y1[4], x1[5], y1[5]);
  line(x1[5], y1[5], x1[6], y1[6]);
  line(x1[7], y1[7], x1[8], y1[8]);
};


void rysujStartMeta()      //rysuje pola start i meta
{
  noStroke();
  fill(255, 255, 210);
  rect(10, 630, 50, 50);     //start
  rect(640, 20, 50, 50);        //meta
  fill(0);
  text("START", 12, height-roznica-5);
  text("META", width-55, 15);
};

void rysujPB()      //rysuje punkty z krzywej beziera (wybrane w odstepie co 16, zaczynajac od 12 punktu idac od pierwszego punktu kontrolnego
{
  for (int i =12; i<1000; i+=16)
  {
    fill(0, 200, 0);
    noStroke();
    ellipse(punktyxB[i], punktyyB[i], 8, 8);
  }
}
void numeryPunktowKontrolnych()      //numerowanie punktów kontrolnych
{
  for (int i=1; i<5; i++)
  {
    fill(0);
    text(i, x[i-1]+10, y[i-1]+10);
  }
};


void wypisz()      //wypisywanie okna 
{
  fill(0);
  text("Wartości RGB dla tła:", 40, 730);
  text("R = "+rb+"     (Q/A - zmiana wartości)", 10, 750);
  text("G = "+gb+"     (W/S - zmiana wartości)", 10, 770);
  text("B = "+bb+"     (E/D - zmiana wartości)", 10, 790);
  text("Z - reset kolorów", 10, 810);
  text("M - włącz tryb sprawdzenia krzywej", 10, 830);
  text("N - wyłącz tryb sprawdzenia krzywej", 10, 850);
  text("P - rozpocznij", 10, 870);
  text("L - resetuj", 10, 890);
  
  text("Wartość u: "+u, 300, 730);
  text("1/4   -   -/+ o 0.001", 300, 750);
  text("2/5   -   -/+ o 0.01", 300, 770);
  text("3/6   -   -/+ o 0.1:", 300, 790);
  text("0   -   reset  'u'", 300, 810);
};


void wypisz2()
{
  stroke(0);
  fill(255);
  rect(200, 280, 280, 50);
  fill(255, 0, 0);
  text("POZIOM I ZALICZONY. GRATULACJE!!!", 210, 300);
  text("kliknij przycisk myszy by kontynuowac", 210, 320);
};


void wypisz3()
{
  stroke(0);
  fill(255);
  rect(200, 280, 280, 50);
  fill(255, 0, 0);
  text("SPRÓBUJ JESZCZE RAZ", 260, 300);
  text("kliknij przycisk myszy, by kontynuowac", 208, 320);
};

void wypisz4()
{
  text("B - włącz punkty beziera", 300, 830);
  text("V - wyłącz punkty beziera", 300, 850);
};