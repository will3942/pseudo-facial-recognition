# MP ID Cards recognition using photoresistors

## About

A hardware hack using an Arduino Pro Mini, LED, two resistors and a photoresistor/LDR
.  


The images are pulled from the web of the Members of Parliament, these are then converted to monochrome and saved before being printed onto ID cards ready for recognition.

## Usage

You need to adjust the Arduino serial port in run.rb to the one on your system.  
`ruby run.rb`  
Follow the instructions then displayed.  

## How does it work?

A blank piece of white paper is used to get the ambient light, the value for white light. When an MP's photo is placed on the photoresistor the difference in light level is calculated which is equivalent to the amount of black color in the MP's image.

## Demo video?

[Youtube](http://www.youtube.com/watch?v=33tpPE9dmJs&feature=youtu.be)

## Contact

This project was constructed in 24 hours at #NHTG14 (rewired state). The code will not be perfect.  

Twitter: @Will3942  
Email: will@will3942.com  
