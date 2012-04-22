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

@protocol VideoCaptureDelegate;

@interface VideoCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
 
  AVCaptureSession *videoSession;
  CALayer *videoLayer;
  AVCaptureVideoPreviewLayer *prevLayer;
  
  CaptureSummary *lastSummary;
  
  int labelCounter;
  BOOL intensitiesChanging;
  int stillCounter;
  unsigned int count;
  
  int progressCount;
  NSTimer *progressingTimer;
  __weak id <VideoCaptureDelegate>delegate;
  
}

@property (assign, nonatomic) BOOL progressing;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet BSProgressView *progressView;

- (IBAction)startProgress:(id)sender;
- (IBAction)resetProgress:(id)sender;


@end

@protocol VideoCaptureDelegate<NSObject>
- (void)videoCaptureDidCapture:(CaptureSummary *)summary;
- (void)videoCaptureStopPlayingCurrentTrack;

@optional
- (void)videoCaptureWillBegin:(CaptureSummary *)summary; //for pre-loading if needed
- (void)videoCaptureWillCancel:(CaptureSummary *)summary;
@end
