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
    Track *t = [self getTrackForView:(VisualizationView *)recognizer.view];
    [[TrackManager sharedManager] toggleTrack:t];
    if(((VisualizationView *)recognizer.view).isBlinking) {
        [self disableBlinkingForSubview:(VisualizationView *)recognizer.view];
    }
    else {
        [self setUpBlinkingForSubview:(VisualizationView *)recognizer.view];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    Track *t = [self getTrackForView:(VisualizationView *)recognizer.view];
    [recognizer.view removeFromSuperview];
    [[TrackManager sharedManager] stopTrack:t];
    [self recalibrateViews];
}

- (void)viewDidOpen {
    NSArray *trackArray = [[TrackManager sharedManager] currentTrackList];
    
    if(trackArray.count == 0) {
        return;
    }
    
    int trackSize = 480 / [trackArray count];
    NSMutableArray *visArray = [NSMutableArray array];
    
    int i = 1;
    for(Track *t in trackArray) {
        
        //previous
        //        VisualizationView *v = [[VisualizationView alloc] initWithFrame:CGRectMake(0, -(trackSize * i) - 480, 320, trackSize + 480)];
        VisualizationView *v = [[VisualizationView alloc] initWithFrame:CGRectMake(0, -(trackSize * i), 320, trackSize)];
        v.color = t.trackColor;
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
    
    [self setUpBlinkingForSubviews];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidOpen) name:kVisualizationHostViewOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unloadView) name:kVisualizationHostViewClose object:nil];
    
    
    
//    [[TrackManager sharedManager] playAllTracks];
}

- (Track *)getTrackForView:(VisualizationView *)v {
    Track *t = nil;
    for(Track *track in [[TrackManager sharedManager] currentTrackList]) {
        if([track.trackColor isEqual:v.color]) {
            t = track;
            break;
        }
    }
    return t;
}

- (void)setUpBlinkingForSubview:(VisualizationView *)v {
    Track *t = [self getTrackForView:v];
    if(!t) {
        [NSException raise:@"problem in visVC" format:@"couldn't find view"];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:t.filePrefix ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray *numbers = [content componentsSeparatedByString:@","];
    v.blinkTimingArray = numbers;
    v.isBlinking = YES;
    
    NSTimeInterval start = [[TrackManager sharedManager] startOfFirstTrack];
    NSTimeInterval now = CACurrentMediaTime();
    NSTimeInterval difference = now - start;
    NSTimeInterval timeToStartFromNow = 1.5 - fmod(difference, 1.5);

    [v performSelector:@selector(blinkAtDurations:) withObject:numbers afterDelay:timeToStartFromNow];

}

- (void)setUpBlinkingForSubviews {
    NSArray *trackArray = [[TrackManager sharedManager] currentTrackList];
    if([trackArray count] == 0)
        return;
    
//    NSAssert([trackArray count] == [[self.view subviews] count],@"need to add visualizationViews for at least one track");
    for(VisualizationView *v in [self.view subviews]) {
        if([v isKindOfClass:[VisualizationView class]]) {
            [self setUpBlinkingForSubview:v];
        }
    }
}

- (void)disableBlinkingForSubview:(VisualizationView *)v {
    [NSObject cancelPreviousPerformRequestsWithTarget:v];
    v.isBlinking = NO;
}


//probably should be refactored
- (void)recalibrateViews {
    NSArray *trackArray = [[TrackManager sharedManager] currentTrackList];
    if([trackArray count] == 0)
        return;
    
    int trackSize = 480 / [trackArray count];
    
    int i = 1;
    for(VisualizationView *v in [self.view subviews]) {
        if([v isKindOfClass:[VisualizationView class]]) {
            [UIView animateWithDuration:0.2 
                                  delay:0.0 
                                options:UIViewAnimationCurveEaseInOut 
                             animations:^{
                                 v.frame = CGRectMake(0,480 - (trackSize * i),320,trackSize);
                             } completion:^(BOOL finished) {
                                 
                             }];
            ++i;
        }
    }
}

- (void)unloadView {
    for(VisualizationView *v in [self.view subviews]) {
        if([v isKindOfClass:[VisualizationView class]]) {
            [v removeFromSuperview];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVisualizationHostViewClose object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kVisualizationHostViewOpen object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
