//
//  SYHNewMealController.h
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYHMealType.h"

@interface SYHNewMealController : UIViewController
{
    IBOutlet UILabel *mealTypeLabel;
    IBOutlet UITextField *timeField;
    IBOutlet UITextField *mealField;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UINavigationItem *navItem;
}
//@property (nonatomic) NSString * mealType;
@property (nonatomic) SYHMealType mealType;

@end
