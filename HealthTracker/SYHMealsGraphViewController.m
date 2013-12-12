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
    [self initPlot];
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

// Launch point for graphs
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    if (![self.allMeals count]){
        return;
    }
    [self addData];
}

-(void)configureHost
{
    CGRect hostViewFrame = [self maximumUsableFrame];
    self.hostView = (CPTGraphHostingView*) [[CPTGraphHostingView alloc] initWithFrame: hostViewFrame];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview: self.hostView];
    
}

-(void)configureGraph {
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTSlateTheme]];
    self.hostView.hostedGraph = graph;
    
    // Graph frame and borders
    graph.plotAreaFrame.paddingTop    = 0;
    graph.plotAreaFrame.paddingBottom = 20;
    graph.plotAreaFrame.paddingLeft   = 40.0;
    graph.plotAreaFrame.paddingRight  = 0.0;
    graph.plotAreaFrame.cornerRadius  = 0.0;
    graph.plotAreaFrame.borderWidth = 0;
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.masksToBorder = NO;
    
	// Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    NSTimeInterval oneDay = 24 * 60 * 60;
    
    // Set up graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // Set up plotspace
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(8 * oneDay)];
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(-oneDay)];
    
    // Plot symbols
    CPTPlotSymbol *breakfastPlotSymbol = [CPTPlotSymbol trianglePlotSymbol ];
    breakfastPlotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    breakfastPlotSymbol.size = CGSizeMake(7.0, 7.0);
    CPTPlotSymbol *lunchPlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    lunchPlotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    lunchPlotSymbol.size = CGSizeMake(7.0, 7.0);
    CPTPlotSymbol *dinnerPlotSymbol = [CPTPlotSymbol crossPlotSymbol];
    dinnerPlotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    dinnerPlotSymbol.size = CGSizeMake(7.0, 7.0);
    CPTPlotSymbol *snackPlotSymbol = [CPTPlotSymbol rectanglePlotSymbol];
    snackPlotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    snackPlotSymbol.size = CGSizeMake(7.0, 7.0);
    // Set up line style
    CPTMutableLineStyle *lineStyle = nil;
    
    // Create Plots
    CPTScatterPlot *breakfastPlot = [[CPTScatterPlot alloc] init];
    breakfastPlot.identifier = @"Breakfast Plot";
    breakfastPlot.plotSymbol = breakfastPlotSymbol;
    CPTScatterPlot *lunchPlot = [[CPTScatterPlot alloc] init];
    lunchPlot.identifier = @"Lunch Plot";
    lunchPlot.plotSymbol = lunchPlotSymbol;
    CPTScatterPlot *dinnerPlot = [[CPTScatterPlot alloc] init];
    dinnerPlot.identifier = @"Dinner Plot";
    dinnerPlot.plotSymbol = dinnerPlotSymbol;
    CPTScatterPlot *snackPlot = [[CPTScatterPlot alloc] init];
    snackPlot.identifier = @"Snack Plot";
    snackPlot.plotSymbol = snackPlotSymbol;
    NSArray *plots = [NSArray arrayWithObjects:breakfastPlot, lunchPlot, dinnerPlot, snackPlot, nil];
    for (CPTScatterPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.dataLineStyle = lineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    }
}

-(void)addData
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components: NSYearCalendarUnit|NSMonthCalendarUnit|
                                    NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:today];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *beginningOfToday = [calendar dateFromComponents:components];
    components.day -= 7;
    NSDate *aWeekAgo = [calendar dateFromComponents:components];
    
    SYHMealObject *currMeal;
    NSDate *currDate;
    NSString *mealKey;
    for ( int i = [self.allMeals count] - 1; i >= 0; i--) {
        currMeal = [_allMeals objectAtIndex:i];
        currDate = currMeal.mealTime;
        id x = [NSDecimalNumber numberWithDouble:[[self convertToBeginningOfDay:currDate] timeIntervalSinceDate: aWeekAgo]];
        id y = [NSDecimalNumber numberWithDouble:[[self convertToCurrentDate:currDate] timeIntervalSinceDate: beginningOfToday]];
        if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeBreakfast]]){
            mealKey = @"BreakfastData";
        } else if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeLunch]]){
            mealKey = @"LunchData";
        } else if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeDinner]]){
            mealKey = @"DinnerData";
        } else if ([currMeal.mealType isEqualToNumber: [NSNumber numberWithInt:MealTypeSnack]]){
            mealKey = @"SnackData";
        } else {
        }
        
        [[self.mealsPlotData objectForKey:mealKey] addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              x,
                                                              [NSNumber numberWithInt:CPTScatterPlotFieldX],
                                                              y,
                                                              [NSNumber numberWithInt:CPTScatterPlotFieldY],
                                                              nil]];
    }
}

-(void)configureAxes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components: NSYearCalendarUnit|NSMonthCalendarUnit|
                                    NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSDate *beginningOfToday = [calendar dateFromComponents:components];
    components.day -= 7;
    NSDate *aWeekAgo = [calendar dateFromComponents:components];
    
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
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
    axisSet.xAxis.axisConstraints   = [CPTConstraints constraintWithLowerOffset:0];
    axisSet.yAxis.axisConstraints   = [CPTConstraints constraintWithLowerOffset:0];
    
    CPTXYAxis *x                  = axisSet.xAxis;
    x.title                     = @"Date";
    x.titleTextStyle            = axisTitleStyle;
    x.titleOffset               = 20.0f;
    x.majorIntervalLength       = CPTDecimalFromFloat(24 * 60 * 60); // x axis interval = 1 day
    x.minorTicksPerInterval     = 0;
    x.labelTextStyle            = axisTitleStyle;
    x.labelFormatter            = xAxisFormatter;
    x.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
    
    CPTXYAxis *y                  = axisSet.yAxis;
	y.title                     = @"Time";
	y.titleTextStyle            = axisTitleStyle;
	y.titleOffset               = 40.0f;
    y.majorIntervalLength       = CPTDecimalFromFloat(60 * 60); // y axis interval = 1 week
    y.minorTicksPerInterval     = 0;
    y.labelTextStyle            = axisTitleStyle;
    y.labelFormatter            = yAxisFormatter;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(0.0);
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot.identifier isEqual:@"Breakfast Plot"]) {
        return [[self.mealsPlotData objectForKey:@"BreakfastData"] count];
    } else if ([plot.identifier isEqual:@"Lunch Plot"]) {
        return [[self.mealsPlotData objectForKey:@"LunchData"] count];
    } else if ([plot.identifier isEqual:@"Dinner Plot"]) {
        return [[self.mealsPlotData objectForKey:@"DinnerData"] count];
    } else if ([plot.identifier isEqual:@"Snack Plot"]) {
        return [[self.mealsPlotData objectForKey:@"SnackData"] count];
    }
    return 0;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *mealKey;
    if ([plot.identifier isEqual:@"Breakfast Plot"]) {
        mealKey = @"BreakfastData";
    } else if ([plot.identifier isEqual:@"Lunch Plot"]) {
        mealKey = @"LunchData";
    } else if ([plot.identifier isEqual:@"Dinner Plot"]) {
        mealKey = @"DinnerData";
    } else if ([plot.identifier isEqual:@"Snack Plot"]) {
        mealKey = @"SnackData";
    }
    
    NSDecimalNumber *num = [[[self.mealsPlotData objectForKey:mealKey] objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    return num;
}

#pragma mark - Date Conversions
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
