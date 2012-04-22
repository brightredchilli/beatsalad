//
//  AudioManager.m
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "AudioManager.h"

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

    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    player.numberOfLoops = -1;
    [player prepareToPlay];
    [player setDelegate:self];
    //[player playAtTime:....];
    [player play];
    
    [audioPlayerArray addObject:player];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {

}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
}

- (void)stopTrack:(NSString *)str {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:str ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    for(AVAudioPlayer *player in audioPlayerArray) {
        if([player.url isEqual:fileURL]) {
            [player stop];
        }
    }
}

@end
