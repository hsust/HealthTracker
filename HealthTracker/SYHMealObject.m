//
//  SYHMealObject.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHMealObject.h"
#import "SYHMealType.h"

@implementation SYHMealObject

- (id) initWithCoder: (NSCoder *) decoder
{
    if(self = [self init]){
        _mealTime = [decoder decodeObjectForKey: @"mealTime"];
        _meals = [decoder decodeObjectForKey: @"meals"];
        _mealType = [decoder decodeObjectForKey:@"mealType"];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)encoder
{
    [encoder encodeObject:self.mealTime forKey: @"mealTime"];
    [encoder encodeObject:self.meals forKey: @"meals"];
    [encoder encodeObject:self.mealType forKey:@"mealType"];
}


@end
