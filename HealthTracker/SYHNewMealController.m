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
#import "SYHMealType.h"

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
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm aa, MM/dd/yy"];
        NSDate *date = [formatter dateFromString:timeField.text];

        SYHMealObject *newMeal = [[SYHMealObject alloc] init];
        newMeal.mealTime = date;
        newMeal.meals = mealField.text;
        newMeal.mealType = @(_mealType);
        SYHDataManager *myMealDataManager = [[SYHDataManager alloc] init];
        NSLog(@"%@", newMeal);
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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mealBackground.png"]]];
    
    [self setUpViewUIElements];
    
    // Date picker
    UIDatePicker *myDatePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, 200, 320, 200)];
    [myDatePicker addTarget:self
                     action:@selector(pickerChanged:)
           forControlEvents:UIControlEventValueChanged];
    myDatePicker.maximumDate = [NSDate date];
    timeField.inputView = myDatePicker;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a, MM/dd/YY"];
    timeField.text = [dateFormatter stringFromDate:[NSDate date]];
    
    // Tap recognizer to dismiss keyboard
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
}

-(void) setUpViewUIElements
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModal:)];
    navItem.leftBarButtonItem = backButton;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(submitNewMeal:)];
    navItem.rightBarButtonItem = doneButton;
    
    navItem.titleView.tintColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:230/255.0];
    
    // Set meal type/title
    if (_mealType == MealTypeBreakfast){
        navItem.title = @"BREAKFAST";
    } else if (self.mealType == MealTypeLunch){
        navItem.title = @"LUNCH";
    } else if (_mealType == MealTypeDinner){
        navItem.title = @"DINNER";
    } else if (_mealType == MealTypeSnack){
        navItem.title = @"SNACK";
    } else {
        NSLog(@"Error with matching meal type.");
    }

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
    [self resignKeyboard:self];
}

- (void) resignKeyboard:(id)sender
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
