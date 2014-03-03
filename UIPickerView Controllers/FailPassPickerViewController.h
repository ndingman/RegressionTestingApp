//
//  FailPassPickerViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FailPassPickerDelegate <NSObject>
@required
-(void)selectFailPassStatusColor:(UIColor *)newColor;
-(void)selectFailPassString:(NSString *)newString;

@end

@interface FailPassPickerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *priorityNames;
@property (nonatomic, weak) id<FailPassPickerDelegate> delegate;

@end
