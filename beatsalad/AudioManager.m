//
//  AudioManager.m
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "AudioManager.h"

@interface AudioManager()
- (AVAudioPlayer *)audioPlayerFromString:(NSString *)str;
@end

@implementation AudioManager

@synthesize audioPlayerArray, startOfFirstTrack;

- (id)init {
    self = [super init];
    if(self) {
        self.audioPlayerArray = [NSMutableArray array];
    }
    return self;
}

//this is really heavy and stupid, there should probably just be a bool isBassPlaying
- (AVAudioPlayer *)bassCurrentlyPlaying {
    for(AVAudioPlayer *player in audioPlayerArray) {
        if([[player.url lastPathComponent] rangeOfString:@"bass"].location != NSNotFound) {
            return player;
        }
    }
    return nil;
}

- (void)precacheTrack:(NSString *)str {
    //don't precache it if it's already in the array
    if([self audioPlayerFromString:str]) {
        return;
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:str ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.numberOfLoops = -1;
    [player prepareToPlay];
    [player setDelegate:self];
    [audioPlayerArray addObject:player];
}

- (void)playTrack:(NSString *)str {
    
    //make sure only one bass at a time is playing
    AVAudioPlayer *bass = [self bassCurrentlyPlaying];
    if([str rangeOfString:@"bass"].location != NSNotFound && bass) {
        //in case it's cached
        [bass stop];
        [audioPlayerArray removeObject:bass];
    }
    
    bool trackIsPrecached = YES;
    AVAudioPlayer *player = [self audioPlayerFromString:str];
//track is not yet precached if it hits this 'if'
    if(!player) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:str ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        player.numberOfLoops = -1;
        [player prepareToPlay];
        [player setDelegate:self];
        trackIsPrecached = NO;
    }
    else {
        //don't play it again if it's already playing
        if(player.isPlaying) {
            return;
        }
    }
    
    //try to play the track at the appropriate time
    NSTimeInterval time = 0;    
    
    if([audioPlayerArray count] == 0 || ([audioPlayerArray count] == 1 && [player isEqual:[audioPlayerArray objectAtIndex:0]])) {
        [player play];
        self.startOfFirstTrack = CFAbsoluteTimeGetCurrent();
    }
    else {
        time = [(AVAudioPlayer *)[audioPlayerArray objectAtIndex:0] currentTime];
        float timeUntilNextMeasure = 1.5 - fmodf(time, 1.5);
        float timeOfNextMeasure = timeUntilNextMeasure + time;
        while(timeOfNextMeasure > 12) {
            timeOfNextMeasure -= 12;
        }
        player.currentTime = timeOfNextMeasure;
        [player playAtTime:player.deviceCurrentTime + timeUntilNextMeasure];
    }

    if(!trackIsPrecached) {
        [audioPlayerArray addObject:player];
    }
}

- (void)toggleTrack:(NSString *)str {
    AVAudioPlayer *player = [self audioPlayerFromString:str];
    if(player.isPlaying) {
        [self stopTrack:str];
    }
    else {
        [self playTrack:str];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
}

- (AVAudioPlayer *)audioPlayerFromString:(NSString *)str {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:str ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    for(AVAudioPlayer *player in audioPlayerArray) {
        if([player.url isEqual:fileURL]) {
            return player;
        }
    }
    return nil;
}

- (void)stopTrack:(NSString *)str {
    
    AVAudioPlayer *playerToRemove = [self audioPlayerFromString:str];
    
    if(playerToRemove) {
        [playerToRemove stop];
        [audioPlayerArray removeObject:playerToRemove];
    }
}

- (void)muteTracks {
  for (AVAudioPlayer *player in audioPlayerArray) {
      player.volume = 0;
  }
}
- (void)unmuteTracks {
  for (AVAudioPlayer *player in audioPlayerArray) {
      player.volume = 1;
  }  
}

@end
