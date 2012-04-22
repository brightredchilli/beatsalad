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
      self.backgroundColor = [UIColor colorWithRed:0.3 green:0.8 blue:0.2 alpha:0.5];
        
      
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
  [[UIColor colorWithRed:0 green:1 blue:0 alpha:1.0] setFill];
  UIRectFill(OpenVizFrame);
  
  [[UIColor groupTableViewBackgroundColor] setFill];
  UIRectFill(VisualizationVCFrame);
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
