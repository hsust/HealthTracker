//
//  SYHSleepViewController.m
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHSleepViewController.h"
#import "SYHSleepManager.h"

@interface SYHSleepViewController ()
@property(nonatomic) BOOL sleepBool;
@property (nonatomic, strong) SYHSleepManager *sleepManager;

@property (nonatomic, strong) IBOutlet UIButton *sleepButton;

- (IBAction)changeAndSaveSleepStatus:(UIButton *) sender;
- (IBAction)seePreviousSleep:(UIButton *) sender;
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
}



- (IBAction)changeAndSaveSleepStatus:(UIButton *) sender
{
    _sleepBool = !_sleepBool;
    [self.sleepManager setSleepBool:_sleepBool];
    [self changeSleepText:sender];
}

- (IBAction)seePreviousSleep:(UIButton *)sender
{
}


- (void)changeSleepText:(UIButton *) sender
{
    if (self.sleepManager.sleepBool){
        [_sleepButton setTitle:@"Wake up" forState:UIControlStateNormal];
    } else {
        [_sleepButton setTitle:@"Go to sleep" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
