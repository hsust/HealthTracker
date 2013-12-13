//
//  SYHMealsGraphViewController.h
//  HealthTracker
//
//  Created by User on 11/29/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface SYHMealsGraphViewController : UIViewController <CPTPlotDataSource>


- (IBAction)dismissModal:(UIBarButtonItem *) sender;

@end
