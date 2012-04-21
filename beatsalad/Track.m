//
//  Track.m
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "Track.h"

@implementation Track

@synthesize type, trackColor;

- (id)initWithColor:(UIColor *)color {
    self = [super init];
    if(self) {
        self.trackColor = color;
    }
    return self;
}

- (NSString *)filePrefix {
    NSString *ret = @"";
    switch(type) {
        case TrackTypeBass:
            ret = [ret stringByAppendingString:@"bass_"];
            break;
        case TrackTypeMelody:
            ret = [ret stringByAppendingString:@"melody_"];
            break;
        case TrackTypeHarmony:
            ret = [ret stringByAppendingString:@"harmony_"];
            break;
        case TrackTypePercussion:
            ret = [ret stringByAppendingString:@"percussion_"];
            break;
    }
    
    const float *colors = CGColorGetComponents(trackColor.CGColor);
    float r = colors[0];
    float g = colors[1];
    float b = colors[2];
    
    
    NSString *red = r < 128.0 ? @"0" : @"1";
    NSString *green = g < 128.0 ? @"0" : @"1";
    NSString *blue = b < 128.0 ? @"0" : @"1";
    
    ret = [ret stringByAppendingFormat:@"%@%@%@",red,green,blue];
    
    return ret;  
}

//+ (NSString *)FilePrefixForColorsAboveThresholdWithR:(BOOL)R G:(BOOL)G B:(BOOL)B trackType:(TrackType)trackType {
//    methodNotImplemented();
//    return nil;
//}

@end
