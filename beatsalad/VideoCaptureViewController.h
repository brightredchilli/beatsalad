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


@interface VideoCaptureViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate> {
 
  AVCaptureSession *videoSession;
  CALayer *videoLayer;
  AVCaptureVideoPreviewLayer *prevLayer;
  
  CaptureSummary *summary;
  
  int labelCounter;
  BOOL intensitiesChanging;
  unsigned int count;
  
}

@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet BSProgressView *progressView;

- (IBAction)startProgress:(id)sender;
- (IBAction)resetProgress:(id)sender;


@end
