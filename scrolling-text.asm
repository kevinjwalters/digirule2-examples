// Two line text scroller v1.4

// DO NOT FORGET TO ADD 1 to the shiftcmd addresses
// DO NOT FORGET TO ADD 1 to the shiftcmd addresses

// Example on https://www.youtube.com/watch?v=51BmsW9uXG8

// MIT License

// Copyright (c) 2018 Kevin J. Walters

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


%define delaycounter 237
%define carrystore 238
%define dummyaddr 238
%define bytecounter 239
// Adjust row1datalast and row2datalast based on datalen
%define datalen 12
%define row1datafirst 128
%define row1datalast 139
%define row2datafirst 144
%define row2datalast 155
%define extradelay 100

%define statusRegister      252
%define buttonRegister      253
%define addressLEDRegister  254
%define dataLEDRegister     255

// Setup (this code runs once)
// msb set means ms, 32 is 32us, 0 or 128 is no delay
speed 0
copylr 4 statusRegister // 5 to show addressLEDRegister

// main loop
:mainloop
// display what's in the first data byte for each row
copyra row1datafirst
copyar addressLEDRegister
copyra row2datafirst
copyar dataLEDRegister

// row1 -> address register display
// set carry flag based on msb of first data byte
// approach is inefficient but symmetric to prevent
// data affecting timing
bcrsc 7 row1datafirst  // next instruction must be 2 bytes total
copyla 255
bcrss 7 row1datafirst
copyla 0
copyar carrystore
shiftrl carrystore  // carry is now bit 7 of row1datafirst

// now rotate all the data to shift one pixel left
copylr datalen bytecounter
copyla row1datalast
copyar row1shiftcmdADDONE // VALUE MUST BE CHANGED, ADD 1 TO IT
:row1rotateloop
:row1shiftcmdADDONE
shiftrl dummyaddr // this address gets replaced - SMC!
decr row1shiftcmdADDONE // VALUE MUST BE CHANGED, ADD 1 TO IT
decrjz bytecounter
jump row1rotateloop  // this will be skipped when bytecounter is zero

// row2 -> address register display
// set carry flag based on msb of first data byte
// approach is inefficient but symmetric to prevent
// data affecting timing
bcrsc 7 row2datafirst  // next instruction must be 2 bytes total
copyla 255
bcrss 7 row2datafirst
copyla 0
copyar carrystore
shiftrl carrystore  // carry is now bit 7 of row2datafirst

// now rotate all the data to shift one pixel left
copylr datalen bytecounter
copyla row2datalast
copyar row2shiftcmdADDONE // VALUE MUST BE CHANGED, ADD 1 TO IT
:row2rotateloop
:row2shiftcmdADDONE
shiftrl dummyaddr // this address gets replaced - SMC!
decr row2shiftcmdADDONE // VALUE MUST BE CHANGED, ADD 1 TO IT
decrjz bytecounter
jump row2rotateloop  // this will be skipped when bytecounter is zero

// fine tuning for loop iteration rate
copylr extradelay delaycounter
:delay
nop
decrjz delaycounter
jump delay

jump mainloop
