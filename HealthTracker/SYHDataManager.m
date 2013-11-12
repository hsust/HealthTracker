//
//  SYHDataManager.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHDataManager.h"


@interface SYHDataManager ()

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStorecoordinator;

@end

@implementation SYHDataManager

- (BOOL) addMealWithData:(SYHMealObject *)newMeal
{
    NSManagedObjectContext *context = self.managedObjectContext;
    SYHMealObject *newMealObject = [NSEntityDescription insertNewObjectForEntityForName:@"MyMeal" inManagedObjectContext:context];
    [newMealObject setValue:newMealObject.mealTime forKey:@"MealTime"];
    [newMealObject setValue:newMealObject.meals forKey:@"Meals"];

    NSError *error;
    if (![context save:&error]) {
        return NO;
    }
    
    // TODO: Continue here and figure out whether this is working or not now that we have implemented date picker.
    NSLog(@"Added in meal with data");
    return YES;
}

//- (NSArray *) allMeals
//{
//    
//}

-(NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStorecoordinator;
    }
    return _managedObjectContext;
}

//create data model in GUI. this is what data is supposed to look like
- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        //grab data from app and load into model
        NSURL *storeURL = [[NSBundle mainBundle] URLForResource:@"UserModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
    }
    return _managedObjectModel;
}

//create sqlite database
- (NSPersistentStoreCoordinator *)persistentStorecoordinator
{
    if (!_persistentStorecoordinator) {
        NSURL *storeURL = [[self applicationDirectory] URLByAppendingPathComponent:@"Users.sqlite"];
        
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
