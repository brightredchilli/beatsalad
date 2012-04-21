//
//  CaptureSummary.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "CaptureSummary.h"

ColorIntensityType ColorIntensityFromIntensity(double count, double maxValue) {
 
  double third = maxValue/3;
  
  if (count < third) {
    return ColorIntensityLow;
  } else if(count < third*2) {
    return ColorIntensityMid;
  } else {
    return ColorIntensityHigh;
  }

}

@implementation CaptureSummary

@synthesize redIntensity, blueIntensity, greenIntensity;

- (void)updateSummaries:(int)numPixels red:(int)redCount blue:(int)blueCount green:(int)greenCount {
  
  double maxPerPixel = 255 * numPixels;
  redIntensity = ColorIntensityFromIntensity(redCount, maxPerPixel);
  greenIntensity = ColorIntensityFromIntensity(greenCount, maxPerPixel);
  blueIntensity = ColorIntensityFromIntensity(blueCount, maxPerPixel);
  
}

@end
