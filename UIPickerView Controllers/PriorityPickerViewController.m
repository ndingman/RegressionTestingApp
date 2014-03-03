//
//  PriorityPickerViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "PriorityPickerViewController.h"

@interface PriorityPickerViewController ()

@end

@implementation PriorityPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        // Custom initialization
        _priorityNames = [NSMutableArray array];
        [_priorityNames addObject:@"Critical"];
        [_priorityNames addObject:@"Important"];
        [_priorityNames addObject:@"Useful"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [_priorityNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        CGFloat largestLabelWidth = 0;
        for (NSString *priorityName in _priorityNames) {
            CGSize labelSize = [priorityName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        CGFloat popoverWidth = largestLabelWidth + 100;
        self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [_priorityNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = [_priorityNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedPriorityName = [_priorityNames objectAtIndex:indexPath.row];
    UIColor *color = [UIColor orangeColor];
    NSString *failedTap = @"Failed Transfer";
    
    if ([selectedPriorityName isEqualToString:@"Critical"]) {
         color = [UIColor blackColor];
         failedTap = @"Critical";
    } else if ([selectedPriorityName isEqualToString:@"Important"]) {
         color = [UIColor blackColor];
         failedTap = @"Important";
    }  else if ([selectedPriorityName isEqualToString:@"Useful"]) {
         color = [UIColor blackColor];
         failedTap = @"Useful";
    }
    
    if (_delegate != nil) {
        [_delegate selectPriorityColor:color];
        [_delegate selectPriorityString:failedTap];
    }
}

@end
