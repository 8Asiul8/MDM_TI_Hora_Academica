//Captação e Amostragem geral
void captaDraw() {
    h = map(hour()*60 + minute(), 0, 1440, 0, 360);
    if(cap.available()) {
    cap.read();
    cap.updatePixels();
     background(0);
     image(back, 0, 0);
    desSilhueta();
    }
    
    DecideAtualizarBack(silhueta);
    captaFrame();
    
    if (portaSerial.available() > 0) { 
    dadosRecebidos = portaSerial.readStringUntil('\n'); 
    if (dadosRecebidos != null) { 
      dadosRecebidos = dadosRecebidos.trim();
      if (dadosRecebidos.equals("DE")) {
        if(captaOuNao(silhueta) && framesIns.size() != 0) {
        int nFrame = int(random(framesIns.size() - 1));
        atuaBackground(framesIns.get(nFrame), h, 100, 80, 255);
        //guardar img separada em ficheiro...  
        //framesIns.get(nFrame).save("passagem " + hour()*3600 + minute()*60 + second() + ".png");
        geraSilCol(framesIns.get(nFrame), h, 100, 80, 255, "S");
        }
        aCaptar = false;
        println("DE");
      }
      else if(dadosRecebidos.equals("ED")) {
        if(captaOuNao(silhueta) && framesIns.size() != 0) {
        int nFrame = int(random(framesIns.size() - 1));
        atuaBackground(framesIns.get(nFrame), h, 100, 20, 255);
        geraSilCol(framesIns.get(nFrame), h, 100, 20, 255, "E");
        }
        aCaptar = false;
        println("ED");
      }
      
      else if(dadosRecebidos.equals("detecao")) {
        aCaptar = true;
        println("det");
      }
      
      else if(dadosRecebidos.equals("cancel")) {
        aCaptar = false;
        println("can");
      }
      
      else if(dadosRecebidos.equals("Desliga")) {
        back = createImage(cap.width,cap.height,ARGB);
        back.updatePixels();
        back.save("background.png");
        ligado = false;
      }
      
      else if(dadosRecebidos.equals("Liga")) {
        ligado = true;
      }
    }
    }
}

//Funções para a Visualização de Informação
void infoVisDraw() {
    String horario = "";
    background(0);
    if(selec != -1) {
      blocosTempo[selec].mostraImg();
      blocosTempo[selec].cor = color(255);
      horario = nf(blocosTempo[selec].hor1, 2) + ":" + nf(blocosTempo[selec].min1, 2) + " - " + nf(blocosTempo[selec].hor2, 2) + ":" + nf(blocosTempo[selec].min2, 2);
    textSize(52);
    fill(255);
    text(horario, 20, 40);
    popStyle();
    }
    pushStyle();
    fill(0, 150);
    rect(0, height - 200, width, 200);
    pushStyle();
    textSize(16);
    fill(255);
    pushMatrix();
    translate(20, height - 60);
    rotate(PI/2);
    text("saídas", 0, 0);
    popMatrix();
    pushMatrix();
    translate(20, height - 140);
    rotate(- PI/2);
    text("entradas", 0, 0);
    popMatrix();
    popStyle();
    for(int i = 0; i < blocosTempo.length; i++) {
      blocosTempo[i].desenha();
    }
    
    if (portaSerial.available() > 0) { 
    dadosRecebidos = portaSerial.readStringUntil('\n'); 
    if (dadosRecebidos != null) { 
      dadosRecebidos = dadosRecebidos.trim();
      
      if(dadosRecebidos.equals("BE")) {
        println("BE");
        if(modoDoProg == 1) {
    if ( selec == -1) {
      for (int i = 0; i < blocosTempo.length; i++) {
        if (blocosTempo[i].saidas != 0 || blocosTempo[i].entradas != 0) {
          selec = i;
          break;
        }
      }
    }
    else {
      for (int i = selec - 1; i >= 0; i--) {
        if (blocosTempo[i].saidas != 0 || blocosTempo[i].entradas != 0) {
          selec = i;
          break;
        }
      }
    }
    }
      }
      
      if(dadosRecebidos.equals("BD")) {
        println("BD");
        if(modoDoProg == 1) {
    if ( selec == -1) {
      for (int i = 0; i < blocosTempo.length; i++) {
        if (blocosTempo[i].saidas != 0 || blocosTempo[i].entradas != 0) {
          selec = i;
        }
      }
    }
    else {
      for (int i = selec + 1; i < blocosTempo.length; i++) {
        if (blocosTempo[i].saidas != 0 || blocosTempo[i].entradas != 0) {
          selec = i;
          break;
        }
      }
    }
    }
      }
    }
  }
}

void infoVisSet() {
  if (folder.isDirectory()) {
    files = folder.listFiles();

    if (files != null) {
      for (int i = 0; i < files.length; i++) {
        if (files[i].isFile()) {
          espacamento = (width - 20) / 95.;
    for (int j = 0; j < blocosTempo.length; j++) {
    blocosTempo[j] = new dados(files, j * 900, (j + 1) * 900, 10 + (j * espacamento), height - 100, 1);
  }    
        }
      }
  }
}
