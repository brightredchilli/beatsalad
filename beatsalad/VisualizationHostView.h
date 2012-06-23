//
//  VisualizationHostView.h
//  beatsalad
//
//  Created by Ying Quan Tan on 4/22/12.
//  Copyright (c) 2012 Burning Hollow Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OpenVizButtonWidth 40
#define OpenVizButtonYOffset 100
#define OpenVizFrame CGRectMake(0, OpenVizButtonYOffset, OpenVizButtonWidth, 200)
#define CloseVizFrame CGRectMake(OpenVizButtonWidth, OpenVizButtonYOffset, OpenVizButtonWidth, 200)
#define VisualizationVCFrame CGRectMake(OpenVizButtonWidth, 0, 320, 480)

extern NSString *const kVisualizationHostViewOpen;
extern NSString *const kVisualizationHostViewClose;

@interface VisualizationHostView : UIView {

  BOOL isOpen;
}



@end
