//
//  EditStoriesViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stories.h"
#import "StatusPickerViewController.h"
#import "PassFailPickerViewController.h"
#import "PriorityPickerViewController.h"
#import "FailPassPickerViewController.h"

@class EditStoriesViewController;


typedef void (^EditStoriesViewControllerCompletionHandler)(EditStoriesViewController *sender, BOOL canceled);

@interface EditStoriesViewController : UIViewController <UITextFieldDelegate, StatusPickerDelegate, PassFailPickerDelegate, PriorityPickerDelegate, FailPassPickerDelegate> {
    
    @private
    EditStoriesViewControllerCompletionHandler _completionHandler;
    Stories *_stories;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) StatusPickerViewController *statusPicker;
@property (nonatomic, strong) UIPopoverController *statusPickerPopover;

@property (nonatomic, strong) PassFailPickerViewController *pfPicker;
@property (nonatomic, strong) UIPopoverController *pfPickerPopover;

@property (nonatomic, strong) PriorityPickerViewController *priorityPicker;
@property (nonatomic, strong) UIPopoverController *priorityPickerPopover;

@property (nonatomic, strong) FailPassPickerViewController *failpassPicker;
@property (nonatomic, strong) UIPopoverController *failpassPopover;

@property (weak, nonatomic) IBOutlet UIView *storyTV;
@property (weak, nonatomic) IBOutlet UIView *stepsTV;
@property (weak, nonatomic) IBOutlet UIView *actualTV;
@property (weak, nonatomic) IBOutlet UIView *testingTV;

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UITextField *storynumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;
@property (weak, nonatomic) IBOutlet UITextField *passfailipadTestField;
@property (weak, nonatomic) IBOutlet UITextField *passfailiphoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *bugnumberTextField;
@property (weak, nonatomic) IBOutlet UITextView *storyTextView;
@property (weak, nonatomic) IBOutlet UITextView *stepstoexecuteTextView;
@property (weak, nonatomic) IBOutlet UITextView *actualresultsTextView;
@property (weak, nonatomic) IBOutlet UITextView *testingcommentsTextView;

-(IBAction)chooseStatusButtonTapped:(id)sender;
-(IBAction)choosePFButtonOneTapped:(id)sender;
-(IBAction)choosePriorityButtonTapped:(id)sender;
-(IBAction)chooseFailPassButtonTapped:(id)sender;

- (id)initWithStories:(Stories *)stories completion:(EditStoriesViewControllerCompletionHandler)completionHandler;

+ (void)editStories:(Stories *)stories inNavigationController:(UINavigationController *)navigationController completion:(EditStoriesViewControllerCompletionHandler)completionHandler;

@end
