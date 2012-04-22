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
#import "TrackManager.h"
#import "ChannelPickerView.h"
#import "VisualizationViewController.h"
#import "VisualizationHostView.h"

#define MAX_PROGRESS 5

typedef enum {
  VideoCaptureProgressNone,
  VideoCaptureProgressStarted,
  VideoCaptureProgressCompleted
} VideoCaptureProgress;

@protocol VideoCaptureDelegate;

@interface VideoCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate, ChannelPickerDelegate> {
 
  AVCaptureSession *videoSession;
  CALayer *videoLayer;
  AVCaptureVideoPreviewLayer *prevLayer;
  
  CaptureSummary *lastSummary;
  
  int labelCounter;
  BOOL intensitiesChanging;
  int stillCounter;
  unsigned int count;
  VideoCaptureProgress progressState;
  int progressCount;
  NSTimer *progressingTimer;
  __weak id <VideoCaptureDelegate>delegate;
  
  int maxPerPixel;
  TrackType currentTrackType;
  
  VisualizationViewController *vizVC;
  VisualizationHostView *vizHostView;
  
}

@property (assign, nonatomic) BOOL progressing;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet BSProgressView *progressView;
@property (weak, nonatomic) IBOutlet ChannelPickerView *channelPickerView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)startProgress:(id)sender;
- (IBAction)resetProgress:(id)sender;
- (IBAction)changeChannels:(UIButton *)sender;
- (IBAction)addButtonAction:(UIButton *)sender;


@end

@protocol VideoCaptureDelegate<NSObject>
- (void)videoCaptureDidAddToList;
- (void)videoCaptureDidCapture:(CaptureSummary *)summary;
- (void)videoCaptureStopPlayingCurrentTrack;

@optional
- (void)videoCaptureWillBegin:(CaptureSummary *)summary; //for pre-loading if needed
- (void)videoCaptureWillCancel:(CaptureSummary *)summary;
@end
