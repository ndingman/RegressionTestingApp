//
//  ProjectViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "ProjectViewController.h"
#import "StoriesViewController.h"
#import "EditProjectViewController.h"


@interface ProjectViewController ()

@end

@implementation ProjectViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize detailViewController;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.managedObjectContext = context;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
   // [self fetchProjects];
    [self fetchedResultsController];
    [self.tableView reloadData];
    
}

- (NSFetchedResultsController *)fetchedResultsController{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    //Create a fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    //Create an entity description for the entity to be fetched.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
    
    //Assign the entity description to the request.
    [fetchRequest setEntity:entity];
    
    //Create a sort descriptor tospecify how the results should be sorted.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"projectname" ascending:YES];
    
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    //Assign the sort descriptor to the request.
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    //Create a fetched results controller with the fetch request and the context.
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    //Perform a fetch request to retrieve the data!
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    NSLog(@"something has changed");
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Regression Testing Projects";
    UIBarButtonItem *newEventButton = [[UIBarButtonItem alloc]initWithTitle:@"New Project" style:UIBarButtonItemStyleBordered target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = newEventButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationController.toolbarHidden=NO;

   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadNotes) name:@"comneildingmanrefetchNotes" object:nil];

}

- (void)reloadNotes{
    
    NSLog(@"refetching notes");
    NSError *error = nil;
    
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
    } else {
        NSLog(@"reloadNotes - results are %lu", (unsigned long)self.fetchedResultsController.fetchedObjects.count);
        [self.tableView reloadData];
    }
}

-(void)add{
    
    Project *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    // [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
    
    NSString *noteTitle = [NSString stringWithFormat:@"Note %@",
                           [formatter stringFromDate:[NSDate date]]];
    
    newNote.projectname = noteTitle;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Core Data error %@, %@", error, [error userInfo]);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController
                                      objectAtIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Project *project = (Project *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    NSString *test;
    test = [NSString stringWithFormat:@"%@", project.projectname];
    cell.textLabel.font = [UIFont systemFontOfSize:25.0];
    cell.textLabel.text = [managedObject valueForKey:@"projectname"];
    // cell.textLabel.text = test;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Stories (%lu)",  (unsigned long)project.stories.count];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:25.0];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        Project *n = (Project *)[self.fetchedResultsController
                               objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = n;
        
    }
    
   Project *project = (Project *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [EditProjectViewController editProject:project inNavigationController:self.navigationController completion:
     ^(EditProjectViewController *sender, BOOL canceled)
     {
         NSError *error;
         if (![self.managedObjectContext save:&error])
         {
             NSLog(@"Error saving context: %@", error);
         }
         
         [self.tableView reloadData];
         [self.navigationController popViewControllerAnimated:YES];
     }]; 
    
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Project *project = (Project *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    StoriesViewController *detailStorieslViewController = [[StoriesViewController alloc]initWithProject:project];
    [self.navigationController pushViewController:detailStorieslViewController animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
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
                                 @"comneildingmancoredatanotes",
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

- (void)saveContext
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"Core Data error %@, %@", error, [error userInfo]);
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}




@end
