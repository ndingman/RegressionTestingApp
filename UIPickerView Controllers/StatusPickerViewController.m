//
//  StatusPickerViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "StatusPickerViewController.h"

@interface StatusPickerViewController ()

@end

@implementation StatusPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        // Custom initialization
        _statusNames = [NSMutableArray array];
        [_statusNames addObject:@"Open"];
        [_statusNames addObject:@"Closed"];
        [_statusNames addObject:@"Testing"];
        [_statusNames addObject:@"Success"];
        [_statusNames addObject:@"Failed"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [_statusNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        CGFloat largestLabelWidth = 0;
        for (NSString *statusName in _statusNames) {
            CGSize labelSize = [statusName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        CGFloat popoverWidth = largestLabelWidth + 100;
        self.preferredContentSize =  CGSizeMake(popoverWidth, totalRowsHeight);
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
return [_statusNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_statusNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *selectedStatusName = [_statusNames objectAtIndex:indexPath.row];
        UIColor *color = [UIColor orangeColor];
        NSString *failedTap = @"Failed Transfer";
    
    if ([selectedStatusName isEqualToString:@"Open"]) {
        color = [UIColor blackColor];
        failedTap = @"Open";
    } else if ([selectedStatusName isEqualToString:@"Closed"]) {
        color = [UIColor blackColor];
        failedTap = @"Closed";
    } else if ([selectedStatusName isEqualToString:@"Testing"]) {
        color = [UIColor blackColor];
        failedTap = @"Testing";
    } else if ([selectedStatusName isEqualToString:@"Success"]) {
        color = [UIColor blackColor];
        failedTap = @"Success";
    } else if ([selectedStatusName isEqualToString:@"Failed"]) {
        color = [UIColor blackColor];
        failedTap = @"Failed";
    }
    
    if (_delegate != nil) {
        [_delegate selectStatusColor:color];
        [_delegate selectedString:failedTap];
    }
    

}

@end
