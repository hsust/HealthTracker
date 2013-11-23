//
//  Meals.h
//  HealthTracker
//
//  Created by User on 11/23/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meals : NSManagedObject

@property (nonatomic, retain) NSString * meals;
@property (nonatomic, retain) NSDate * mealTime;
//@property (nonatomic, retain) NSNumber * mealType;

@end
