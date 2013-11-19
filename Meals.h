//
//  Meals.h
//  HealthTracker
//
//  Created by User on 11/18/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meals : NSManagedObject

@property (nonatomic, retain) NSDate * mealTime;
@property (nonatomic, retain) NSString * meals;

@end
