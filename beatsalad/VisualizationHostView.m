//
//  VisualizationHostView.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "VisualizationHostView.h"


NSString *const kVisualizationHostViewOpen = @"open host view";
NSString *const kVisualizationHostViewClose = @"close host view";
@implementation VisualizationHostView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:OpenVizFrame];
      imageView.image = [UIImage imageNamed:@"current_tracks.png"];
      imageView.contentMode = UIViewContentModeScaleAspectFit;
      [self addSubview:imageView];
      

      
      UIView *backgroundView = [[UIView alloc] initWithFrame:VisualizationVCFrame];
      backgroundView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
      [self addSubview:backgroundView];
      
      imageView = [[UIImageView alloc] initWithFrame:CloseVizFrame];
      imageView.image = [UIImage imageNamed:@"side-bar.png"];
      imageView.contentMode = UIViewContentModeScaleAspectFit;
      [self addSubview:imageView];
    }
    return self;
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

  UITouch *touch = [touches anyObject];

  if ([touch tapCount] == 1) {
    CGPoint point = [touch locationInView:self];
    if (!isOpen) {
      if (CGRectContainsPoint(OpenVizFrame, point)) {
        [UIView animateWithDuration:0.2 
                              delay:0.0 
                            options:UIViewAnimationCurveEaseInOut 
                         animations:^{
                            self.frame = CGRectOffset(self.frame, -320, 0);
                           [self.superview bringSubviewToFront:self];
                         } completion:^(BOOL finished) {
                           [[NSNotificationCenter defaultCenter] postNotificationName:kVisualizationHostViewOpen object:self];
                         }];
        
        isOpen = YES;
      }
    } else {
      if (CGRectContainsPoint(CloseVizFrame, point)) {

        [UIView animateWithDuration:0.2 
                              delay:0.0 
                            options:UIViewAnimationCurveEaseInOut 
                         animations:^{
                           [self.superview sendSubviewToBack:self];
                           self.frame = CGRectOffset(self.frame, 320, 0);
                         } completion:^(BOOL finished) {
                           [[NSNotificationCenter defaultCenter] postNotificationName:kVisualizationHostViewClose object:self];
                         }];
        isOpen = NO;
      }
    }

    
  }
  
}



@end
