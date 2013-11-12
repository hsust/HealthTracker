//
//  SYHNewMealController.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHNewMealController.h"
#import "SYHMealObject.h"

@interface SYHNewMealController ()
- (IBAction)dismissModal:(UIButton *) sender;
- (IBAction)submitNewMeal:(UIButton *)sender;
- (void) resignKeyboard:(id) sender;



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
- (IBAction)submitNewMeal:(UIButton *)sender
{
    if ([timeField.text isEqualToString:@""] || [mealField.text isEqualToString:@""]) {
        UIAlertView *missingFields = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You need to fill out all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [missingFields show];
    }
    
    else {
        SYHMealObject *mealObject = [[SYHMealObject alloc] initWithTime:[NSDate date] AndMeal:mealField.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];

}

- (void) keyboardWillShow : (NSNotification *)note
{
    [self.view addGestureRecognizer:_tapRecognizer];
}

- (void) keyboardWillHide : (NSNotification *)note
{
    [self.view removeGestureRecognizer:_tapRecognizer];
}

- (void) didTapAnywhere : (UITapGestureRecognizer *) recognizer
{
    [timeField resignFirstResponder];
    [mealField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
