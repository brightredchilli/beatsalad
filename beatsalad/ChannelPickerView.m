//
//  ChannelPickerView.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "ChannelPickerView.h"

@implementation ChannelPickerView

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
    melodyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [melodyButton setImage:[UIImage imageNamed:@"note_icon.jpeg"] forState:UIControlStateNormal];

    
    bassButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [bassButton setImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
    
    precussionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [precussionButton setImage:[UIImage imageNamed:@"drums_icon.jpeg"] forState:UIControlStateNormal];

    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [cancelButton setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
    
    [self addSubview:melodyButton];
    [self addSubview:bassButton];
    [self addSubview:precussionButton];
    [self addSubview:cancelButton];
  }
  return self;
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
