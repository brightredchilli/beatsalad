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

+ (void)initialize {
  manager = [[TrackManager alloc] init];
}

+ (TrackManager *)sharedManager {
  return manager;
}


#pragma mark Implementation

@end
