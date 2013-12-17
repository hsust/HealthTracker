//
//  SYHMealsTableViewController.m
//  HealthTracker
//
//  Created by User on 11/19/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHMealsTableViewController.h"
#import "Meals.h"
#import "SYHMealType.h"

@interface SYHMealsTableViewController ()

@property (nonatomic,strong) SYHDataManager *myDataManager;
@property (nonatomic,strong) NSMutableArray *allMeals;

@end

@implementation SYHMealsTableViewController

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

- (IBAction)dismissModal:(UIBarButtonItem *) sender
{
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)convertMealNumberToMealString: (NSNumber *) mealTypeNumber
{
    NSString *result = nil;
    if ([mealTypeNumber isEqualToNumber:@(0)]){
        result = @"Breakfast";
    } else if ([mealTypeNumber isEqualToNumber:@(1)]){
        result = @"Lunch";
    } else if ([mealTypeNumber isEqualToNumber:@(2)]){
        result = @"Dinner";
    } else if ([mealTypeNumber isEqualToNumber:@(3)]){
        result = @"Snack";
    } else {
        result = @"Error";
    }
    return result;
}

- (void)viewDidLoad
{
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allMeals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MealCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SYHMealObject *currentMeal = [self.allMeals objectAtIndex:indexPath.row];
    UILabel *typeLabel = (id)[cell viewWithTag:6];
    typeLabel.text = [@"Meal Type: " stringByAppendingString: [self convertMealNumberToMealString:currentMeal.mealType]];
    
    UILabel *timeLabel = (id)[cell viewWithTag:7];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a, MM/dd/YY"];
    timeLabel.text = [@"Meal Time: " stringByAppendingString: [dateFormatter stringFromDate:currentMeal.mealTime]];
    
    UILabel *foodLabel = (id)[cell viewWithTag:8];
    foodLabel.text = [@"Food: " stringByAppendingString: currentMeal.meals];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.myDataManager deleteMeal:[self.allMeals objectAtIndex:indexPath.row] ];
        [self.allMeals removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
