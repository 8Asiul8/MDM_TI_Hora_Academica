#include <NewPing.h>

#define trigger_pinD 11
#define echo_pinD 12
#define trigger_pinE 9
#define echo_pinE 8 

#define led_pin 13

#define light_sensor A0

#define max_distance 50

#define botaoE 2
#define botaoM 3
#define botaoD 4

int buttonEState; 
int lastButtonEState = HIGH;
int buttonMState; 
int lastButtonMState = HIGH;
int buttonDState; 
int lastButtonDState = HIGH;

long lastDebounceTimeE = 0;
long lastDebounceTimeM = 0;
long lastDebounceTimeD = 0;
long debounceDelay = 50;

long passagemD1 = -1;
long passagemD2 = -1;
long passagemE1 = -1;
long passagemE2 = -1;

bool espera = false;
long esperaInicio = -1;

NewPing sonarE(trigger_pinE, echo_pinE, max_distance);
NewPing sonarD(trigger_pinD, echo_pinD, max_distance);

float distanceE;
float distanceD;

int light_value = 0;
int light_value_ant = 0;
const int light_trash_hold = 1000;

void setup() {
  Serial.begin(9600);

  pinMode(led_pin, OUTPUT);

  pinMode(botaoE, INPUT);
  pinMode(botaoM, INPUT);
  pinMode(botaoD, INPUT);
}

void loop() {
  if (espera == false) {
    distanceE = sonarE.ping_cm();
    distanceD = sonarD.ping_cm();

    if (distanceE >= 100 || distanceE <= 2) {
      //Serial.println("Esquerda Out of range");
    }

    if (distanceE < 100 && distanceE > 2) {
      if (passagemE1 < 0) {
        if (passagemD1 < 0) {
          passagemE1 = millis();
          //enviar um sinal ao processing a avisar que movimento foi detetado
          Serial.println("detecao");
          digitalWrite(led_pin, HIGH);
        } else {
          if (passagemE2 < 0) {
            passagemE2 = millis();
            Serial.println("DE");
            digitalWrite(led_pin, LOW);
            espera = true;
            esperaInicio = millis();
          }
        }
      }
    }

    if (distanceD >= 100 || distanceD <= 2) {
      //Serial.println("Direita Out of range");
    }

    if (distanceD < 100 && distanceD > 2) {
      if (passagemD1 < 0) {
        if (passagemE1 < 0) {
          passagemD1 = millis();
          //enviar um sinal ao processing a avisar que movimento foi detetado
          Serial.println("detecao");
          digitalWrite(led_pin, HIGH);
        } else {
          if (passagemD2 < 0) {
            passagemD2 = millis();
            Serial.println("ED");
            digitalWrite(led_pin, LOW);
            espera = true;
            esperaInicio = millis();
          }
        }
      }
    }

    if (passagemD1 > 0 && millis() - passagemD1 > 5000) {
      passagemD1 = -1;
      passagemD2 = -1;
      passagemE1 = -1;
      passagemE2 = -1;
      //Enviar sinal ao processing para avisar que já não se espera uma segunda movimentação
      Serial.println("cancel");
      digitalWrite(led_pin, LOW);
    }
    if (passagemE1 > 0 && millis() - passagemE1 > 5000) {
      passagemD1 = -1;
      passagemD2 = -1;
      passagemE1 = -1;
      passagemE2 = -1;
      //Enviar sinal ao processing para avisar que já não se espera uma segunda movimentação
      Serial.println("cancel");
      digitalWrite(led_pin, LOW);
    }

    delay(500);
  } else {
    if (millis() - esperaInicio >= 5000) {
      espera = false;
    }
  }

  light_value = analogRead(light_sensor);

  if (light_value > light_trash_hold && light_value_ant <= light_trash_hold) {
    Serial.println("Desliga");
  } else if (light_value < light_trash_hold && light_value_ant >= light_trash_hold) {
    Serial.println("Liga");
  }

  light_value_ant = analogRead(light_sensor);

  int readingE = digitalRead(botaoE);
  
  if (readingE != lastButtonEState) {
    lastDebounceTimeE = millis(); 
  }

  if ((millis() - lastDebounceTimeE) > debounceDelay) {
    if (readingE != buttonEState) {
      buttonEState = readingE;

      if (buttonEState == HIGH) {
        Serial.println("BE");
      }
    }
  }

  lastButtonEState = readingE;

  int readingM = digitalRead(botaoM);
  
  if (readingM != lastButtonMState) {
    lastDebounceTimeM = millis(); 
  }

  if ((millis() - lastDebounceTimeM) > debounceDelay) {
    if (readingM != buttonMState) {
      buttonMState = readingM;

      if (buttonMState == HIGH) {
        Serial.println("BM");
      }
    }
  }

  lastButtonMState = readingM;

  int readingD = digitalRead(botaoD);
  
  if (readingD != lastButtonDState) {
    lastDebounceTimeD = millis();
  }

  if ((millis() - lastDebounceTimeD) > debounceDelay) {
    if (readingD != buttonDState) {
      buttonDState = readingD;

      if (buttonDState == HIGH) {
        Serial.println("BD");
      }
    }
  }

  lastButtonDState = readingD;
}