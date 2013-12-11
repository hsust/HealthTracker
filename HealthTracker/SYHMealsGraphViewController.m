//
//  SYHMealsGraphViewController.m
//  HealthTracker
//
//  Created by User on 11/29/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//
#import "SYHMealsGraphViewController.h"
#import "SYHDataManager.h"
#import "SYHMealType.h"
#import "Meals.h"

@interface SYHMealsGraphViewController ()
@property (nonatomic,strong) SYHDataManager *myDataManager;
@property (nonatomic,strong) NSArray *allMeals;
@property (nonatomic,strong) NSArray *plotData;
@property (nonatomic,strong) NSArray *breakfastData;
@property (nonatomic,strong) NSArray *lunchData;
@property (nonatomic,strong) NSArray *dinnerData;
@property (nonatomic,strong) NSArray *snackData;
@property (nonatomic,strong) NSMutableDictionary *mealsPlotData;

@end

@implementation SYHMealsGraphViewController

- (SYHDataManager *) myDataManager
{
    if (!_myDataManager) {
        _myDataManager = [[SYHDataManager alloc] init];
    }
    return _myDataManager;
}

- (NSArray *) allMeals
{
    if (!_allMeals) {
        _allMeals = [self.myDataManager allMeals];
    }
    return _allMeals;
}

- (NSMutableDictionary *) mealsPlotData
{
    if (!_mealsPlotData){
        _mealsPlotData = [[NSMutableDictionary alloc] init];
        [_mealsPlotData setObject:[NSMutableArray array] forKey:@"BreakfastData"];
        [_mealsPlotData setObject:[NSMutableArray array] forKey:@"LunchData"];
        [_mealsPlotData setObject:[NSMutableArray array] forKey:@"DinnerData"];
        [_mealsPlotData setObject:[NSMutableArray array] forKey:@"SnackData"];
    }
    return _mealsPlotData;
}


- (IBAction)dismissModal:(UIBarButtonItem *) sender
{
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupAndShowGraph];
}

// Generates the largest frame useable by accounting for NavigationBar and TabBar
- (CGRect) maximumUsableFrame
{
    static CGFloat const kNavigationBarPortraitHeight = 44;
    static CGFloat const kNavigationBarLandscapeHeight = 34;
    static CGFloat const kToolBarHeight = 49;
    
    // Start with the screen size minus the status bar if present
    CGRect maxFrame = [UIScreen mainScreen].applicationFrame;
    
    // Take into account if there is a navigation bar present and visible (note that if the NavigationBar may
    // not be visible at this stage in the view controller's lifecycle.  If the NavigationBar is shown/hidden
    // in the loadView then this provides an accurate result.  If the NavigationBar is shown/hidden using the
    // navigationController:willShowViewController: delegate method then this will not be accurate until the
    // viewDidAppear method is called.
    if (self.navigationController) {
        if (self.navigationController.navigationBarHidden == NO) {
            
            // Depending upon the orientation reduce the height accordingly
            if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
                maxFrame.origin.y += kNavigationBarLandscapeHeight;
            }
            else {
                maxFrame.origin.y += kNavigationBarPortraitHeight;
            }
        }
    }
    
    maxFrame.size.height -= kNavigationBarPortraitHeight;
    
    // Take into account if there is a toolbar present and visible
    if (self.tabBarController) {
        if (!self.tabBarController.view.hidden) maxFrame.size.height -= kToolBarHeight;
    }
    return maxFrame;
}

