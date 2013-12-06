//
//  SYHMealsGraphViewController.m
//  HealthTracker
//
//  Created by User on 11/29/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//
#import "SYHMealsGraphViewController.h"
#import "SYHDataManager.h"
#import "Meals.h"

@interface SYHMealsGraphViewController ()
@property (nonatomic,strong) SYHDataManager *myDataManager;
@property (nonatomic,strong) NSArray *allMeals;
@property (nonatomic,strong) NSArray *plotData;

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
    NSLog(@"%@", NSStringFromCGRect(maxFrame));
    return maxFrame;
}

- (void)setupAndShowGraph
{
    NSDate *today = [NSDate date];
    NSDate *startDate = [[self.allMeals objectAtIndex:0] valueForKey:@"mealTime"];
    NSTimeInterval oneDay = 24 * 60 * 60;
    NSTimeInterval oneHour = 60 * 60;
    
    // Graph Theme
    CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    
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
    xAxisFormatter.referenceDate = startDate;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h a"];
    CPTTimeFormatter *yAxisFormatter    = [[CPTTimeFormatter alloc] initWithDateFormatter:timeFormatter];
    yAxisFormatter.referenceDate        = [timeFormatter dateFromString:@"12:00 am"];
    
    
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    CGRect hostViewFrame = [self maximumUsableFrame];
    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame: hostViewFrame];
    hostView.allowPinchScaling = YES;
    [self.view addSubview: hostView];
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    [graph applyTheme:theme];
    
    //Setup title
//    NSString *title = @"Food Consumption";
//    graph.title = title;
//    graph.titleTextStyle = graphTitleStyle;
//    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
//    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);

    // Axis offsets
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:20.0f];
    
    // Setup scatter plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:startDate
                                                 toDate:today
                                                options:0];
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(7 * oneDay)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(oneDay)];
    
    // Axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.axisConstraints   = [CPTConstraints constraintWithLowerOffset:30];
    axisSet.yAxis.axisConstraints   = [CPTConstraints constraintWithLowerOffset:30];
    
    CPTXYAxis *x                  = axisSet.xAxis;
    x.title                     = @"Date";
    x.titleTextStyle            = axisTitleStyle;
    x.titleOffset               = 30.0f;
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
    dataSourceLinePlot.identifier = @"Date Plot";
    
    CPTMutableLineStyle *lineStyle = [dataSourceLinePlot.dataLineStyle mutableCopy];
    lineStyle.lineWidth              = 2.0f;
    lineStyle.lineColor              = [CPTColor greenColor];
    dataSourceLinePlot.dataLineStyle = lineStyle;
    
    dataSourceLinePlot.dataSource = self;
    [graph addPlot:dataSourceLinePlot];
    
    CPTPlotSymbol *whiteCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    whiteCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    whiteCirclePlotSymbol.size = CGSizeMake(5.0, 5.0);
    dataSourceLinePlot.plotSymbol = whiteCirclePlotSymbol;
    
    // add plot to graph
    [graph addPlot:dataSourceLinePlot];
    
    // Add some data
    NSMutableArray *graphData = [NSMutableArray array];
    NSUInteger i;
    NSString *timeString = [timeFormatter stringFromDate:[[_allMeals objectAtIndex:0] valueForKey:@"mealTime"]];
    NSDate *testDate = [timeFormatter dateFromString:timeString];
    NSLog(@"test date: %@, %g", testDate, [testDate timeIntervalSince1970]);
    for ( i = 0; i < 5; i++ ) {
        timeString = [timeFormatter stringFromDate:[[_allMeals objectAtIndex:0] valueForKey:@"mealTime"]];
        id y = [NSDecimalNumber numberWithDouble:[[timeFormatter dateFromString:timeString] timeIntervalSince1970]];
        NSTimeInterval x = oneDay * i;
        [graphData addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSDecimalNumber numberWithFloat:x],
                              [NSNumber numberWithInt:CPTScatterPlotFieldX],
                              y,
                              [NSNumber numberWithInt:CPTScatterPlotFieldY],
                              nil]];
        
//        NSTimeInterval x = oneDay * i;
//        id y             = [NSDecimalNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
//        [graphData addObject:[NSDictionary dictionaryWithObjectsAndKeys:
//                            [NSDecimalNumber numberWithFloat:x],
//                            [NSNumber numberWithInt:CPTScatterPlotFieldX],
//                            y,
//                            [NSNumber numberWithInt:CPTScatterPlotFieldY],
//                            nil]];
    }
    _plotData = graphData;
    
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _plotData.count;
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = [[_plotData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    
    NSString *string = [NSString stringWithFormat:@"%g", [num doubleValue]];
    NSLog(@"Number is %@",string);
    return num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end