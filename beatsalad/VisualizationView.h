//
//  VisualizationView.h
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"

@interface VisualizationView : UIView {
    UIColor *color;
}

@property (nonatomic, assign) bool isBlinking;

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) NSArray *blinkTimingArray;

- (void)blinkAtDurations:(NSArray *)array;

@end