- (void)setupAndShowGraph
{
    int numOfMeals = [[self allMeals] count];
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components: NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:today];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *beginningOfToday = [calendar dateFromComponents:components];
    components.day -= 7;
    NSDate *aWeekAgo = [calendar dateFromComponents:components];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSTimeInterval oneHour = 60 * 60;
    
    // Graph Theme
    
    
    // Graph Title Style
    CPTMutableTextStyle *graphTitleStyle = [CPTMutableTextStyle textStyle];
    graphTitleStyle.color = [CPTColor whiteColor];
    graphTitleStyle.fontName = @"Helvetica-Bold";
    graphTitleStyle.fontSize = 14.0f;
    
    // Axis Title Style
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Neue";
	axisTitleStyle.fontSize = 8.0f;
    
    // Axis Line Style
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    
    // Date and Time Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    CPTTimeFormatter *xAxisFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    xAxisFormatter.referenceDate = aWeekAgo;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h a"];
    CPTTimeFormatter *yAxisFormatter    = [[CPTTimeFormatter alloc] initWithDateFormatter:timeFormatter];
    yAxisFormatter.referenceDate        = beginningOfToday;
    
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CGRect hostViewFrame = [self maximumUsableFrame];
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame: hostViewFrame];
    hostView.allowPinchScaling = YES;
    [self.view addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [graph applyTheme:theme];
    
    // Graph frame and borders
    graph.plotAreaFrame.paddingTop    = 0;
    graph.plotAreaFrame.paddingBottom = 20;
    graph.plotAreaFrame.paddingLeft   = 40.0;
    graph.plotAreaFrame.paddingRight  = 0.0;
    graph.plotAreaFrame.cornerRadius  = 0.0;
    graph.plotAreaFrame.borderWidth = 0;
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.masksToBorder = NO;
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(8 * oneDay)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(-oneDay)];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.axisConstraints   = [CPTConstraints constraintWithLowerOffset:0];
    axisSet.yAxis.axisConstraints   = [CPTConstraints constraintWithLowerOffset:0];
    
    CPTXYAxis *x                  = axisSet.xAxis;
    x.title                     = @"Date";
    x.titleTextStyle            = axisTitleStyle;
    x.titleOffset               = 20.0f;
    x.majorIntervalLength       = CPTDecimalFromFloat(oneDay);
    x.minorTicksPerInterval     = 0;
    x.labelTextStyle            = axisTitleStyle;
    x.labelFormatter            = xAxisFormatter;
    x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
    
    CPTXYAxis *y                  = axisSet.yAxis;
	y.title                     = @"Time";
	y.titleTextStyle            = axisTitleStyle;
	y.titleOffset               = 40.0f;
    y.majorIntervalLength       = CPTDecimalFromFloat(oneHour);
    y.minorTicksPerInterval     = 0;
    y.labelTextStyle            = axisTitleStyle;
    y.labelFormatter            = yAxisFormatter;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
    
    // Create a plot that uses the data source method
    CPTScatterPlot *dataSourceLinePlot = [[CPTScatterPlot alloc] init];
    dataSourceLinePlot.identifier = @"Meals Plot";
    dataSourceLinePlot.dataLineStyle = nil;
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    CPTPlotSymbol *whiteCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    whiteCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    whiteCirclePlotSymbol.size = CGSizeMake(7.0, 7.0);
    dataSourceLinePlot.plotSymbol = whiteCirclePlotSymbol;
    
    
    // Set up the four graphs
    CPTScatterPlot *breakfastPlot = [[CPTScatterPlot alloc] init];
    breakfastPlot.identifier = @"Breakfast Plot";
    CPTScatterPlot *lunchPlot = [[CPTScatterPlot alloc] init];
    lunchPlot.identifier = @"Lunch Plot";
    CPTScatterPlot *dinnerPlot = [[CPTScatterPlot alloc] init];
    dinnerPlot.identifier = @"Dinner Plot";
    CPTScatterPlot *snackPlot = [[CPTScatterPlot alloc] init];
    snackPlot.identifier = @"Snack Plot";

    // Set up line style
    CPTMutableLineStyle *lineStyle = nil;
    
    // Add plots to graph
    NSArray *plots = [NSArray arrayWithObjects:breakfastPlot, lunchPlot, dinnerPlot, snackPlot, nil];
    for (CPTScatterPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.dataLineStyle = lineStyle;
        plot.plotSymbol = whiteCirclePlotSymbol;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    }
    
    // Add some data
    NSMutableArray *graphData = [NSMutableArray array];
    NSMutableArray *breakfast = [NSMutableArray array];
    NSMutableArray *lunch = [NSMutableArray array];
    NSMutableArray *dinner = [NSMutableArray array];
    NSMutableArray *snack = [NSMutableArray array];
    
    if (numOfMeals == 0){
        return;
    }
    
    NSDate *currDate;
    SYHMealObject *currMeal;
    NSString *mealKey;
    for ( int i = numOfMeals-1; i >= 0; i--) {
        currMeal = [_allMeals objectAtIndex:i];
        currDate = currMeal.mealTime;
        id x = [NSDecimalNumber numberWithDouble:[[self convertToBeginningOfDay:currDate] timeIntervalSinceDate: aWeekAgo]];
        id y = [NSDecimalNumber numberWithDouble:[[self convertToCurrentDate:currDate] timeIntervalSinceDate: beginningOfToday]];
        if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeBreakfast]]){
            mealKey = @"BreakfastData";
            [breakfast addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     x,
                                     [NSNumber numberWithInt:CPTScatterPlotFieldX],
                                     y,
                                     [NSNumber numberWithInt:CPTScatterPlotFieldY],
                                     nil]];
            NSLog(@"here %@", breakfast);
        } else if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeLunch]]){
            mealKey = @"LunchData";
            [lunch addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           x,
                                           [NSNumber numberWithInt:CPTScatterPlotFieldX],
                                           y,
                                           [NSNumber numberWithInt:CPTScatterPlotFieldY],
                                           nil]];
        } else if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeDinner]]){
            mealKey = @"DinnerData";
            [dinner addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           x,
                                           [NSNumber numberWithInt:CPTScatterPlotFieldX],
                                           y,
                                           [NSNumber numberWithInt:CPTScatterPlotFieldY],
                                           nil]];
        } else if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeSnack]]){
            mealKey = @"SnackData";
            [snack addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           x,
                                           [NSNumber numberWithInt:CPTScatterPlotFieldX],
                                           y,
                                           [NSNumber numberWithInt:CPTScatterPlotFieldY],
                                           nil]];
        } else {
        }
        
        [[self.mealsPlotData objectForKey:mealKey] addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         x,
                                                         [NSNumber numberWithInt:CPTScatterPlotFieldX],
                                                         y,
                                                         [NSNumber numberWithInt:CPTScatterPlotFieldY],
                                                         nil]];
        
        [graphData addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              x,
                              [NSNumber numberWithInt:CPTScatterPlotFieldX],
                              y,
                              [NSNumber numberWithInt:CPTScatterPlotFieldY],
                              nil]];
    }
    _plotData = graphData;
    _breakfastData = breakfast;
    _lunchData = lunch;
    _dinnerData = dinner;
    _snackData = snack;
    
}

