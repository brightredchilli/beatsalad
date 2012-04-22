//
//  VideoCaptureViewController.m
//  beatsalad
//
//  Created by Ying Quan Tan on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "VideoCaptureViewController.h"
#import <CoreVideo/CoreVideo.h>
#import <QuartzCore/QuartzCore.h>
#import "BSPixel.h"

@interface VideoCaptureViewController ()
- (void)initCapture;
- (void)startLabelUpdate;
- (void)stopLabelUpdate;
- (void)updateCaptureSummary;
- (void)checkProgress;
- (void)handleSwipeOnProgressView:(UISwipeGestureRecognizer *)recognizer;
- (void)refresh;
@end


@implementation VideoCaptureViewController

@synthesize testLabel;
@synthesize progressView;
@synthesize channelPickerView;
@synthesize progressing;
@synthesize addButton;
@synthesize playButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  //delegate = [TrackManager sharedManager];
  progressView.maxCount = MAX_PROGRESS;
  progressView.type = TrackTypePercussion;
  UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnProgressView:)];
  rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
  UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnProgressView:)];
  leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [progressView addGestureRecognizer:leftSwipeRecognizer];
  [progressView addGestureRecognizer:rightSwipeRecognizer];
  self->delegate = [TrackManager sharedManager];
  channelPickerView.delegate = self;
  
  
  vizHostView.backgroundColor = [UIColor clearColor];
  vizHostView = [[VisualizationHostView alloc] initWithFrame:CGRectMake(320 - OpenVizButtonWidth,0, 320 + OpenVizButtonWidth ,480)];
  [self.view addSubview:vizHostView];
  [self initCapture];
  
//  vizVC = [[VisualizationViewController alloc] initWithNibName:nil bundle:nil];
//  vizVC.view.frame = CGRectMake(OpenVizButtonWidth, 0, 300, 400);
//  [vizHostView addSubview:vizVC.view];
}

- (void)viewDidUnload
{
  
  [self setTestLabel:nil];
  [self setProgressView:nil];
  [self setChannelPickerView:nil];
  [self setAddButton:nil];
  [self setPlayButton:nil];
  [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Private
- (void)initCapture {
  AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
  
  AVCaptureVideoDataOutput *outputCapture = [[AVCaptureVideoDataOutput alloc] init];
  outputCapture.alwaysDiscardsLateVideoFrames  =YES;
  
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [outputCapture setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
  });
  
  NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey; 
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]; 
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key]; 
	[outputCapture setVideoSettings:videoSettings]; 
	/*And we create a capture session*/
	videoSession = [[AVCaptureSession alloc] init];
	/*We add input and output*/
	[videoSession addInput:input];
	[videoSession addOutput:outputCapture];
  /*We use medium quality, ont the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
  [videoSession setSessionPreset:AVCaptureSessionPresetMedium];
  
  //	/*We add the Custom Layer (We need to change the orientation of the layer so that the video is displayed correctly)*/
	videoLayer = [CALayer layer];
	videoLayer.frame = self.view.bounds;
	videoLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0, 1);
	videoLayer.contentsGravity = kCAGravityResizeAspectFill;
	[self.view.layer insertSublayer:videoLayer atIndex:0];
  //	/*We add the imageView*/
  //	self.imageView = [[UIImageView alloc] init];
  //	self.imageView.frame = CGRectMake(0, 0, 100, 100);
  //  [self.view addSubview:self.imageView];
  //	/*We add the preview layer*/
  //	prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:videoSession];
  //	prevLayer.frame = CGRectMake(100, 0, 100, 100);
  //  
  //	prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  //	[self.view.layer addSublayer:prevLayer];
  //	/*We start the capture*/
	[videoSession startRunning];
  progressState = VideoCaptureProgressNone;
  
}

- (void)startLabelUpdate {
  
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(startLabelUpdate) 
                           withObject:nil 
                        waitUntilDone:YES];
  }
  labelCounter++;
  switch (labelCounter) {
    case 0:
      testLabel.text = @"Changing";
      break;
    case 1:
      testLabel.text = @"Changing .";
      break;
    case 2:
      testLabel.text = @"Changing ..";
      break;
    case 3:
      testLabel.text = @"Changing ...";
      labelCounter = 0;
      break;
    default:
      break;
  }
  if (intensitiesChanging) {
    [self performSelector:@selector(startLabelUpdate) withObject:nil afterDelay:0.5];
  }
  
}
- (void)stopLabelUpdate {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startLabelUpdate) object:nil];
  
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(stopLabelUpdate) 
                           withObject:nil 
                        waitUntilDone:YES];
  }
  testLabel.text = @"Locked!";
}
   
- (void)updateCaptureSummary {
  

}

#pragma mark Implementation



