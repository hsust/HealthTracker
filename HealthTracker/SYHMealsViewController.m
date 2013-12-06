//
//  SYHFirstViewController.m
//  HealthTracker
//
//  Created by Bernadette Hsu on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHMealsViewController.h"
#import "SYHNewMealController.h"
#import "SYHMealType.h"

@interface SYHMealsViewController ()

- (IBAction)insertNewMeal:(UIButton *) sender;
- (IBAction)seePreviousMeals:(UIButton *)sender;

@end

@implementation SYHMealsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewMeal"]){
        SYHNewMealController *newMealController = (SYHNewMealController *) segue.destinationViewController;
        UIButton *mealTypeButton = (UIButton *) sender;
        
        if (mealTypeButton.tag == 0){
            newMealController.mealType = MealTypeBreakfast;
        } else if (mealTypeButton.tag == 1){
            newMealController.mealType = MealTypeLunch;
        } else if (mealTypeButton.tag == 2){
            newMealController.mealType = MealTypeDinner;
        } else if (mealTypeButton.tag == 3){
            newMealController.mealType = MealTypeSnack;
        } else {
            NSLog(@"Error with matching meal type.");
        }
    }
}

- (IBAction)insertNewMeal:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"NewMeal" sender:sender];
}

- (IBAction)seePreviousMeals:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"PreviousMeals" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