-(NSDate *)convertToCurrentDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *resultComponents = [calendar components: NSYearCalendarUnit|
                                        NSMonthCalendarUnit|
                                        NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                   fromDate:date];
    NSDateComponents *todayComponents = [calendar components: NSYearCalendarUnit|
                                        NSMonthCalendarUnit|
                                        NSDayCalendarUnit
                                                   fromDate:[NSDate date]];
    resultComponents.year = todayComponents.year;
    resultComponents.month = todayComponents.month;
    resultComponents.day = todayComponents.day-1;
    return [calendar dateFromComponents:resultComponents];
}

-(NSDate *)convertToBeginningOfDay:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *resultComponents = [calendar components: NSYearCalendarUnit|
                                          NSMonthCalendarUnit|
                                          NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                                     fromDate:date];
    resultComponents.hour = 0;
    resultComponents.minute = 0;
    resultComponents.hour = 0;
    return [calendar dateFromComponents:resultComponents];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot.identifier isEqual:@"Breakfast Plot"]) {
        return [self.breakfastData count];
    } else if ([plot.identifier isEqual:@"Lunch Plot"]) {
        return [self.lunchData count];
    } else if ([plot.identifier isEqual:@"Dinner Plot"]) {
        return [self.dinnerData count];
    } else if ([plot.identifier isEqual:@"Snack Plot"]) {
        return [self.snackData count];
    }
    return _plotData.count;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *mealKey;
    NSDecimalNumber *num;
    if ([plot.identifier isEqual:@"Breakfast Plot"]) {
        mealKey = @"BreakfastData";
        num = [[self.breakfastData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    } else if ([plot.identifier isEqual:@"Lunch Plot"]) {
        mealKey = @"LunchData";
        num =  [[self.lunchData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    } else if ([plot.identifier isEqual:@"Dinner Plot"]) {
        mealKey = @"DinnerData";
        num =  [[self.dinnerData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    } else if ([plot.identifier isEqual:@"Snack Plot"]) {
        mealKey = @"SnackData";
        num = [[self.snackData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    }

    return num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end