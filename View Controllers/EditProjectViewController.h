//
//  EditProjectViewController.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@class EditProjectViewController;

typedef void (^EditProjectsViewControllerCompletionHandler)(EditProjectViewController *sender, BOOL canceled);

@interface EditProjectViewController : UIViewController <UITextFieldDelegate> {
    
    @private
    EditProjectsViewControllerCompletionHandler _completionHandlerProject;
    Project *_project;
}

@property (nonatomic, retain) NSManagedObject *projects;
@property (nonatomic, retain) NSManagedObject *stories;

@property (strong, nonatomic)Project *detailItem;

@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *buildTextField;
@property (weak, nonatomic) IBOutlet UITextField *updatedateTextField;
@property (weak, nonatomic) IBOutlet UITextField *ostargetTextField;
@property (weak, nonatomic) IBOutlet UITextField *versionTextField;
@property (weak, nonatomic) IBOutlet UITextField *platformTextField;

-(id)initWithProject:(Project *)project completion:(EditProjectsViewControllerCompletionHandler)completionHandlerProject;

+(void)editProject:(Project *)project inNavigationController:(UINavigationController *)navigationController completion:(EditProjectsViewControllerCompletionHandler)completionHandlerProject;

@end
