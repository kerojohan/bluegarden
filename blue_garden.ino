#define voltageFlipPin1 6
#define voltageFlipPin2 7
#define sensorPin 1
int flipTimer = 1000;

char serialin;
int relay=13;


void setup() {
  // El baud rate debe ser el mismo que en el monitor serial y 
  // que el mobulo bluetooth. 
  // para cambiar el baud rate debe entrar en modo AT
  Serial.begin(9600);
    //pin relay as OUTPUT
  pinMode(relay, OUTPUT); 
  //Relay 
  digitalWrite(relay,LOW);
    //sensor
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(1, INPUT);
      digitalWrite(6, LOW);
    digitalWrite(7, LOW);
}

 void setSensorPolarity(boolean flip){
  if(flip){
    digitalWrite(6, HIGH);
    digitalWrite(7, LOW);
  }else{
    digitalWrite(6, LOW);
    digitalWrite(7, HIGH);
  }
}

int reportLevels(int val1,int val2){
    int avg = (val1 + val2) / 2;
    return(avg);
}

void loop() {}

// Se activa cuando se detecta escritura en el puerto serial
void serialEvent() {  
  while (Serial.available()) {
    serialin = Serial.read();        
    // Si detecta el caracter '0' entonces apaga el led
if (serialin == 'c' || serialin =='C'){ // Two Pipeines(||) to make a boolean OR Comparission
      Serial.println("rebut");
      digitalWrite(relay,HIGH);
      delay(60000);
      digitalWrite(relay,LOW); 
      }
      
       if (serialin == 's' || serialin =='S'){ // Two Pipeines(||) to make a boolean OR Comparission
  //
  setSensorPolarity(true);
  delay(1000);
  int val1 = analogRead(1);
  delay(1000);  
  setSensorPolarity(false);
  delay(1000);
  // invert the reading
  int val2 = 1023 - analogRead(1);
  //
  Serial.println(reportLevels(val1,val2));
    digitalWrite(6, LOW);
    digitalWrite(7, LOW);
  }
  }
}
