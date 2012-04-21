//
//  BSPixel.c
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#include <stdio.h>

unsigned int BSPixelGetRed(unsigned int p) {
  return ((p >> 16) & 0xFF);
}

unsigned int BSPixelGetGreen(unsigned int p) {
  return ((p >> 8) & 0xFF);
}

unsigned int BSPixelGetBlue(unsigned int p) {
  return (p & 0xFF);
}

unsigned int BSPixelGetAlpha(unsigned int p) {
  return ((p >> 24) & 0xFF);
}