#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput 
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer 
       fromConnection:(AVCaptureConnection *)connection {
	
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
  /*Lock the image buffer*/
  CVPixelBufferLockBaseAddress(imageBuffer,0); 
  /*Get information about the image*/
  uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
  size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
  size_t width = CVPixelBufferGetWidth(imageBuffer); 
  size_t height = CVPixelBufferGetHeight(imageBuffer);  

  
  uint32_t *address = (uint32_t *)CVPixelBufferGetBaseAddress(imageBuffer);
  
  
  //NSLog(@"red = %d green = %d blue = %d alpha = %d ", BSPixelGetRed(middlePixel), BSPixelGetGreen(middlePixel), BSPixelGetBlue(middlePixel), BSPixelGetAlpha(middlePixel));
  
  CGRect frame = CGRectMake(0, 0, width, height);
  frame = CGRectInset(frame, width/4, width/4);
  
  uint32_t *originPixel = address + (int)frame.size.width + (int)frame.size.height*width;
  
  size_t frame_width = width/2;
  size_t frame_height = height - width/2;
  

  
  if (count % 40 == 0 && progressState != VideoCaptureProgressDisabled) {
    int redCount = 0, blueCount = 0, greenCount = 0, alphaCount = 0;
    uint32_t currentPixel = 0;
    for (int i = 0; i < frame_height; i++) {
      for (int j = 0; j < frame_width; j++) {
        currentPixel = originPixel[i*frame_width + j];
        
//        if (i >= 50 && i <= 55 && j >= 50 && j<= 55 && count %100 == 0) {
//          NSLog(@"red = %d green = %d blue = %d alpha = %d ", BSPixelGetRed(currentPixel), BSPixelGetGreen(currentPixel), BSPixelGetBlue(currentPixel), BSPixelGetAlpha(currentPixel));
//        }
        redCount += BSPixelGetRed(currentPixel);
        greenCount += BSPixelGetGreen(currentPixel);
        blueCount += BSPixelGetBlue(currentPixel);
        alphaCount += BSPixelGetAlpha(currentPixel);
      }
    }
    maxPerPixel = 255 * frame_width*frame_height;
    
    CaptureSummary *currentSummary = [[CaptureSummary alloc] initWithSummaries:maxPerPixel red:redCount blue:blueCount green:greenCount];
    currentSummary.channel = progressView.type;
    currentSummary.averageColor = lastSummary.averageColor;
    
    if ([lastSummary isEqual:currentSummary]) {
      stillCounter++;
    } else {
      stillCounter = 0;

    }
    lastSummary = currentSummary;
    if (stillCounter > 30) {
      if (intensitiesChanging) {
        intensitiesChanging = NO;
//        NSLog(@"summary %@", lastSummary);
//        NSLog(@"color %@", lastSummary.averageColor);
//        NSLog(@"red = %f green = %f blue = %f alpha = %f", (double)redCount/maxPerPixel, (double)greenCount/maxPerPixel, (double)blueCount/maxPerPixel, (double)alphaCount/maxPerPixel);
//        NSLog(@"%X", originPixel[100]);
        lastSummary.averageColor = [UIColor colorWithRed:(double)redCount/maxPerPixel 
                                                      green:(double)greenCount/maxPerPixel 
                                                       blue:(double)blueCount/maxPerPixel 
                                                      alpha:1.0];
        
        [self startProgress:nil];
        progressState = VideoCaptureProgressStarted;
        [self refresh];
        if ([delegate respondsToSelector:@selector(videoCaptureWillBegin:)]) {
          NSLog(@"START CACHING THIS SONG! %@", lastSummary);
          [delegate videoCaptureWillBegin:lastSummary];
        }        
      }
    } else {
      if (!intensitiesChanging) {
        progressState = VideoCaptureProgressNone;
        [self refresh];
        if (progressState == VideoCaptureProgressStarted) {
          if ([delegate respondsToSelector:@selector(videoCaptureWillCancel:)]) {
            NSLog(@"CANCEL THIS SONG NOW! %@", lastSummary);
            [delegate videoCaptureWillCancel:lastSummary];
          }
        }
        
        intensitiesChanging = YES;
        [self resetProgress:nil];
      }
    }
    
//    [summary updateSummaries:frame_width*frame_height red:redCount blue:blueCount green:greenCount];
//    //NSLog(@"%@", summary);
//    
//    if (summary.changed) {
//      if (!intensitiesChanging) {
//        intensitiesChanging = YES;
//        [self resetProgress:nil];
//        NSLog(@"START LABEL UPDATE");
//      }
//    } else {
//      if (intensitiesChanging) {
//        intensitiesChanging = NO;
//        [self startProgress:nil];
//        NSLog(@"STOP LABEL UPDATE");
//
//      }
//    }

  }
  
  
  /*Create a CGImageRef from the CVImageBufferRef*/
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
  CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
  CGImageRef newImage = CGBitmapContextCreateImage(newContext);
	
  /*We release some components*/
  CGContextRelease(newContext); 
  CGColorSpaceRelease(colorSpace);
  
  /*We display the result on the custom layer. All the display stuff must be done in the main thread because
	 UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
	 we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
	[videoLayer performSelectorOnMainThread:@selector(setContents:) withObject: (__bridge id)newImage waitUntilDone:YES];
	
	/*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
	 Same thing as for the CALayer we are not in the main thread so ...*/
	//UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
	
	/*We relase the CGImageRef*/
	CGImageRelease(newImage);
	
	//[self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
	
	/*We unlock the  image buffer*/
	CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
}

