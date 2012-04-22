//
//  BSProgressView.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface BSProgressView : UIView {
 
  NSArray *icons;
  int iconCount;
  NSTimer *timer;
  
  CALayer *firstIcon;
}

@property(assign, nonatomic) TrackType type;
@property(assign, nonatomic) BOOL progressing;

- (void)reset;
- (void)heartBeat;

@end
