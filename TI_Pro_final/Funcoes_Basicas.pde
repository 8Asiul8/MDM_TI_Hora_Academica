//Funções
void atuImgOri() {
  for(int i=0; i<cap.width; i++) {
      for( int j=0; j<cap.height; j++) {
        int loc= i+j*cap.width;
        stateOri.pixels[loc] = cap.pixels[loc];
      }
    }
    stateOri.updatePixels();
}

void desSilhueta() {
  for (int i = 0; i < cap.pixels.length; i++) {
        float diff = abs(red(stateOri.pixels[i]) - red(cap.pixels[i])) + abs(green(stateOri.pixels[i]) - green(cap.pixels[i])) + abs(blue(stateOri.pixels[i]) - blue(cap.pixels[i]));
        if (abs(diff) > 100) {
          silhueta.pixels[i] = color(0, 0,100 , 255);
        } else {
          silhueta.pixels[i] = color(0,0);
        }
    }
      silhueta.updatePixels();
    
    image(silhueta,0,0);
}

void atuaBackground(PImage img, float h1, float s1, float b1, float trans) {
  back.loadPixels();
  for (int i = 0; i < back.pixels.length; i++) {
    if(alpha(img.pixels[i]) != 0) {
      back.pixels[i] = color(h1, s1, b1, trans);
    }
    }
    back.updatePixels();
    back.save("background.png");
}

void captaFrame() {
  if(aCaptar == true) {
    framesIns.add(silhueta);
    aCaptarLastStat = true;
  }
  else if(aCaptar == false && aCaptarLastStat ==true) {
    framesIns.clear();
    aCaptarLastStat = false;
  }
}

void geraSilCol(PImage img, float h1, float s1, float b1, float trans, String nom) {
  silCol = createImage(cap.width,cap.height,ARGB);
  for (int i = 0; i < silCol.pixels.length; i++) {
    if(alpha(img.pixels[i]) != 0) {
      silCol.pixels[i] = color(h1, s1, b1, trans);
    }
    }
    silCol.updatePixels();
    silCol.save(folderPath + "/" + nom + "-" +((hour() * 60 + minute()) * 60 + second()) + ".png");
}


int[] pxAlt;
void DecideAtualizarBack(PImage img) {
  int nPCAlt = 0;
  for(int i = 0; i < pxAlt.length; i++) {
    if(img.pixels[i] == color(0, 0,100 , 255)) {
      pxAlt[i] +=1;
      if(pxAlt[i] >= 600) {
        nPCAlt += 1;
      }
    }
    else {
      pxAlt[i] = 0;
    }
  }
  if(nPCAlt >=  pxAlt.length*5/100) {
    atuImgOri();
  }
}

boolean captaOuNao(PImage img) {
  int nPxAlt1 = 0;
  for(int i = 0; i < img.pixels.length; i++) {
    if (img.pixels[i] == color(0, 0,100 , 255)) {
      nPxAlt1 += 1;
    }
  }
  if (nPxAlt1 >= img.pixels.length * 1. / 2.) {
    return false;
  }
  else return true;
}
