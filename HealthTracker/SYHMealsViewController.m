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
    [self addButtons];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mealBackground.png"]]];
}

- (void)addButtons
{
    UIButton *breakfastButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, 150, 60)];
    [breakfastButton setTitle:@"+ New Breakfast" forState:UIControlStateNormal];
    UIButton *lunchButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 100, 150, 60)];
    [lunchButton setTitle:@"+ New Lunch" forState:UIControlStateNormal];
    UIButton *dinnerButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 160, 150, 60)];
    [dinnerButton setTitle:@"+ New Dinner" forState:UIControlStateNormal];
    UIButton *snackButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 220, 150, 60)];
    [snackButton setTitle:@"+ New Snack" forState:UIControlStateNormal];
    UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 300, 150, 60)];
    [previousButton setTitle:@"See Previous Meals" forState: UIControlStateNormal];
    NSArray *buttons = [[NSArray alloc] initWithObjects: breakfastButton, lunchButton, dinnerButton, snackButton, previousButton, nil];
    
    UIButton *button;
    for (int i = 0; i < buttons.count; i++){
        button = (UIButton *)[buttons objectAtIndex:i];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == buttons.count - 1){
            [button addTarget:self
                       action:@selector(seePreviousMeals:)
             forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
        } else {
            [button addTarget:self
                       action:@selector(insertNewMeal:)
             forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
        }
        [button setTag: i];
        [self.view addSubview:button];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"NewMeal"]){
        SYHNewMealController *newMealController = (SYHNewMealController *) segue.destinationViewController;
        UIButton *mealTypeButton = (UIButton *) sender;
        
        NSLog(@"%@, %i", mealTypeButton.titleLabel.text, mealTypeButton.tag);
        
        switch (mealTypeButton.tag) {
            case 0:
                newMealController.mealType = MealTypeBreakfast;
                break;
            case 1:
                newMealController.mealType = MealTypeLunch;
                break;
            case 2:
                newMealController.mealType = MealTypeDinner;
                break;
            case 3:
                newMealController.mealType = MealTypeSnack;
                break;
            default:
                NSLog(@"Error with matching meal type.");
                break;
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
