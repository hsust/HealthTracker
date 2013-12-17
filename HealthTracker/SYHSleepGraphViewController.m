//
//  SYHSleepGraphViewController.m
//  HealthTracker
//
//  Created by Stephanie Hsu on 12/16/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHSleepGraphViewController.h"
#import "SYHDataManager.h"
#import "Sleeps.h"

@interface SYHSleepGraphViewController ()


@property (nonatomic,strong) SYHDataManager *myDataManager;
@property (nonatomic,strong) NSArray *allSleeps;
@property (nonatomic,strong) NSArray *plotData;

@property (nonatomic,strong) NSMutableDictionary *mealsPlotData;
@property (nonatomic, strong) CPTGraphHostingView *hostView;

@property (nonatomic,strong) CPTBarPlot *sleepPlot;


@end

@implementation SYHSleepGraphViewController


- (SYHDataManager *) myDataManager
{
    if (!_myDataManager) {
        _myDataManager = [[SYHDataManager alloc] init];
    }
    return [[SYHDataManager alloc] init];
}

- (NSArray *) allSleeps
{
    if (!_allSleeps) {
        _allSleeps = [self.myDataManager allSleeps];
    }
    return [self.myDataManager allSleeps];
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
                maxFrame.size.height -= kNavigationBarLandscapeHeight;
            }
            else {
                maxFrame.origin.y += kNavigationBarPortraitHeight;
                maxFrame.size.height -= kNavigationBarPortraitHeight;
            }
        }
    }
    
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
    if (![self.allSleeps count]){
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
    // So that the frame/bounds get recalculated on every orientation change
    self.hostView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
    
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
    
    CGFloat yMin = 0.0f;
	CGFloat yMax = 24.0f;  // should determine dynamically based on max pric

    
    // Set up plotspace
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0)
                                                    length:CPTDecimalFromFloat(8 * oneDay)];
 
    
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
    
    // Plot symbols
    CPTPlotSymbol *sleepSymbol = [CPTPlotSymbol trianglePlotSymbol ];
    sleepSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    sleepSymbol.size = CGSizeMake(10.0, 10.0);
    // Set up line style
    CPTMutableLineStyle *lineStyle = nil;
    
    CPTScatterPlot *sleepPlot = [[CPTScatterPlot alloc] init];
    sleepPlot.identifier = @"Sleep Plot";
    sleepPlot.plotSymbol = sleepSymbol;
   
    NSArray *plots = [NSArray arrayWithObjects:sleepPlot, nil];
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
    components.day -= 7;
    NSDate *aWeekAgo = [calendar dateFromComponents:components];
    
    SYHSleepObject *currSleep;
    NSDate *currDate;
    
    NSMutableArray *newData = [NSMutableArray array];

    for ( int i = [self.allSleeps count] - 1; i >= 0; i--) {
        currSleep = [_allSleeps objectAtIndex:i];
        currDate = currSleep.endTime;
        id x = [NSDecimalNumber numberWithDouble:[[self convertToBeginningOfDay:currDate] timeIntervalSinceDate: aWeekAgo]];
        
        NSTimeInterval interval = [currSleep.endTime timeIntervalSinceDate:currSleep.startTime];
        double hours = interval / 3600;             // integer division to get the hours part
        
        NSDecimalNumber *time = [[NSDecimalNumber alloc] initWithDouble:hours];
        
        id y = time;

        NSString *date = [NSString stringWithFormat:@"DATE: %@",x];
        NSLog(@"%@",date);
        // Add some data
        [newData addObject:
             [NSDictionary dictionaryWithObjectsAndKeys: x,
              [NSNumber numberWithInt:CPTScatterPlotFieldX],
              y, [NSNumber numberWithInt:CPTScatterPlotFieldY],
              nil]];
    }
    NSLog(@"New Data %@",newData);
    _plotData = newData;
    
}

-(void)configureAxes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components: NSYearCalendarUnit|NSMonthCalendarUnit|
                                    NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    components.day -= 7;
    NSDate *aWeekAgo = [calendar dateFromComponents:components];
    
    // Axis Title Style
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"HelveticaNeue";
	axisTitleStyle.fontSize = 10.0f;
    
    // Axis Line Style
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    
    // Date and Time Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd"];
    CPTTimeFormatter *xAxisFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
    xAxisFormatter.referenceDate = aWeekAgo;
    
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
	y.title                     = @"Duration";
	y.titleTextStyle            = axisTitleStyle;
	y.titleOffset               = 40.0f;
    y.majorIntervalLength       = CPTDecimalFromFloat(1.0);
    y.minorTicksPerInterval     = 0;
    y.labelTextStyle            = axisTitleStyle;
    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(1.0);
}


#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    NSLog(@"numberOfRecordsForPlot %i", [_plotData count]);
    return [_plotData count];
}


-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{

    NSDecimalNumber *num = [[_plotData objectAtIndex:index] objectForKey:[NSNumber numberWithInt:fieldEnum]];
    NSLog(@"numberforplot %@", num);
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

