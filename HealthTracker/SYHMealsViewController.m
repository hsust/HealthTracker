//
//  SYHFirstViewController.m
//  HealthTracker
//
//  Created by Bernadette Hsu on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHMealsViewController.h"
#import "SYHNewMealController.h"

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
        newMealController.mealType = mealTypeButton.titleLabel.text;
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
