//
//  CaptureSummary.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

typedef enum {
  ColorIntensityHigh,
  ColorIntensityMid,
  ColorIntensityLow,
} ColorIntensityType;

@interface CaptureSummary : NSObject {
  int stillCounter;
}

@property(strong, nonatomic) UIColor *averageColor;

@property(assign, nonatomic) TrackType channel;
@property(readonly, nonatomic) ColorIntensityType redIntensity, blueIntensity, greenIntensity;
@property(readonly) BOOL changed;

- (id) initWithSummaries:(int)maxPerPixel red:(int)redCount blue:(int)blueCount green:(int)greenCount;
- (void)updateSummaries:(int)numPixels red:(int)redCount blue:(int)blueCount green:(int)greenCount;

@end
