//
//  AudioManager.h
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVAudioPlayer.h"

@interface AudioManager : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, retain) NSMutableArray *audioPlayerArray;
//@property (nonatomic, retain) AVAudioPlayer *player;

- (void)playTrack:(NSString *)str;
- (void)stopTrack:(NSString *)str;
- (void)toggleTrack:(NSString *)str;

@end
