int prPin = 0;
int ledPin = 10;

void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  Serial.println(analogRead(prPin));
  while (Serial.available() > 0) {
    char ser = Serial.read();
    
    if (ser == '1') {
      digitalWrite(ledPin, HIGH); 
    }
    if (ser == '0') {
      digitalWrite(ledPin, LOW); 
    }
  }
  delay(100);
}
