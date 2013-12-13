//
//  SYHSleepManager.h
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHSleepManager : NSObject

@property (nonatomic) BOOL sleepBool;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

- (void) setSleepBool:(BOOL)sleepBool;
@end
