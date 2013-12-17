//
//  SYHSleepViewController.m
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHSleepViewController.h"
#import "SYHSleepManager.h"
#import "SYHSleepObject.h"
#import "SYHDataManager.h"

@interface SYHSleepViewController ()
@property (nonatomic, strong) SYHSleepManager *sleepManager;
@property (nonatomic, strong) IBOutlet UIButton *sleepButton;

- (IBAction)changeAndSaveSleepStatus:(UIButton *) sender;
@end

@implementation SYHSleepViewController

- (SYHSleepManager *)sleepManager
{
    if (!_sleepManager)
        _sleepManager = [[SYHSleepManager alloc] init];
    return _sleepManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sleepBackground2.png"]]];
}

- (IBAction)changeAndSaveSleepStatus:(UIButton *) sender
{
    BOOL currSleepBool = [self.sleepManager sleepBool];

    if (currSleepBool && !self.sleepManager.startTime ){
        NSLog(@"startTime: %@ endtime: %@", self.sleepManager.startTime, self.sleepManager.endTime);
        UIAlertView *missingFields = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [missingFields show];
    } else if (currSleepBool){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *title =[dateFormatter stringFromDate:self.sleepManager.startTime];
        NSString *titleMain = @"Start: ";
        titleMain = [titleMain stringByAppendingString:title];
        titleMain = [titleMain stringByAppendingString:@"\n"];
        
        self.sleepManager.endTime = [NSDate date];

        NSString *titleTwo = [dateFormatter stringFromDate:self.sleepManager.endTime];
        NSString *title2 = @"End: ";
        titleTwo = [title2 stringByAppendingString:titleTwo];
        
        NSString *all = [titleMain stringByAppendingString:titleTwo];
        
        UIAlertView *check= [[UIAlertView alloc] initWithTitle:all message:@"Do you want to save this sleep?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        
        [check show];
    } else {
        self.sleepManager.startTime = [NSDate date];
    }
    
    [self.sleepManager setSleepBool:!currSleepBool];
    [self changeSleepText:sender];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        self.sleepManager.endTime = [NSDate date];
        [self saveNewSleep];
    }
    else
    {
        NSLog(@"cancel");
    }
}

-(void)changeStatus:(UIButton *) sender
{
    self.sleepManager.endTime = [NSDate date];
    [self saveNewSleep];
}


- (void)changeSleepText:(UIButton *) sender
{
    if (self.sleepManager.sleepBool){
        [_sleepButton setTitle:@"Wake up!" forState:UIControlStateNormal];
    } else {
        [_sleepButton setTitle:@"Go to sleep!" forState:UIControlStateNormal];
    }
}

- (void)saveNewSleep
{
    if (!self.sleepManager.startTime || !self.sleepManager.endTime) {
        UIAlertView *missingFields = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incomplete sleep start or end time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [missingFields show];
        return;
    } else {
        SYHSleepObject *newSleep = [[SYHSleepObject alloc] init];
        newSleep.startTime = self.sleepManager.startTime;
        newSleep.endTime = self.sleepManager.endTime;
        SYHDataManager *mySleepDataManager = [[SYHDataManager alloc] init];
        
        if ([mySleepDataManager addSleepWithData:newSleep]) {
            NSLog(@"New sleep successfully added: %@, %@", newSleep.startTime, newSleep.endTime);
        } else {
            UIAlertView *missingFields = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [missingFields show];
        }
        self.sleepManager.startTime = nil;
        self.sleepManager.endTime = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
