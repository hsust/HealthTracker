//
//  SYHShareViewController.h
//  HealthTracker
//
//  Created by Stephanie Hsu on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYHShareViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UINavigationItem *navItem;
}

-(IBAction)share:(id)sender;
- (IBAction)dismissModal:(id) sender;

@end
