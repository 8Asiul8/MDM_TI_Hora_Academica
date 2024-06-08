class dados {
  ArrayList <PImage> imgs;
  IntList tempos;
  int entradas;
  int saidas;
  int lim1, lim2;
  float x, y, h;
  color cor;
  int hor1, min1, sec1, hor2, min2, sec2;
  
  dados (File[] imgB, int lim1, int lim2, float x, float y, float h) {
    this.lim1 = lim1;
    this.lim2 = lim2;
    
    int limaux = lim1;
    hor1 = int(limaux/(3600.));
    limaux = limaux - (hor1*3600);
    min1 = int(limaux / 60.);
    limaux = limaux - (min1 * 60);
    sec1 = limaux;
    limaux = lim2;
    hor2 = int(limaux/(3600.));
    limaux = limaux - (hor2*3600);
    min2 = int(limaux / 60.);
    limaux = limaux - (min2 * 60);
    sec2 = limaux;
    
    
    imgs = new ArrayList<PImage>();
    tempos = new IntList();
    entradas = 0;
    saidas = 0;
    
    this.x = x;
    this.y = y;
    this.h = h;
    
    cor = color(255, 100);
    
    for (int i = 0; i < imgB.length; i++) {
      String tipo = imgB[i].getName().split("-")[0];
      int hor = int(imgB[i].getName().split("-")[1]);
      
      if( hor >= lim1 && hor < lim2) {
        PImage pass = loadImage(folderPath + "/" + files[i].getName());
        imgs.add(pass);
        tempos.append(hor);
        if(tipo.equals("S")) {
          saidas += 1;
        }
        else if(tipo.equals("E")) {
          entradas += 1;
        }
      }
    }
  }
  
  void desenha() {
    push();
    strokeWeight(5);
    stroke(cor);
    line(x, y, x, y - (h * entradas));
    line(x, y, x, y + (h * saidas));
    pop();
    cor = color(255, 100);
  }
  
  void mostraImg() {
    for(int i = 0; i < imgs.size(); i++) {
      image(imgs.get(i), 0, 0, width, height);
    }
  }
}
