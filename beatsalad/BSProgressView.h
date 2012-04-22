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
 
  CALayer *firstIcon;
  NSArray *icons;
  int iconCount;
  
}

@property(assign, nonatomic) int maxCount;
@property(assign, nonatomic) TrackType type;

- (void)reset;
- (void)refresh;
@end
