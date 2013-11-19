//
//  SYHDataManager.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHDataManager.h"

#define kEntityName @"Meals"

@interface SYHDataManager ()

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStorecoordinator;

@end

@implementation SYHDataManager

- (BOOL) addMealWithData:(SYHMealObject *)newMeal
{
    NSManagedObjectContext *context = self.managedObjectContext;
    Meals *mealToStore = [NSEntityDescription insertNewObjectForEntityForName:kEntityName
                                                                 inManagedObjectContext:context];
    mealToStore.mealTime = newMeal.mealTime;
    mealToStore.meals = newMeal.meals;

    NSError *error;
    if (![context save:&error]) {
        return NO;
    }
    
    // TODO: Continue here and figure out whether this is working or not now that we have implemented date picker.
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MealModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

//create sqlite database
- (NSPersistentStoreCoordinator *)persistentStorecoordinator
{
    if (!_persistentStorecoordinator) {
        NSURL *storeURL = [[self applicationDirectory] URLByAppendingPathComponent:@"Meals.sqlite"];
        
        NSError *error;
        _persistentStorecoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];

        [_persistentStorecoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    return _persistentStorecoordinator;
}

- (NSURL *)applicationDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
}

@end
