//
//  AppDelegate.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectViewController.h"
#import <CoreData/CoreData.h>

@class ProjectViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ProjectViewController *projectViewController;

- (void)saveContext;
- (NSString *)applicationDocumentsDirectory;

- (void)mergeiCloudChanges:(NSNotification*)note
                forContext:(NSManagedObjectContext*)moc;

@end
