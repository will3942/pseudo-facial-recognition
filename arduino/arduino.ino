int prPin = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.println(analogRead(prPin));
  delay(100);
}
