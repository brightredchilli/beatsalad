//
//  BSProgressView.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "BSProgressView.h"
#import <QuartzCore/QuartzCore.h>


#define MAX_ICON_COUNT 5
#define DURATION_FOR_ICONS 0.5
#define HEART_BEAT_SCALE 1.3
#define REVEAL_START_SCALE 0.7

@interface BSProgressView(Private)

- (void)refresh;
@end

@implementation BSProgressView

@synthesize type, progressing;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    // Initialization code
    NSMutableArray *array = [NSMutableArray array];
    CGFloat iconWidth = self.frame.size.width / MAX_ICON_COUNT;
    for (int i = 0; i < MAX_ICON_COUNT; i++) {
      CALayer *layer = [CALayer layer];
      layer.contentsGravity = kCAGravityResizeAspect;
      layer.frame = CGRectMake(i*iconWidth, 0, iconWidth, self.frame.size.height);
//      layer.backgroundColor = [UIColor colorWithWhite:0.1*i alpha:0.5].CGColor;
      [self.layer addSublayer:layer];
      [array addObject:layer];
      
      if (i == 0) firstIcon = layer;
    }
    icons = [[NSArray alloc] initWithArray:array];
    self.layer.masksToBounds = NO;
    self.clipsToBounds = NO;
    [self start];
  }
  return self;
}

- (void)setType:(TrackType)type {
  UIImage *image = [UIImage imageNamed:@"heart_icon.png"];
  for (CALayer *layer in icons) {
    layer.contents = (id)image.CGImage;
  }

}

- (void)start {
  timer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
  [self heartBeat];
  
}

- (void)reset {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(reset) withObject:nil waitUntilDone:YES];
    return;
  }
  iconCount = 0;
  
  CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
  [fadeOut setFromValue:[NSNumber numberWithDouble:1.0]];
  [fadeOut setToValue:[NSNumber numberWithDouble:0.0]];
  [fadeOut setDuration:2.0];

  
  CABasicAnimation *shrink = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  shrink.duration = 0.65;
  [shrink setFromValue:[NSNumber numberWithDouble:1.0]];
  [shrink setToValue:[NSNumber numberWithDouble:REVEAL_START_SCALE]];        
  shrink.delegate = self;
  shrink.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  
  for (int i = 1; i < MAX_ICON_COUNT; i++) {
    CALayer *layer = [icons objectAtIndex:i];
    layer.actions = [NSDictionary dictionaryWithObjectsAndKeys:fadeOut, @"fadeOut", nil];
    layer.opacity = 0.0;
    layer.affineTransform = CGAffineTransformScale(layer.affineTransform, REVEAL_START_SCALE, REVEAL_START_SCALE);
//    [layer addAnimation:shrink forKey:@"fadeOutShrink"];
  }
  [self heartBeat];
}

- (void)refresh {
  if (progressing) {
    iconCount++;
    if (iconCount >= MAX_ICON_COUNT) {
      NSLog(@"MAX REACHED");
      return;
    }
    
    CALayer *currentIcon = [icons objectAtIndex:iconCount];
  
    CABasicAnimation *reveal = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [reveal setFromValue:[NSNumber numberWithDouble:REVEAL_START_SCALE]];
    [reveal setToValue:[NSNumber numberWithDouble:1.0]];
    [reveal setDuration:0.1];
    [currentIcon addAnimation:reveal forKey:@"reveal"];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeIn setFromValue:[NSNumber numberWithDouble:0.0]];
    [fadeIn setToValue:[NSNumber numberWithDouble:1.0]];
    [fadeIn setDuration:0.1];
    [currentIcon addAnimation:fadeIn forKey:@"fadeIn"];
    
    currentIcon.actions = [NSDictionary dictionaryWithObject:reveal forKey:@"reveal"];
    currentIcon.opacity = 1.0;
    currentIcon.affineTransform = CGAffineTransformIdentity;
  }
}

- (void)heartBeat {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(heartBeat) withObject:nil waitUntilDone:YES];
    return;
  }
    if (iconCount == 0 && !progressing) {
      firstIcon.affineTransform = CGAffineTransformIdentity;
      CABasicAnimation *heartBeatAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
      heartBeatAnimation.duration = 0.1;
      [heartBeatAnimation setFromValue:[NSNumber numberWithDouble:1.0]];
      [heartBeatAnimation setToValue:[NSNumber numberWithDouble:HEART_BEAT_SCALE]];
      [heartBeatAnimation setFillMode:kCAFillModeForwards];
      heartBeatAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
      
      CABasicAnimation *heartShrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
      heartShrinkAnimation.duration = 0.65;
      heartShrinkAnimation.beginTime = CACurrentMediaTime() + heartBeatAnimation.duration;
      [heartShrinkAnimation setFromValue:[NSNumber numberWithDouble:HEART_BEAT_SCALE]];
      [heartShrinkAnimation setToValue:[NSNumber numberWithDouble:1.0]];        
      heartShrinkAnimation.removedOnCompletion = NO;
      heartShrinkAnimation.delegate = self;
      heartShrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
      
      [firstIcon addAnimation:heartBeatAnimation forKey:@"beat"];
      [firstIcon addAnimation:heartShrinkAnimation forKey:@"shrink"];
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (anim == [firstIcon animationForKey:@"shrink"]) {
    [self heartBeat];
  }
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
