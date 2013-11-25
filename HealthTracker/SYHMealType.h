//
//  SYHMealType.h
//  HealthTracker
//
//  Created by User on 11/18/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SYHMealType <NSObject>

typedef NS_ENUM(NSUInteger, SYHMealType) {
    MealTypeBreakfast = 0,
    MealTypeLunch = 1,
    MealTypeDinner = 2,
    MealTypeSnack = 3
};

@end
