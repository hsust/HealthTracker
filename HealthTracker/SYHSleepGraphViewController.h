//
//  SYHSleepGraphViewController.h
//  HealthTracker
//
//  Created by Stephanie Hsu on 12/16/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SYHSleepGraphViewController : UIViewController <CPTPlotDataSource>

- (IBAction)dismissModal:(UIBarButtonItem *) sender;

@end
