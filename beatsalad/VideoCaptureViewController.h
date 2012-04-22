//
//  VideoCaptureViewController.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CaptureSummary.h"
#import "BSProgressView.h"

#define MAX_PROGRESS 5

@interface VideoCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
 
  AVCaptureSession *videoSession;
  CALayer *videoLayer;
  AVCaptureVideoPreviewLayer *prevLayer;
  
  CaptureSummary *summary;
  CaptureSummary *lastSummary;
  
  int labelCounter;
  BOOL intensitiesChanging;
  int stillCounter;
  unsigned int count;
  
  int progressCount;
  NSTimer *progressingTimer;
  
}

@property (assign, nonatomic) BOOL progressing;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet BSProgressView *progressView;

- (IBAction)startProgress:(id)sender;
- (IBAction)resetProgress:(id)sender;


@end
