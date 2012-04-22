//
//  VisualizationViewController.m
//  beatsalad
//
//  Created by Colin Cowles on 4/21/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import "VisualizationViewController.h"

@interface VisualizationViewController ()

@end

@implementation VisualizationViewController

//@synthesize trackArray;

//- (id)initWithTracks:(NSArray *)tracks {
//    self = [super initWithNibName:nil bundle:nil];
//    if(self) {
//        self.trackArray = tracks;
//    }
//    return self;
//}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSInteger i = [[self.view subviews] indexOfObjectIdenticalTo:recognizer.view];
    NSArray *trackList = [[TrackManager sharedManager] currentTrackList];
    if(i >= [trackList count]) {
        [NSException raise:@"problem in visVC" format:@"out of bounds"];
    }
    Track *t = [trackList objectAtIndex:i];
    [[TrackManager sharedManager] toggleTrack:t];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    NSInteger i = [[self.view subviews] indexOfObjectIdenticalTo:recognizer.view];
    NSArray *trackList = [[TrackManager sharedManager] currentTrackList];
    if(i >= [trackList count]) {
        [NSException raise:@"problem in visVC" format:@"out of bounds"];
    }
    Track *t = [trackList objectAtIndex:i];
    [[[self.view subviews] objectAtIndex:i] removeFromSuperview];
    [[TrackManager sharedManager] stopTrack:t];
    [self recalibrateViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *trackArray = [[TrackManager sharedManager] currentTrackList];
    
    if(trackArray.count == 0) {
      return;
    }
    
    int trackSize = 480 / [trackArray count];
    NSMutableArray *visArray = [NSMutableArray array];
    
    int i = 1;
    for(Track *t in trackArray) {
        VisualizationView *v = [[VisualizationView alloc] initWithFrame:CGRectMake(0, -(trackSize * i) - 480, 320, trackSize + 480)];
        v.color = t.trackColor;
//        if(i == 1) {
//            //only set these properties on the first view, or else the borders will stack
//            v.layer.shadowRadius = 4.0f;
//            v.layer.shadowColor = [[UIColor blackColor] CGColor];
//            v.layer.shadowOpacity = 200/255.0;
//        }
        [self.view addSubview:v];
        [visArray addObject:v];
        ++i;
    }
    
    CABasicAnimation *bounceAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounceAnimation.fromValue = [NSNumber numberWithInt:0];
    bounceAnimation.toValue = [NSNumber numberWithInt:50];
    bounceAnimation.repeatCount = 1;
    bounceAnimation.duration = .3;
    bounceAnimation.autoreverses = YES;
    bounceAnimation.fillMode = kCAFillModeForwards;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.additive = YES;
    
    float dur = 0.1;
    for(VisualizationView *v in visArray) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:dur];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        v.transform = CGAffineTransformMakeTranslation(0, 480);
        [UIView commitAnimations];
        [v.layer addAnimation:bounceAnimation forKey:@"bounceAnimation"];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:dur];
        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseIn];
        [UIView commitAnimations];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [v addGestureRecognizer:singleTap];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        [v addGestureRecognizer:swipe];
        dur = dur + 0.2;
    }
    // Do any additional setup after loading the view from its nib.
    
    [[TrackManager sharedManager] playAllTracks];
}


//probably should be refactored
- (void)recalibrateViews {
    NSArray *trackArray = [[TrackManager sharedManager] currentTrackList];
    
    int trackSize = 480 / [trackArray count];
    
    int i = 0;
    for(VisualizationView *v in [self.view subviews]) {
        CGFloat bottomOfView = CGRectGetMaxY(v.frame);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        //have to add the 480 that was previously added
        v.transform = CGAffineTransformMakeTranslation(0, v.transform.ty + (480 - (trackSize * i)) - bottomOfView);
        [UIView commitAnimations];
        ++i;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
