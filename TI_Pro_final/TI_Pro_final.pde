import processing.serial.*;

import processing.video.*;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

void settings() {
  int sizeW = (displayHeight - 50) * 640 / 480;
  size(sizeW, displayHeight - 50);
}

void setup() {
  background(0);
  colorMode(HSB, 360, 100, 100);
 
 tresholdStateOriRep = tresholdStateOriRep * width * height;
 tresholdNoFrame = tresholdNoFrame * width * height;
  
  String[] cameras;
  
  do {
    cameras= Capture.list();
  }
  while(cameras.length==0);
  
  
  cap= new Capture(this, width, height, cameras[0]);
  cap.start();
  cap.loadPixels();
  
  stateOri = createImage(cap.width,cap.height,ARGB);
  back = createImage(cap.width,cap.height,ARGB);
  silhueta = createImage(cap.width,cap.height,ARGB);
  stateOri.loadPixels();
  
  String portName = Serial.list()[0];
 portaSerial = new Serial(this, portName, 9600);
 portaSerial.clear();
 
 aCaptar = false;
 
 pxAlt = new int[cap.pixels.length];
    
    for(int i = 0; i < pxAlt.length; i++) {
      pxAlt[i] = 0; 
    }
    
  //PASTA
  if (!folder.exists()) {
    if (folder.mkdirs()) {
      println("Pasta criada com sucesso: " + folderPath);
    } else {
      println("Falha ao criar a pasta: " + folderPath);
    }
  } else {
    println("A pasta já existe: " + folderPath);
  }
  espacamento = (width - 10.) / 96.;
}

void draw() { 
  
  if (portaSerial.available() > 0) { 
    dadosRecebidos = portaSerial.readStringUntil('\n'); 
    if (dadosRecebidos != null) { 
      dadosRecebidos = dadosRecebidos.trim();
      
      if(dadosRecebidos.equals("BM")) {
        if(modoDoProg == 0) {
      modoDoProg = 1;
      infoVisSet();
    }
    else if (modoDoProg == 1) {
      modoDoProg = 0;
    }
      }
      
    }
  }
  
  if(modoDoProg == 0) {
   captaDraw();
  }
  else if (modoDoProg == 1) {
    infoVisDraw();
  }
  
}

//mouse Pressed(simulação)
void keyPressed() {
  if(key =='c') {
    atuImgOri();
    background(0);
  }
  if(key == 'e') {
    atuaBackground(silhueta, h, 100, 80, 255);
  }
  
  if(key == 'd') {
    atuaBackground(silhueta, h, 100, 20, 255);
  }
  
  if(key == 'm') {
    if(modoDoProg == 0) {
      modoDoProg = 1;
      infoVisSet();
    }
    else if (modoDoProg == 1) {
      modoDoProg = 0;
    }
  }
  
  if (key == 'j') {
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
  if (key == 'k') {
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
