//
//  PassFailPickerViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "PassFailPickerViewController.h"

@interface PassFailPickerViewController ()

@end

@implementation PassFailPickerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style] != nil) {
        // Custom initialization
        _pfNames = [NSMutableArray array];
        [_pfNames addObject:@"Passed"];
        [_pfNames addObject:@"Failed"];
               
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [_pfNames count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        CGFloat largestLabelWidth = 0;
        for (NSString *statusName in _pfNames) {
            CGSize labelSize = [statusName sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        CGFloat popoverWidth = largestLabelWidth + 100;
        self.preferredContentSize= CGSizeMake(popoverWidth, totalRowsHeight);
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
    return [_pfNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [_pfNames objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedPFName = [_pfNames objectAtIndex:indexPath.row];
    UIColor *color = [UIColor orangeColor];
    NSString *failedTap = @"Failed Transfer";
    
    if ([selectedPFName isEqualToString:@"Passed"]) {
        color = [UIColor blackColor];
        failedTap = @"Passed";
    } else if ([selectedPFName isEqualToString:@"Failed"]) {
        color = [UIColor blackColor];
        failedTap = @"Failed";
    }
    
    if (_delegate != nil) {
        
        [_delegate selectPFStatusColorOne:color];
        [_delegate selectedStringOne:failedTap];
    }
}

@end
