//
//  Track.h
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TrackTypeBass,
    TrackTypeMelody,
    TrackTypeHarmony,
    TrackTypePercussion,
} TrackType;

@interface Track : NSObject {
    UIColor *trackColor;
    TrackType type;
}

@property (nonatomic, retain) UIColor *trackColor;

@property (nonatomic, assign) TrackType type;

- (id)initWithColor:(UIColor *)color;
- (NSString *)filePrefix;

//+ (NSString *)FilePrefixForColorsAboveThresholdWithR:(BOOL)R G:(BOOL)G B:(BOOL)B trackType:(TrackType)trackType;

@end
