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
#import "VideoCaptureViewController.h"

@interface TrackManager : NSObject<VideoCaptureDelegate> {
    NSArray *currentTrackList;
    AudioManager *audioManager;
}

@property (nonatomic, retain) NSArray *currentTrackList;
@property (nonatomic, retain) AudioManager *audioManager;

+ (TrackManager *)sharedManager;

- (Track *)trackFromCaptureSummary:(CaptureSummary *)summary;

- (NSTimeInterval)startOfFirstTrack;

//precache the track before playing it to avoid weird pauses
- (void)precacheTrack:(Track *)t;

- (void)playTrack:(Track *)t;

//this just pauses the track but keeps it in the track list.
- (void)pauseTrack:(Track *)t;

//this pauses the track BUT ALSO REMOVES IT from the track list.
- (void)stopTrack:(Track *)t;

//this pauses the track if it's playing and plays it if it's not.
- (void)toggleTrack:(Track *)t;


//debug
- (void)playAllTracks;
- (void)playTracksWithDelay;

@end
