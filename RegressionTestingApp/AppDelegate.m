//
//  AppDelegate.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.projectViewController = [[ProjectViewController alloc]initWithManagedObjectContext:self.managedObjectContext];
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:self.projectViewController];
    self.window.rootViewController = self.navigationController;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    [self.window makeKeyAndVisible];
    
    id currentToken = [[NSFileManager defaultManager]ubiquityIdentityToken];
    if (currentToken) {
        NSLog(@"iCloud access on with id %@", currentToken);
    } else {
        NSLog(@"No iCloud access");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"Core Data error %@, %@", error, [error userInfo]);
    }
}

#pragma mark - Core Data stack

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RegressionTestingApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel: [self managedObjectModel]];
    
    NSPersistentStoreCoordinator* psc = _persistentStoreCoordinator;
	NSString *storePath = [[self applicationDocumentsDirectory]
                           stringByAppendingPathComponent:@"RegressionTestingApp.sqlite"];
    
    // done asynchronously since it may take a while
	// to download preexisting iCloud content
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        
        // building the path to store transaction logs
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *transactionLogsURL = [fileManager
                                     URLForUbiquityContainerIdentifier:nil];
        NSString* coreDataCloudContent = [[transactionLogsURL path]
                                          stringByAppendingPathComponent:@"RegressionTestingApp_data"];
        transactionLogsURL = [NSURL fileURLWithPath:coreDataCloudContent];
        
        //  Building the options array for the coordinator
        NSDictionary* options = [NSDictionary
                                 dictionaryWithObjectsAndKeys:
                                 @"comneildingmancoredata.notes",
                                 NSPersistentStoreUbiquitousContentNameKey,
                                 transactionLogsURL,
                                 NSPersistentStoreUbiquitousContentURLKey,
                                 [NSNumber numberWithBool:YES],
                                 NSMigratePersistentStoresAutomaticallyOption,
                                 nil];
        
        
        NSError *error = nil;
        
        [psc lock];
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeUrl
                                     options:options
                                       error:&error]) {
            
            NSLog(@"Core data error %@, %@", error, [error userInfo]);
            
	    }
        
        [psc unlock];
        
        // post a notification to tell the main thread
	    // to refresh the user interface
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"persistent store added correctly");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"comneildingmanrefetchNotes"
             object:self
             userInfo:nil];
        });
    });
    
    return _persistentStoreCoordinator;
    
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
        
    }
    
    NSPersistentStoreCoordinator *coordinator =
    [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        // choose a concurrency type for the context
        NSManagedObjectContext* moc =
        [[NSManagedObjectContext alloc]
         initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            // configure context properties
            [moc setPersistentStoreCoordinator: coordinator];
            
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(mergeChangesFrom_iCloud:)
             name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
             object:coordinator];
            
        }];
        _managedObjectContext = moc;
    }
    
    return _managedObjectContext;
    
}

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
    
    NSManagedObjectContext* moc = [self managedObjectContext];
    
    [moc performBlock:^{
        [self mergeiCloudChanges:notification
                      forContext:moc];
    }];
    
}

//
- (void)mergeiCloudChanges:(NSNotification*)note
                forContext:(NSManagedObjectContext*)moc {
    
    [moc mergeChangesFromContextDidSaveNotification:note];
    //Refresh view with no fetch controller if any
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
