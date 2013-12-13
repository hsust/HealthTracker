//
//  Sleeps.h
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sleeps : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;

@end
