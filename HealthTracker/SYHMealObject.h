//
//  SYHMealObject.h
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYHMealType.h"

@interface SYHMealObject : NSObject

@property (nonatomic,strong) NSDate *mealTime;
@property (nonatomic,strong) NSString *meals;
//@property (nonatomic,assign) NSNumber *mealType;

@end
