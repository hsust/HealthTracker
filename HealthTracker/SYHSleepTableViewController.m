//
//  SYHSleepTableViewController.m
//  HealthTracker
//
//  Created by User on 12/13/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHSleepTableViewController.h"
#import "SYHSleepManager.h"
#import "SYHDataManager.h"

@interface SYHSleepTableViewController ()

@property (nonatomic,strong) SYHDataManager *myDataManager;
@property (nonatomic,strong) NSMutableArray *allSleep;

@end

@implementation SYHSleepTableViewController

- (SYHDataManager *) myDataManager
{
    if (!_myDataManager) {
        _myDataManager = [[SYHDataManager alloc] init];
    }
    return _myDataManager;
}

- (NSMutableArray *) allSleep
{
    if (!_allSleep) {
        _allSleep = [[NSMutableArray alloc] initWithArray: [self.myDataManager allSleeps]];
    }
    return _allSleep;
}

- (IBAction)dismissModal:(UIBarButtonItem *) sender
{
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.allSleep count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SleepCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SYHSleepObject *currentSleep = [self.allSleep objectAtIndex:indexPath.row];
    
    NSTimeInterval interval = [currentSleep.endTime timeIntervalSinceDate:currentSleep.startTime];
    double hours = interval / 3600.0;             // integer division to get the hours part
    NSDecimalNumber *time = [[NSDecimalNumber alloc] initWithDouble:round(hours*100)/100];
    
    UILabel *dateLabel = (id)[cell viewWithTag:1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *date =[dateFormatter stringFromDate:currentSleep.endTime];
    dateLabel.text = [@"Date: " stringByAppendingString: date];
    
    
    UILabel *timeLabel = (id)[cell viewWithTag:2];
    NSString *label = [NSString stringWithFormat:@"%@", time];
    timeLabel.text= [@"Duration: " stringByAppendingString:label];
    
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
        [self.myDataManager deleteSleep:[self.allSleep objectAtIndex:indexPath.row] ];
        [self.allSleep removeObjectAtIndex:indexPath.row];
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
