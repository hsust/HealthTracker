//
//  SYHMealObject.h
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYHMealObject : NSObject

@property (nonatomic,strong) NSDate *mealTime;
@property (nonatomic,strong) NSMutableArray *meals;

- (id) initWithTime: (NSDate *) theTime AndMeal: (NSString *) theMeal;

@end
