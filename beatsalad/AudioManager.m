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

@synthesize audioPlayerArray;

- (id)init {
    self = [super init];
    if(self) {
        self.audioPlayerArray = [NSMutableArray array];
    }
    return self;
}

- (void)playTrack:(NSString *)str {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:str ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    
    //try to play the track at the appropriate time
    NSTimeInterval time = 0;

    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.numberOfLoops = -1;
    [player prepareToPlay];
    [player setDelegate:self];
    
    if([audioPlayerArray count] > 0) {
        time = [(AVAudioPlayer *)[audioPlayerArray objectAtIndex:0] currentTime];
        float timeUntilNextMeasure = fmodf(time, 1.5);
        float timeOfNextMeasure = fmodf((timeUntilNextMeasure + time),12.0);
        player.currentTime = timeOfNextMeasure;
        [player playAtTime:player.deviceCurrentTime + timeUntilNextMeasure];
    }
    else {
        [player play];
    }
//    //this is kind of hacky? maybe it should start to play at the next measure instead with playAtTime (each measure is 1.5 seconds)
//    player.currentTime = time + 0.02;
//    [player play];
    
    [audioPlayerArray addObject:player];
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

@end
