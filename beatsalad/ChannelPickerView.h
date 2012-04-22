//
//  ChannelPickerView.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@protocol ChannelPickerDelegate;

@interface ChannelPickerView : UIView {
 
  UIButton *melodyButton;
  UIButton *bassButton;
  UIButton *percussionButton;
  UIButton *cancelButton;
  
  CGPoint anchorPoint;
  
  BOOL currentlyOpen;
  
  TrackType currentType;
  
}

@property(weak, nonatomic) id <ChannelPickerDelegate>delegate;


@end

@protocol ChannelPickerDelegate<NSObject>

- (void)channelPicker:(ChannelPickerView *)picker channelSelected:(TrackType)type;

@end