- (void)setProgressing:(BOOL)yesOrNo {
  progressing = yesOrNo;
  
  if (progressing) {
    if (!progressingTimer) {
      progressingTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.5 target:self selector:@selector(checkProgress) userInfo:nil repeats:YES];
      [[NSRunLoop mainRunLoop] addTimer:progressingTimer forMode:NSDefaultRunLoopMode];
      
    }
  } else {
    [progressingTimer invalidate];
    progressingTimer = nil;
  }
  
}

- (void)checkProgress {
  progressCount++;

  
  if (progressCount < MAX_PROGRESS) {
    [progressView refresh];
  } else if (progressCount == MAX_PROGRESS) {
    progressState = VideoCaptureProgressCompleted;
    //[addButton performSelectorOnMainThread:@selector(setEnabled:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    addButton.hidden = NO;
    NSLog(@"PLAY THIS SONG NOW! %@", lastSummary);
    [delegate videoCaptureDidCapture:lastSummary];
    
  }
}

- (void)dealloc {
 
  
}

- (IBAction)startProgress:(id)sender {
  self.progressing = YES;
  
}

- (IBAction)resetProgress:(id)sender {
  self.progressing = NO;
  progressCount = 0;
  [progressView reset];
}
- (IBAction)changeChannels:(UIButton *)sender {
  if (sender.selected) {
    
  } else {
    sender.selected = YES;
    UIButton *melodyButton = [[UIButton alloc] initWithFrame:sender.frame];
    [melodyButton setImage:[UIImage imageNamed:@"note_icon.jpeg"] forState:UIControlStateNormal];

    
    UIButton *drumsButton = [[UIButton alloc] initWithFrame:sender.frame];
    [drumsButton setImage:[UIImage imageNamed:@"drums_icon.jpeg"] forState:UIControlStateNormal];
    
    UIButton *harmonyButton = [[UIButton alloc] initWithFrame:sender.frame];
    [harmonyButton setImage:[UIImage imageNamed:@"heart_icon.png"] forState:UIControlStateNormal];
    
    [self.view insertSubview:melodyButton belowSubview:sender];
    [self.view insertSubview:harmonyButton belowSubview:sender];
    [self.view insertSubview:drumsButton belowSubview:sender];

    CABasicAnimation *expandOut = [CABasicAnimation animationWithKeyPath:@"position"];
    expandOut.duration = 2.0;
    [expandOut setFromValue:[melodyButton valueForKey:@"position"]];
    [expandOut setToValue:[NSValue valueWithCGPoint:CGPointMake(melodyButton.layer.position.x - 50, melodyButton.layer.position.y)]];
    [expandOut setByValue:[NSValue valueWithCGPoint:CGPointMake(melodyButton.layer.position.x - 70, melodyButton.layer.position.y)]];
    [melodyButton.layer addAnimation:expandOut forKey:@"expand"];
    
    
// 
  }
}

- (void)handleSwipeOnProgressView:(UISwipeGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateRecognized) {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
      [progressView resetWithDirection:-1];
      NSLog(@"LEFT");
    } else {
      [progressView resetWithDirection:1];
      NSLog(@"RIGHT");
    }
    [self resetProgress:nil];
    [delegate videoCaptureStopPlayingCurrentTrack];
  }
}

- (IBAction)addButtonAction:(UIButton *)sender {
  if (progressState == VideoCaptureProgressCompleted) {
    [delegate videoCaptureDidAddToList];
  }
}

- (IBAction)togglePlay:(id)sender { //if selected, that means we have paused it.
  if (!playButton.selected) {
    [[[TrackManager sharedManager] audioManager] muteTracks];
    [NSObject cancelPreviousPerformRequestsWithTarget:delegate];
    [self resetProgress:nil];
    progressState = VideoCaptureProgressDisabled;
  } else {
    [[[TrackManager sharedManager] audioManager] unmuteTracks];
    progressState = VideoCaptureProgressNone;
  }
  playButton.selected = !playButton.selected;
  [UIView animateWithDuration:0.2 
                   animations:^{
                     if (playButton.selected) {
                       progressView.alpha = 0.0;
                     } else {
                       progressView.alpha = 1.0;
                     }
                     
                   }];
  
    
}


- (void)refresh {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(refresh) withObject:nil waitUntilDone:YES];
    return;
  }
  channelPickerView.backgroundColor = lastSummary.averageColor;
  //[channelPickerView performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:lastSummary.averageColor waitUntilDone:YES];
  if (progressState == VideoCaptureProgressCompleted) {
    addButton.hidden = NO;
  } else {
    addButton.hidden = YES;
  }
  
}
#pragma mark ChannelPickerDelegate
- (void)channelPicker:(ChannelPickerView *)picker channelSelected:(TrackType)type {
  [self resetProgress:nil];
  progressView.type = type;
  
}
@end


