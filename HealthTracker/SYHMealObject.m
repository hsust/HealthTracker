//
//  SYHMealObject.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHMealObject.h"

@implementation SYHMealObject

- (id) initWithTime: (NSDate *) theTime AndMeal: (NSString *) theMeal
{
    if (self = [super init]) {
        _mealTime = theTime;
        _meals = [NSMutableArray arrayWithArray:[theMeal componentsSeparatedByString:@","]];
    }
    
    NSLog(@"%@ %@", theTime, theMeal);
    return self;
}

@end
