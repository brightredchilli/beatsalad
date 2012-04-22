//
//  TrackManager.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "TrackManager.h"

static TrackManager *manager;

@implementation TrackManager

@synthesize currentTrackList, audioManager;

+ (void)initialize {
    manager = [[TrackManager alloc] init];
    Track *t = [[Track alloc] initWithColor:[UIColor redColor] type:TrackTypeBass];
    Track *t2 = [[Track alloc] initWithColor:[UIColor colorWithRed:0 green:255 blue:255 alpha:1] type:TrackTypeMelody];
    Track *t3 = [[Track alloc] initWithColor:[UIColor colorWithRed:0 green:255 blue:0 alpha:1] type:TrackTypeMelody];
    manager.currentTrackList = [NSArray arrayWithObjects:t,t2,t3,nil];
    manager.audioManager = [[AudioManager alloc] init];
}

+ (TrackManager *)sharedManager {
    return manager;
}

- (void)playTrack:(Track *)t {
    [audioManager playTrack:t.filePrefix];
}

- (void)toggleTrack:(Track *)t {
    [audioManager toggleTrack:t.filePrefix];
}

- (void)pauseTrack:(Track *)t {
    [audioManager stopTrack:t.filePrefix];
}

- (void)stopTrack:(Track *)t {
    [audioManager stopTrack:t.filePrefix];
    for(Track *track in manager.currentTrackList) {
        if([t.filePrefix isEqualToString:track.filePrefix]) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:manager.currentTrackList];
            [arr removeObject:track];
            manager.currentTrackList = arr;
            return;
        }
    }
}

//debug
- (void)playAllTracks {
    for(Track *t in manager.currentTrackList) {
        [audioManager playTrack:t.filePrefix];
    }
}

- (void)playTracksWithDelay {
    Track *t = [manager.currentTrackList objectAtIndex:0];
    Track *t2 = [manager.currentTrackList objectAtIndex:1];
    Track *t3 = [manager.currentTrackList objectAtIndex:2];
    [self playTrack:t];
    [self performSelector:@selector(playTrack:) withObject:t2 afterDelay:1.7];    
    [self performSelector:@selector(playTrack:) withObject:t3 afterDelay:1.3];
    [self performSelector:@selector(stopTrack:) withObject:t afterDelay:3];
    [self performSelector:@selector(playTrack:) withObject:t afterDelay:5];
}




#pragma mark Implementation

@end
