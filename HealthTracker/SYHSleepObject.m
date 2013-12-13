//
//  SYHSleepObject.m
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHSleepObject.h"

@implementation SYHSleepObject

- (id) initWithCoder: (NSCoder *) decoder
{
    if(self = [self init]){
        _startTime = [decoder decodeObjectForKey: @"startTime"];
        _endTime = [decoder decodeObjectForKey: @"endTime"];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)encoder
{
    [encoder encodeObject:self.startTime forKey: @"startTime"];
    [encoder encodeObject:self.endTime forKey: @"endTime"];
}

@end
