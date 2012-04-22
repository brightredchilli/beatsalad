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
    manager.currentTrackList = [NSArray arrayWithObjects:t,t2,nil];
    manager.audioManager = [[AudioManager alloc] init];
}

+ (TrackManager *)sharedManager {
    return manager;
}

//debug
- (void)playAllTracks {
    for(Track *t in manager.currentTrackList) {
        [audioManager playTrack:t.filePrefix];
    }
}


#pragma mark Implementation

@end
