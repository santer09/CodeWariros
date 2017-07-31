# CodeWariros - Erick Santos
working with D-Bug12 micro controller
The objective for this lab is to become familiar with the PWM subsystem of the HCS12 MCU and a PushButton (PB) interrupting interface. Additionally, a sub-objective is to also become more familiar with CodeWarrior (CW) IDE and the D-Bug12 interface and commands.
In this lab, you will use the PWM to generate tones on the piezoelectric buzzer (“speaker”) on
the Dragon12 EVB (see Figure 2). You are to fill in the designated areas of the template (“lab_9_template.asm”). You will generate a constant tone (no delay). However, you will use the PBs to change the tone. The initial frequency must be 697Hz (see Lecture 15 for more information). The PBs will work as follows:
• PB1 – 697Hz
• PB2 – 770Hz
• PB3 – 852Hz
• PB4 – 941Hz
• PB12 – 1209Hz
• PB23 – 1336Hz
• PB34 – 1477Hz
• PB14 – 1633Hz
PBs with two numbers indicates PB combinations. For example, PB12 means that pushbuttons 1 and 2 are pressed simultaneously. You must use a PB interrupting interface. Any other combination of PBs should be ignored and shouldn’t change the tone.
Figure
