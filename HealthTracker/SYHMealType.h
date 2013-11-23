//
//  SYHMealType.h
//  HealthTracker
//
//  Created by User on 11/18/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SYHMealType <NSObject>

//typedef enum mealTypes
//{
//    MEALTYPE_BREAKFAST,
//    MEALTYPE_LUNCH,
//    MEALTYPE_DINNER,
//    MEALTYPE_SNACK
//} MealType;

typedef NS_ENUM(NSUInteger, SYHMealType) {
    MealTypeBreakfast = 0,
    MealTypeLunch,
    MealTypeDinner,
    MealTypeSnack
};

@end
