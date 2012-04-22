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
- (void)cancel:(id)sender;
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
    
    melodyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [melodyButton setImage:[UIImage imageNamed:@"melody.png"] forState:UIControlStateNormal];
    [melodyButton addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
    [melodyButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    bassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [bassButton setImage:[UIImage imageNamed:@"bass.png"] forState:UIControlStateNormal];
    [bassButton addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
    [bassButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    percussionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [percussionButton setImage:[UIImage imageNamed:@"percussion.png"] forState:UIControlStateNormal];
    [percussionButton addTarget:self action:@selector(selectedChannel:) forControlEvents:UIControlEventTouchUpInside];
    [percussionButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];

    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [cancelButton setImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
    [cancelButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    melodyButton.center = bassButton.center = percussionButton.center = cancelButton.center = anchorPoint;
    
    melodyLabel = [ChannelPickerView labelWithText:@"melody"];
    melodyLabel.frame = CGRectMake(10,10,70,40);
    
    bassLabel = [ChannelPickerView labelWithText:@"bass"];
    bassLabel.frame = CGRectMake(20,60,70,40);

    percussionLabel = [ChannelPickerView labelWithText:@"percussion"];
    percussionLabel.frame = CGRectMake(40,110,100,40);
    
    [self addSubview:melodyLabel];
    [self addSubview:bassLabel];
    [self addSubview:percussionLabel];

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
                       melodyLabel.alpha = bassLabel.alpha = percussionLabel.alpha  = 0.0;
                     } else {
                       melodyButton.frame = CGRectOffset(melodyButton.frame, -80, 0);
                       bassButton.frame = CGRectOffset(bassButton.frame, -70, 50);
                       percussionButton.frame = CGRectOffset(percussionButton.frame, -30, 100);
                       melodyLabel.alpha = bassLabel.alpha = percussionLabel.alpha  = 1.0;
                     }
                   } completion:^(BOOL finished) {
                     
                   }];
  currentlyOpen = !currentlyOpen;
  
}

- (void)cancel:(id)sender {
  [UIView animateWithDuration:0.2 
                        delay:0.0 
                      options:UIViewAnimationOptionCurveEaseInOut 
                   animations:^{
                     currentlyOpen = NO;
                     melodyButton.center = 
                     bassButton.center = 
                     percussionButton.center = 
                     cancelButton.center = 
                     anchorPoint;
                     melodyLabel.alpha = bassLabel.alpha = percussionLabel.alpha  = 0.0;
                   } completion:^(BOOL finished) {
                     
                   }];


}

+ (UILabel *)labelWithText:(NSString *)text {
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
  label.alpha = 0.0;
  label.textAlignment = UITextAlignmentRight;
  label.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
  label.text = text; 
  label.backgroundColor = [UIColor clearColor];
  label.textColor = [UIColor whiteColor];
  return label;
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
