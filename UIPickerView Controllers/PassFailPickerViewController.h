//
//  PassFailPickerViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/31/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassFailPickerDelegate <NSObject>
@required
-(void)selectPFStatusColorOne:(UIColor *)newColor;
-(void)selectedStringOne:(NSString *)newString;

@end

@interface PassFailPickerViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *pfNames;
@property (nonatomic, weak) id<PassFailPickerDelegate> delegate;

@end
