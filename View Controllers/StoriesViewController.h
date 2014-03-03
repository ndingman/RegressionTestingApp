//
//  StoriesViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Stories.h"
#import "EditStoriesViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface StoriesViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Project *project;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(id)initWithProject:(Project *)project;

@end
