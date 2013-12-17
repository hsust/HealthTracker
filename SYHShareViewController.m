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

@property (nonatomic,strong) SYHDataManager *myDataManager;
@property (nonatomic,strong) NSMutableArray *allMeals;

@end

@implementation SYHShareViewController

- (SYHDataManager *) myDataManager
{
    if (!_myDataManager) {
        _myDataManager = [[SYHDataManager alloc] init];
    }
    return _myDataManager;
}

- (NSMutableArray *) allMeals
{
    if (!_allMeals) {
        _allMeals = [[NSMutableArray alloc] initWithArray: [self.myDataManager allMeals]];
    }
    return _allMeals;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

- (IBAction)exportMeals:(id)sender
{
    
    NSString *cvs = @"";
    NSLog(@"COUNT: %i",[self.allMeals count]);
    for (int i = 0; i < [self.allMeals count]; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",[self.allMeals objectAtIndex:i]];
        cvs = [cvs stringByAppendingString:string];
    }
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Users/bernadettehsu/Desktop"];
    //If you want to store in a file the CVS
//    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
//    NSString * desktopPath = [paths objectAtIndex:0];
    
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filename = @"FILENAME";

    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [cvs writeToFile:filename atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    
    NSLog(@"THIS IS THE DATA: %@",cvs );


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
