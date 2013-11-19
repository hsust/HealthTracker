//
//  SYHNewMealController.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHNewMealController.h"
#import "SYHMealObject.h"
#import "SYHDataManager.h"

@interface SYHNewMealController ()
- (IBAction)dismissModal:(UIButton *) sender;
- (IBAction)submitNewMeal:(UIButton *)sender;
- (void) resignKeyboard:(id) sender;
@property (strong) UITapGestureRecognizer *tapRecognizer;



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
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a, MM/dd/YY"];
        NSDate *date = [formatter dateFromString:timeField.text];
        
        SYHMealObject *newMeal = [[SYHMealObject alloc] init];
        newMeal.mealTime = date;
        newMeal.meals = mealField.text;
        
        SYHDataManager *myMealDataManager = [[SYHDataManager alloc] init];

        if ([myMealDataManager addMealWithData:newMeal]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *missingFields = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [missingFields show];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Date picker
    UIDatePicker *myDatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, 200, 320, 200)];
    [myDatePicker addTarget:self
                     action:@selector(pickerChanged:)
           forControlEvents:UIControlEventValueChanged];
    myDatePicker.maximumDate = [NSDate date];
    timeField.inputView = myDatePicker;
    
    
    // Tap recognizer to dismiss keyboard
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];

}

- (void)pickerChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a, MM/dd/YY"];
    timeField.text = [dateFormatter stringFromDate:[sender date]];
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
