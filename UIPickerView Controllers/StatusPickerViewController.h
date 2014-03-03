//
//  StatusPickerViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusPickerDelegate <NSObject>
@required
-(void)selectStatusColor:(UIColor *)newColor;
-(void)selectedString:(NSString *)newString;
@end

@interface StatusPickerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *statusNames;
@property (nonatomic, weak) id<StatusPickerDelegate> delegate;


@end
