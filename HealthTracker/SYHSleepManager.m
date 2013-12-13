//
//  SYHSleepManager.m
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHSleepManager.h"

@implementation SYHSleepManager

- (BOOL) sleepBool
{
    return (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:@"sleepBool"];
}

- (void) setSleepBool:(BOOL)sleepBool
{
    [[NSUserDefaults standardUserDefaults] setBool:sleepBool forKey:@"sleepBool"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
