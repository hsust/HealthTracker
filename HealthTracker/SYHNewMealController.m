//
//  SYHNewMealController.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHNewMealController.h"

@interface SYHNewMealController ()
- (IBAction)dismissModal:(UIButton *) sender;

@end

@implementation SYHNewMealController

- (IBAction)dismissModal:(UIButton *) sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                               destructiveButtonTitle:@"Yes"
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet: (UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
    if (buttonIndex == 0){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
