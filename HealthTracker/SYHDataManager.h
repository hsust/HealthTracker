//
//  SYHDataManager.h
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYHMealObject.h"

@interface SYHDataManager : NSObject


- (void) addMealWithData : (SYHMealObject *) newMeal;
- (NSArray *) allMeals;

@end
