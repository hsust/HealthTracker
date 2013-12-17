//
//  SYHShareViewController.m
//  HealthTracker
//
//  Created by Stephanie Hsu on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHShareViewController.h"
#import <Social/Social.h>

@interface SYHShareViewController ()


@end

@implementation SYHShareViewController

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"settingsBackground.png"]]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModal:)];
//    navItem.leftBarButtonItem = backButton;
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(submitNewMeal:)];
//    [doneButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17]}
//                              forState:UIControlStateNormal];
//    navItem.rightBarButtonItem = doneButton;
    
//    UIColor *titleColor = [UIColor colorWithRed:29/255.0 green:98/255.0 blue:240/255.0 alpha:1.0];
   
}

- (IBAction)dismissModal:(UIButton *) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)share:(id)sender
{
    UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"Share Data" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", nil];
    
    [share showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeTwitter];
            
            [tweetSheet setInitialText:@"Share HealthTracker Data on Twitter!"];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't access Twitter right now." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }
    
    else if (buttonIndex == 1) {
        if ([SLComposeViewController isAvailableForServiceType: SLServiceTypeFacebook]) {
            SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType: SLServiceTypeFacebook];
            
            [facebookSheet setInitialText:@"Share HealthTracker Data on Facebook!"];
            
            [self presentViewController:facebookSheet animated:YES completion:nil];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't access Facebook right now." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
