//
//  SYHDataManager.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHDataManager.h"
#import "SYHSleepManager.h"

#define mealsEntityName @"Meals"
#define sleepEntityName @"Sleeps"

@interface SYHDataManager ()

@property (nonatomic, strong) NSString *dataToBeFetched;

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStorecoordinator;

@end

@implementation SYHDataManager

#pragma mark - Editing and fetching meals
- (BOOL) addMealWithData:(SYHMealObject *)newMeal
{
    _dataToBeFetched = @"Meals";
    NSManagedObjectContext *context = self.managedObjectContext;
    Meals *mealToStore = [NSEntityDescription insertNewObjectForEntityForName:mealsEntityName
                                                                 inManagedObjectContext:context];
    mealToStore.mealTime = newMeal.mealTime;
    mealToStore.meals = newMeal.meals;
    mealToStore.mealType = newMeal.mealType;

    NSError *error;
    if (![context save:&error]) {
        return NO;
    }

    return YES;
}

- (NSArray *) allMeals
{
    _dataToBeFetched = @"Meals";
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:context];
    fetchRequest.entity = entity;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"mealTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedResults = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedResults;
}

-(BOOL) deleteMeal:(Meals *) meal
{
    _dataToBeFetched = @"Meals";
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:meal];
    
    NSError *error;
    if (![context save:&error]){
        //error
        return NO;
    }
    return YES;
}

#pragma mark - Editing and fetching sleeps
- (BOOL) addSleepWithData:(SYHSleepObject *)newSleep
{
    _dataToBeFetched = @"Sleeps";
    NSManagedObjectContext *context = self.managedObjectContext;
    Sleeps *sleepToStore = [NSEntityDescription insertNewObjectForEntityForName:sleepEntityName
                                                       inManagedObjectContext:context];
    sleepToStore.startTime = newSleep.startTime;
    sleepToStore.endTime = newSleep.endTime;
    
    NSError *error;
    if (![context save:&error]) {
        return NO;
    }
    
    return YES;
}

- (NSArray *) allSleeps
{
    _dataToBeFetched = @"Sleeps";
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sleeps" inManagedObjectContext:context];
    fetchRequest.entity = entity;
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error;
    NSArray *fetchedResults = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedResults;
}

-(BOOL) deleteSleep:(Sleeps *)sleep
{
    _dataToBeFetched = @"Sleeps";
    NSManagedObjectContext *context = self.managedObjectContext;
    [context deleteObject:sleep];
    
    NSError *error;
    if (![context save:&error]){
        //error
        return NO;
    }
    return YES;
}



-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStorecoordinator;
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL;
    if ([_dataToBeFetched isEqualToString:@"Meals"]){
        modelURL = [[NSBundle mainBundle] URLForResource:@"MealModel" withExtension:@"momd"];
    } else if ([_dataToBeFetched isEqualToString:@"Sleeps"]){
        modelURL = [[NSBundle mainBundle] URLForResource:@"SleepModel" withExtension:@"momd"];
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

//create sqlite database
- (NSPersistentStoreCoordinator *)persistentStorecoordinator
{
    if (_persistentStorecoordinator != nil) {
        return _persistentStorecoordinator;
    }
    
    NSURL *storeUrl;
    if ([_dataToBeFetched isEqualToString:@"Meals"]){
        storeUrl = [[self applicationDirectory] URLByAppendingPathComponent:@"Meals.sqlite"];
    } else if ([_dataToBeFetched isEqualToString:@"Sleeps"]){
        storeUrl = [[self applicationDirectory] URLByAppendingPathComponent:@"Sleeps.sqlite"];
    }
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
    						 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
    						 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStorecoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStorecoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
        NSLog(@"%@", error);
    }
    
    return _persistentStorecoordinator;
}

- (NSURL *)applicationDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}

//
//
//- (NSArray *) allMealsOfType: (SYHMealType) mealType
//{
//    NSManagedObjectContext *context = self.managedObjectContext;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meals" inManagedObjectContext:context];
//    fetchRequest.entity = entity;
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mealType == %@", mealType];
//    fetchRequest.predicate = predicate;
//    
//    NSError *error;
//    NSArray *fetchedResults = [context executeFetchRequest:fetchRequest error:&error];
//    
//    return fetchedResults;
//}

@end
