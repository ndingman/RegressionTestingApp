//
//  EditProjectViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "EditProjectViewController.h"

@interface EditProjectViewController ()

@end

@implementation EditProjectViewController

- (void)setDetailItem:(Project *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

-(void)configureView{
    self.projectNameTextField.text = self.detailItem.projectname;
    self.buildTextField.text = self.detailItem.build;
    self.ostargetTextField.text = self.detailItem.ostarget;
    self.platformTextField.text = self.detailItem.platform;
    self.updatedateTextField.text = self.detailItem.updatedate;
    self.versionTextField.text = self.detailItem.version;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithProject:(Project *)project completion:(EditProjectsViewControllerCompletionHandler)completionHandlerProject{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _completionHandlerProject = completionHandlerProject;
        _project = project;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
	// Do any additional setup after loading the view.
     self.title = @"Edit Project Information";
    self.view.backgroundColor = [UIColor colorWithRed:0.567 green:0.682 blue:1.000 alpha:1.000];
    UIBarButtonItem *saveNewProjectButton = [[UIBarButtonItem alloc]initWithTitle:@"Save Project" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    [saveNewProjectButton setTintColor:[UIColor colorWithRed:0.567 green:0.682 blue:1.000 alpha:1.000]];
    self.navigationItem.rightBarButtonItem = saveNewProjectButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.projectNameTextField.text = _project.projectname;
    self.buildTextField.text = _project.build;
    self.ostargetTextField.text = _project.ostarget;
    self.platformTextField.text = _project.platform;
    self.updatedateTextField.text = _project.updatedate;
    self.versionTextField.text = _project.version;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pragma mark Data Managed Objects Implementation Methods

+(void)editProject:(Project *)project inNavigationController:(UINavigationController *)navigationController completion:(EditProjectsViewControllerCompletionHandler)completionHandlerProject{
    
    EditProjectViewController *editViewController = [[EditProjectViewController alloc]initWithProject:project completion:completionHandlerProject];
    [navigationController pushViewController:editViewController animated:YES];
}

-(void)done:(id)sender{
    
    //
    NSError *error = nil;
    if (![self.detailItem.managedObjectContext save:&error]) {
        NSLog(@"Core data error %@, %@", error,[error userInfo]);
    }
    
    
    _project.projectname = (self.projectNameTextField.text ? self.projectNameTextField.text: @"Project Name");
    _project.build = (self.buildTextField.text ? self.buildTextField.text: @"Build Number");
    _project.ostarget = (self.ostargetTextField.text ? self.ostargetTextField.text: @"OS Target");
    _project.platform = (self.platformTextField.text ? self.platformTextField.text: @" ");
    _project.updatedate = (self.updatedateTextField.text ? self.updatedateTextField.text: @" ");
    _project.version = (self.versionTextField.text ? self.versionTextField.text: @" ");
   _completionHandlerProject(self, NO);
    //
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)cancel{
    _completionHandlerProject(self, YES);
}

@end
