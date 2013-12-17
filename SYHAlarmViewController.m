//
//  SYHAlarmViewController.m
//  HealthTracker
//
//  Created by Stephanie Hsu on 12/14/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHAlarmViewController.h"

@interface SYHAlarmViewController ()

@end

@implementation SYHAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    dateTimePicker.date = [NSDate date];
}

- (IBAction)dismissModal:(id) sender
{
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) scheduleLocalNotification:(NSDate *)fireDate
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = fireDate;
    notification.alertBody = @"Time to Wake Up!";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}

-(void) presentMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm Clock" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
}


-(IBAction)alarmSetButtonTapped:(id)sender;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    NSString *dateTimeString = [dateFormatter stringFromDate:dateTimePicker.date];
    
    NSLog(@"Alarm button set: %@",dateTimeString);
    
    [self scheduleLocalNotification:dateTimePicker.date];
    
    [self presentMessage:@"Alarm set."];
    
}
-(IBAction)alarmCancelButtonTapped:(id)sender
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self presentMessage:@"Alarm cancelled."];
}

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//
//        
//        application.applicationIconBadgeNumber = 0;
//        
//        // Handle launching from a notification
//        UILocalNotification *localNotif =[launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
//        if (localNotif) {
//            NSLog(@"Recieved Notification %@",localNotif);
//        }
//        
//        return YES;
//}
//
//- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notification
//{
//        if (app.applicationState == UIApplicationStateInactive )
//        {
//            NSLog(@"app not running");
//        }
//        else if(app.applicationState == UIApplicationStateActive )
//        {
//            NSLog(@"app running");
//        }
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
