//
//  SYHDataManager.m
//  HealthTracker
//
//  Created by User on 11/11/13.
//  Copyright (c) 2013 Stephanie Hsu. All rights reserved.
//

#import "SYHDataManager.h"
#import "SYHMealObject.h"

@implementation SYHDataManager

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
