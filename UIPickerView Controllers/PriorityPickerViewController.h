//
//  PriorityPickerViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PriorityPickerDelegate <NSObject>
@required
-(void)selectPriorityColor:(UIColor *)newColor;
-(void)selectPriorityString:(NSString *)newString;
@end

@interface PriorityPickerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *priorityNames;
@property (nonatomic, weak) id<PriorityPickerDelegate>delegate;

@end
