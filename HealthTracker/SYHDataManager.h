//
//  SYHDataManager.h
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Meals.h"
#import "SYHMealObject.h"
#import "Sleeps.h"
#import "SYHSleepObject.h"

@interface SYHDataManager : NSObject


- (BOOL) addMealWithData : (SYHMealObject *) newMeal;
- (NSArray *) allMeals;
- (BOOL) deleteMeal : (Meals *) meal;

- (BOOL) addSleepWithData: (SYHSleepObject *)newSleep;
- (NSArray *) allSleeps;
- (BOOL) deleteSleep: (Sleeps *) sleep;

@end
