//
//  VisualizationView.m
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "VisualizationView.h"

@implementation VisualizationView

@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [color set];
    UIRectFill(rect);
    self.alpha = 0.3f;
    self.layer.borderWidth = 1.0f;
}

- (void)blink {
    [UIView animateWithDuration:0.08
                     animations:^{self.alpha = 1.0;}
                     completion:^(BOOL finished){    
                         [UIView animateWithDuration:0.08 animations:^{self.alpha = 0.3;}
                          ];
                     }];
    
}

- (void)blinkAtDurations:(NSArray *)array {
    if([array count] == 0) {
        return;
    }
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
    float val = [[array objectAtIndex:0] floatValue] * 0.1875;
    [self performSelector:@selector(blink) withObject:nil afterDelay:val];
    [newArray removeObjectAtIndex:0];
    [self performSelector:@selector(blinkAtDurations:) withObject:[NSArray arrayWithArray:newArray] afterDelay:val];
}

@end
