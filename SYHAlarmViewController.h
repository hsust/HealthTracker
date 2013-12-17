//
//  SYHAlarmViewController.h
//  HealthTracker
//
//  Created by Stephanie Hsu on 12/14/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYHAlarmViewController : UIViewController
{
    IBOutlet UIDatePicker *dateTimePicker;
    IBOutlet UIButton *setAlarm;
    IBOutlet UIButton *cancelAlarm;
    IBOutlet UILabel *currentAlarm;
}

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
//- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification;
-(void) scheduleLocalNotification: (NSDate *) fireDate;
-(void) presentMessage: (NSString *) message;
-(IBAction)alarmSetButtonTapped:(id)sender;
-(IBAction)alarmCancelButtonTapped:(id)sender;
- (IBAction)dismissModal:(id) sender;

@end
