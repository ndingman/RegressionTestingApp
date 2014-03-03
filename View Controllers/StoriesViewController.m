//
//  StoriesViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "StoriesViewController.h"

@interface StoriesViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation StoriesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithProject:(Project *)project{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self)
    {
        self.project = project;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *newAttendeeButton = [[UIBarButtonItem alloc]initWithTitle:@"Add Story" style:UIBarButtonItemStyleBordered target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = newAttendeeButton;
    self.title = @"Stories";
    self.navigationController.toolbarHidden=NO;
}

- (void)add{
  
  NSEntityDescription *storiesEntityDescription = [NSEntityDescription entityForName:@"Stories" inManagedObjectContext:self.project.managedObjectContext];
    
    Stories *newStory = (Stories *)[[NSManagedObject alloc]initWithEntity:storiesEntityDescription insertIntoManagedObjectContext:self.project.managedObjectContext];
 
    [EditStoriesViewController editStories:newStory inNavigationController:self.navigationController completion:
     ^(EditStoriesViewController *sender, BOOL canceled)
     {
         if (canceled)
         {
             [self.project.managedObjectContext deleteObject:newStory];
         }
         else
         {
             [self.project addStoriesObject:newStory];
             
             NSError *error;
             if (![self.project.managedObjectContext save:&error])
             {
                 NSLog(@"Error saving context: %@", error);
             }
             [self.tableView reloadData];
         }
         [self.navigationController popViewControllerAnimated:YES];}];
  
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
    return self.project.stories.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"StoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    Stories *statusStories = [self.project.stories.allObjects objectAtIndex:indexPath.row];
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 43)];
    statusLabel.backgroundColor = [UIColor clearColor];
    NSString *statusText;
    statusText = [NSString stringWithFormat:@"%@", statusStories.status];
    statusLabel.text = statusText;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont systemFontOfSize:25.0];
    if ([[NSString stringWithFormat:@"%@", statusStories.status]isEqualToString:@"Open"]) {
        statusLabel.backgroundColor = [UIColor greenColor];
    }
    if ([[NSString stringWithFormat:@"%@", statusStories.status]isEqualToString:@"Closed"]) {
        statusLabel.backgroundColor = [UIColor grayColor];
    }
    if ([[NSString stringWithFormat:@"%@", statusStories.status]isEqualToString:@"Testing"]) {
        statusLabel.backgroundColor = [UIColor yellowColor];
    }
    if ([[NSString stringWithFormat:@"%@", statusStories.status]isEqualToString:@"Success"]) {
        statusLabel.backgroundColor = [UIColor colorWithRed:0.567 green:0.682 blue:1.000 alpha:1.000];
    }
    if ([[NSString stringWithFormat:@"%@", statusStories.status]isEqualToString:@"Failed"]) {
        statusLabel.backgroundColor = [UIColor redColor];
    }
    [cell addSubview:statusLabel];
    
    Stories *priorityStories = [self.project.stories.allObjects objectAtIndex:indexPath.row];
    UILabel *priorityLabel = [[UILabel alloc]initWithFrame:CGRectMake(101, 0, 137, 43)];
    priorityLabel.backgroundColor = [UIColor clearColor];
    NSString *priorityText;
    priorityText = [NSString stringWithFormat:@"%@", priorityStories.priority];
    priorityLabel.text = priorityText;
    priorityLabel.textColor = [UIColor whiteColor];
    priorityLabel.font = [UIFont systemFontOfSize:25.0];
    if ([[NSString stringWithFormat:@"%@", priorityStories.priority]isEqualToString:@"Critical"]) {
        priorityLabel.backgroundColor = [UIColor colorWithRed:0.841 green:0.000 blue:0.009 alpha:1.000];
    }
    if ([[NSString stringWithFormat:@"%@", priorityStories.priority]isEqualToString:@"Important"]) {
        priorityLabel.backgroundColor = [UIColor colorWithRed:0.349 green:0.488 blue:1.000 alpha:1.000];
    }
    if ([[NSString stringWithFormat:@"%@", priorityStories.priority]isEqualToString:@"Useful"]) {
        priorityLabel.backgroundColor = [UIColor colorWithRed:0.690 green:0.637 blue:1.000 alpha:1.000];
    }
    [cell addSubview:priorityLabel];
    
    Stories *storynumberStories = [self.project.stories.allObjects objectAtIndex:indexPath.row];
    UILabel *storyNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(239, 0, 259, 43)];
    storyNumberLabel.backgroundColor = [UIColor clearColor];
    NSString *storynumberText;
    storynumberText = [NSString stringWithFormat:@"Story: %@", storynumberStories.storynumber];
    storyNumberLabel.text = storynumberText;
    storyNumberLabel.textColor = [UIColor whiteColor];
    storyNumberLabel.font = [UIFont systemFontOfSize:25.0];
    storyNumberLabel.backgroundColor = [UIColor colorWithRed:0.422 green:0.761 blue:0.506 alpha:1.000];
    [cell addSubview:storyNumberLabel];
    
    Stories *bugnumberStories = [self.project.stories.allObjects objectAtIndex:indexPath.row];
    UILabel *bugNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(500, 0, 260, 43)];
    bugNumberLabel.backgroundColor = [UIColor clearColor];
    NSString *bugnumberText;
    bugnumberText = [NSString stringWithFormat:@"Bug: %@", bugnumberStories.bugnumber];
    bugNumberLabel.text = bugnumberText;
    bugNumberLabel.textColor = [UIColor whiteColor];
    bugNumberLabel.font = [UIFont systemFontOfSize:25.0];
    bugNumberLabel.backgroundColor = [UIColor colorWithRed:0.422 green:0.761 blue:0.506 alpha:1.000];
    [cell addSubview:bugNumberLabel];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Stories *stories = [self.project.stories.allObjects objectAtIndex:indexPath.row];
    [EditStoriesViewController editStories:stories inNavigationController:self.navigationController completion:^(EditStoriesViewController *sender, BOOL canceled) {
    
        NSError *error;
        if (![self.project.managedObjectContext save:&error]) {
            NSLog(@"Error saving context: %@", error);
        }
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        Stories *deleted = [self.project.stories.allObjects objectAtIndex:indexPath.row];
        [self.project.managedObjectContext deleteObject:deleted];
        NSError *error;
        BOOL success = [self.project.managedObjectContext save:&error];
        if (!success) {
            NSLog(@"Error saving contect: %@", error);
        }
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

@end
