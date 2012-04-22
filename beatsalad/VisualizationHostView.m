//
//  VisualizationHostView.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "VisualizationHostView.h"



@implementation VisualizationHostView

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
  [[UIColor colorWithRed:0 green:1 blue:0 alpha:1.0] setFill];
  UIRectFill(OpenVizFrame);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

  UITouch *touch = [touches anyObject];

  if ([touch tapCount] == 1) {
    if (!isOpen) {
      self.frame = CGRectOffset(self.frame, -320, 0);
    } else {
      self.frame = CGRectOffset(self.frame, 320, 0);
    }
    isOpen = !isOpen;
  }
  
}



@end
