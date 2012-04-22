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

- (id)initWithColor:(UIColor *)color type:(TrackType)trackType {
    self = [super init];
    if(self) {
        self.trackColor = color;
        self.type = trackType;
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
  
  if (!trackColor) {
    trackColor = [UIColor blackColor];
    NSLog(@"SOMETHING WENT WRONG HERE! NULL TRACK COLOR!!!!!!!");
  }
    
  
    const float *colors = CGColorGetComponents(trackColor.CGColor);
  
    float r = colors[0];
    float g = colors[1];
    float b = colors[2];
    
    
    NSString *red, *green, *blue;
    
    //only one can be 1 with bass, so make it the strongest
    if(type == TrackTypeBass) {
        if(r >= g) {
            green = @"0";
            if(r >= b) {
                blue = @"0";
                red = @"1";
            }
            else {
                red = @"0";
                blue = @"1";
            }
        }
        else {
            red = @"0";
            if(g >= b) {
                blue = @"0";
                green = @"1";
            }
            else {
                green = @"0";
                blue = @"1";
            }
        }
        if(r == g && r == b && r == 0.0) {
            red = @"1";
        }
    }
    else {
        red = r < 128.0/255.0 ? @"0" : @"1";
        green = g < 128.0/255.0 ? @"0" : @"1";
        blue = b < 128.0/255.0 ? @"0" : @"1";
    }
    
    ret = [ret stringByAppendingFormat:@"%@%@%@",red,green,blue];
    
    return ret;  
}

//+ (NSString *)FilePrefixForColorsAboveThresholdWithR:(BOOL)R G:(BOOL)G B:(BOOL)B trackType:(TrackType)trackType {
//    methodNotImplemented();
//    return nil;
//}

@end
