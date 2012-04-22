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

NSString *ColorIntensityToString(ColorIntensityType type) {
  switch (type) {
    case ColorIntensityLow:
      return @"LOW";
      break;
    case ColorIntensityMid:
      return @"MID";
      break;
    case ColorIntensityHigh:
      return @"HIGH";
      break;
    default:
      break;
  } 
}

@implementation CaptureSummary

@synthesize redIntensity, blueIntensity, greenIntensity;
@synthesize changed;

- (id) initWithSummaries:(int)maxPerPixel red:(int)redCount blue:(int)blueCount green:(int)greenCount {
  self = [super init];
  if (self) {
    redIntensity = ColorIntensityFromIntensity(redCount, maxPerPixel);
    greenIntensity = ColorIntensityFromIntensity(greenCount, maxPerPixel);
    blueIntensity = ColorIntensityFromIntensity(blueCount, maxPerPixel);
  }
  return self;
}

- (BOOL)isEqual:(id)object {
  if (![object isKindOfClass:[CaptureSummary class]]) return NO;
  if (self == object) return YES;
  
  CaptureSummary *otherObject = object;
  if (redIntensity == otherObject.redIntensity && blueIntensity == otherObject.blueIntensity && greenIntensity == otherObject.greenIntensity) {
    return YES;
  }
  return NO;
}
- (void)updateSummaries:(int)numPixels red:(int)redCount blue:(int)blueCount green:(int)greenCount {
  
  double maxPerPixel = 255 * numPixels;
  
  if (redIntensity == ColorIntensityFromIntensity(redCount, maxPerPixel) && 
      greenIntensity == ColorIntensityFromIntensity(greenCount, maxPerPixel) &&
      blueIntensity == ColorIntensityFromIntensity(blueCount, maxPerPixel)) {
    stillCounter++;
  } else {
    stillCounter = 0;
  }
  
  if (stillCounter > 20) {
    changed = NO;
  } else {
    changed = YES;
  }
  
  redIntensity = ColorIntensityFromIntensity(redCount, maxPerPixel);
  greenIntensity = ColorIntensityFromIntensity(greenCount, maxPerPixel);
  blueIntensity = ColorIntensityFromIntensity(blueCount, maxPerPixel);
  
}

- (NSString *)description {
  return [NSString stringWithFormat:@"red:%@     green:%@       blue:%@", ColorIntensityToString(redIntensity), ColorIntensityToString(greenIntensity), ColorIntensityToString(blueIntensity)];
}

@end
