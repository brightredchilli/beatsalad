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

@synthesize currentTrackList, audioManager, currentTrack;

+ (void)initialize {
    manager = [[TrackManager alloc] init];
    manager.currentTrackList = [NSArray array];
//    Track *t = [[Track alloc] initWithColor:[UIColor redColor] type:TrackTypeMelody];
//    Track *t2 = [[Track alloc] initWithColor:[UIColor blueColor] type:TrackTypePercussion];
//    Track *t3 = [[Track alloc] initWithColor:[UIColor greenColor] type:TrackTypeMelody];
//    manager.currentTrackList = [NSArray arrayWithObjects:t,t2,t3,nil];
    manager.audioManager = [[AudioManager alloc] init];
}

+ (TrackManager *)sharedManager {
    return manager;
}

- (NSTimeInterval)startOfFirstTrack {
    return manager.audioManager.startOfFirstTrack;
}

- (void)precacheTrack:(Track *)t {
    [audioManager precacheTrack:t.filePrefix];
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

- (Track *)trackFromCaptureSummary:(CaptureSummary *)summary {
//    ColorIntensityType r = summary.redIntensity;
//    ColorIntensityType g = summary.greenIntensity;
//    ColorIntensityType b = summary.blueIntensity;
//
//    if(r == ColorIntensityHigh || r == ColorIntensityMid) {
//        r = 255;
//    }
//    if(g == ColorIntensityMid || g == ColorIntensityHigh) {
//        g = 255;
//    }
//    if(b == ColorIntensityMid || b == ColorIntensityHigh) {
//        b = 255;
//    }
//    Track *t = [[Track alloc] initWithColor:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] type:TrackTypePercussion];
    
    Track *t = [[Track alloc] initWithColor:summary.averageColor type:summary.channel];
    return t;
}

//VideoCaptureDelegate functions

- (void)videoCaptureDidCapture:(CaptureSummary *)summary {
    Track *t = [self trackFromCaptureSummary:summary];
    if(self.currentTrack) {
        [self stopTrack:currentTrack];
    }
    self.currentTrack = t;
    [self playTrack:t];
    
//    Track *t;
//    if(r == ColorIntensityLow && g == ColorIntensityLow && b == ColorIntensityLow) {
//        t = [[Track alloc] initWithColor:[UIColor blackColor] type:TrackTypeBass];
//    }
//    else if(r == ColorIntensityHigh && g == ColorIntensityHigh && b == ColorIntensityHigh) {
//        t = [[Track alloc] initWithColor:[UIColor whiteColor] type:TrackTypeBass];
//    }
//    
//    //high, medium, low or medium, medium, low: call it high high low
//    if((r != g && g != b && r != b) ||
//       (r + g + b == 4 && r != 0 && g != 0 && b != 0)) {
//        if(r <= g) {
//            if(g <= b) {
//                g = 255;
//            }
//            else {
//                b = 255;
//            }
//            r = 255;
//        }
//        else {
//            if(r <= b) {
//                r = 255;
//            }
//            else {
//                b = 255;
//            }
//            g = 255;
//        }
//        t = [[Track alloc] initWithColor:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] type:TrackTypeBass];
//    }
//    
//    //medium, low, low: call it high low low
//    if(r + g + b == 5) {
//        if(r < g) {
//            r = 255;
//        }
//        else if(g < r) {
//            g = 255;
//        }
//        else {
//            b = 255;
//        }
//        t = [[Track alloc] initWithColor:[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1] type:TrackTypeBass];
//    }
}


- (void)videoCaptureDidAddToList {
    self.currentTrackList = [currentTrackList arrayByAddingObject:currentTrack];
    self.currentTrack = nil;
}

- (void)videoCaptureStopPlayingCurrentTrack {
    if(!currentTrack) {
        return;
    }
    [self stopTrack:currentTrack];
}

//for pre-loading if needed
- (void)videoCaptureWillBegin:(CaptureSummary *)summary {
    Track *t = [self trackFromCaptureSummary:summary];
    NSLog(@"precaching!");
    [self precacheTrack:t];
} 

- (void)videoCaptureWillCancel:(CaptureSummary *)summary {
//    Track *t = [self trackFromCaptureSummary:summary];
//    NSLog(@"cancelled");
//    [self stopTrack:t];
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
