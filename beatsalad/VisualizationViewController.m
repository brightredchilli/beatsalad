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

@synthesize trackArray;

- (id)initWithTracks:(NSArray *)tracks {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.trackArray = tracks;
    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(!trackArray) {
        Track *t = [[Track alloc] initWithColor:[UIColor redColor]];
        Track *t2 = [[Track alloc] initWithColor:[UIColor blueColor]];
        Track *t3 = [[Track alloc] initWithColor:[UIColor greenColor]];
        Track *t4 = [[Track alloc] initWithColor:[UIColor blackColor]];
        self.trackArray = [NSArray arrayWithObjects:t,t2,t3,t4,nil];
    }
    
    int trackSize = 480 / [trackArray count];
    NSMutableArray *visArray = [NSMutableArray array];
    
    int i = 1;
    for(Track *t in trackArray) {
        VisualizationView *v = [[VisualizationView alloc] initWithFrame:CGRectMake(0, -(trackSize * i), 320, trackSize)];
        v.color = [t.trackColor copy];
        [self.view addSubview:v];
        [visArray addObject:v];
        ++i;
    }
    
    float dur = 0.4;
    for(VisualizationView *v in visArray) {
        [UIView setAnimationDelegate:self];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:dur];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        v.transform = CGAffineTransformMakeTranslation(0, 480);
        [UIView commitAnimations];
        dur = dur + 0.3;
    }
    // Do any additional setup after loading the view from its nib.
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
