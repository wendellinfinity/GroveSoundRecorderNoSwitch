
// include our sound recorder library
#include <GroveSoundRecorder.h>

// initialize a recorder
#define SEL1 2 // use digital port 2 on the Stem Base Shield
#define MODEPIN 13
GroveSoundRecorder recorder(SEL1);

void setup() {
  Serial.begin(9600);
  // initialize the sound recorder
  recorder.initialize();
  pinMode(MODEPIN,OUTPUT);
  // default to playback mode
  digitalWrite(MODEPIN,HIGH);
}

char index;
char control;
char state;
TRACKS selectedTrack=ZERO;
void loop() {
  delay(50);
  //get the serial command
  // this is based from Seeedstudio's example code:
  // #rb = begin recording track #
  // #rs/rs = stop all recording
  // #p = play track # 
  // #m = mode (r is record, p is play)
  if (Serial.available()>0)
  {   
    index = Serial.read();
    control = Serial.read();
    state = Serial.read();
  }
  Serial.flush();     
  // determine the track to play
  switch(index)
  {
  case '2':
    selectedTrack=TRACK2;
    break;
  case '3':
    selectedTrack=TRACK3;
    break;
  case '4':
    selectedTrack=TRACK4;
    break;
  default:
    selectedTrack=ZERO;
    break;
  }
  // get action to do
  switch(control) {
  case 'r':
    // RECORD: flip first the switch on the sound recorder board to REC
    // determine if start recording or stop recording
    if(state=='b') {
      // start recording
      Serial.print("start recording track #");
      Serial.println(selectedTrack+1,DEC);
      recorder.beginRecord(selectedTrack);
    } 
    else {
      // stop recording
      Serial.println("stopped all recording");
      recorder.stopRecord();
    }
    index=0; 
    control=0; 
    state=0; // reset command
    break;
  case 'p':
    // PLAYBACK: flip first the switch on the sound recorder board to PLAY
    // start playing track
    Serial.print("playing track #");
    Serial.println(selectedTrack+1,DEC);
    recorder.beginPlayback(selectedTrack);
    index=0; 
    control=0; 
    state=0;
    break;
  case 'm':
    // SET MODE:
    if(index=='r') {
      Serial.println("record mode");
      digitalWrite(MODEPIN,LOW);
    } 
    else {
      Serial.println("playback mode");
      digitalWrite(MODEPIN,HIGH);
    }
    index=0;
    control=0;
    state=0;
    break;
  default:
    // do nothing
    break;
  }
}








