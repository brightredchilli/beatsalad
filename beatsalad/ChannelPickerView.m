//
//  ChannelPickerView.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "ChannelPickerView.h"

@interface ChannelPickerView(Private)
- (void)selectedChannel:(id)sender;
@end

@implementation ChannelPickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    
    anchorPoint = CGPointMake(CGRectGetMaxX(self.bounds) - 30, 30);
    
    melodyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [melodyButton setImage:[UIImage imageNamed:@"note_icon.jpeg"] forState:UIControlStateNormal];
    [melodyButton addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
    
    bassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [bassButton setImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
    [bassButton addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
    
    percussionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [percussionButton setImage:[UIImage imageNamed:@"drums_icon.jpeg"] forState:UIControlStateNormal];
    [percussionButton addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];

    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelButton setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
    
    melodyButton.center = bassButton.center = percussionButton.center = cancelButton.center = anchorPoint;
    

    [self addSubview:cancelButton];
    [self addSubview:melodyButton];
    [self addSubview:bassButton];
    [self addSubview:percussionButton];
    currentType = TrackTypePercussion;
    
  }
  return self;
}


- (void)selectedChannel:(id)sender {
  
  [self bringSubviewToFront:sender];
  TrackType newType;
  if (melodyButton == sender) {
    newType = TrackTypeMelody;
  } else if(bassButton == sender) {
    newType = TrackTypeBass;
  } else {
    newType = TrackTypePercussion;
  }
  
  if (newType != currentType) {
    currentType = newType;
    [delegate channelPicker:self channelSelected:currentType];
  }
  
  [UIView animateWithDuration:0.2 
                        delay:0.0 
                      options:UIViewAnimationOptionCurveEaseInOut 
                   animations:^{
                     if (currentlyOpen) {
                       melodyButton.center = 
                       bassButton.center = 
                       percussionButton.center = 
                       cancelButton.center = 
                       anchorPoint;
                     } else {
                       melodyButton.frame = CGRectOffset(melodyButton.frame, -50, 0);
                       bassButton.frame = CGRectOffset(bassButton.frame, -40, 30);
                       percussionButton.frame = CGRectOffset(percussionButton.frame, -10, 40);
                     }
                   } completion:^(BOOL finished) {
                     
                   }];
  currentlyOpen = !currentlyOpen;
  
  
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
