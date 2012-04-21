//
//  CaptureSummary.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  ColorIntensityHigh,
  ColorIntensityMid,
  ColorIntensityLow,
} ColorIntensityType;

@interface CaptureSummary : NSObject

@property(readonly, assign) ColorIntensityType redIntensity, blueIntensity, greenIntensity;

- (void)updateSummaries:(int)numPixels red:(int)redCount blue:(int)blueCount green:(int)greenCount;

@end
