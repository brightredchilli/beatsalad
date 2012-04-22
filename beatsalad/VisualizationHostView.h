//
//  VisualizationHostView.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OpenVizButtonWidth 30
#define OpenVizFrame CGRectMake(320 - OpenVizButtonWidth, 0, 320, 480)

@interface VisualizationHostView : UIView {

  BOOL isOpen;
}

@end
