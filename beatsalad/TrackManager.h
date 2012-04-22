//
//  TrackManager.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import "AudioManager.h"

@interface TrackManager : NSObject {
    NSArray *currentTrackList;
    AudioManager *audioManager;
}

@property (nonatomic, retain) NSArray *currentTrackList;
@property (nonatomic, retain) AudioManager *audioManager;

+ (TrackManager *)sharedManager;

//debug
- (void)playAllTracks;

@end
