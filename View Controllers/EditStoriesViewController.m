//
//  EditStoriesViewController.m
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import "EditStoriesViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

#define kCustomButtonHeight		30.0
#define kViewControllerKey      @"viewController"
#define kTitleKey               @"title"
#define kDetailKey              @"detail text"

@interface EditStoriesViewController () {
     UIColor *defaultTintColor;
//     CGSize pageSize;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;
@property (nonatomic, retain) IBOutlet UIButton *buttonEmail;

@end

@implementation EditStoriesViewController

- (id)initWithStories:(Stories *)stories completion:(EditStoriesViewControllerCompletionHandler)completionHandler{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _completionHandler = completionHandler;
        _stories = stories;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Edit Story Information";

    [_scrollView setScrollEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(768, 1200)];
    
    UIBarButtonItem *saveStoryButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
    [saveStoryButton setTintColor:[UIColor colorWithRed:0.567 green:0.682 blue:1.000 alpha:1.000]];
    self.navigationItem.rightBarButtonItem = saveStoryButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.view.backgroundColor = [UIColor colorWithRed:0.567 green:0.682 blue:1.000 alpha:1.000];
    self.statusTextField.text = _stories.status;
    self.storynumberTextField.text = _stories.storynumber;
    self.priorityTextField.text = _stories.priority;
    self.actualresultsTextView.text = _stories.actualresults;
    self.bugnumberTextField.text = _stories.bugnumber;
    self.passfailipadTestField.text = _stories.passfailipad;
    self.passfailiphoneTextField.text = _stories.passfailiphone;
   // self.storyTextView.text = _stories.storycomments;
    self.testingcommentsTextView.text = _stories.testingcomments;
    self.stepstoexecuteTextView.text = _stories.stepstoexecute;
    
    _storyTV.hidden = NO;
    _stepsTV.hidden = YES;
    _actualTV.hidden = YES;
    _testingTV.hidden = YES;
    
    // segmented control as the custom title view
    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Story", @""),
                                   NSLocalizedString(@"Steps", @""),
                                   NSLocalizedString(@"Results", @""),
                                   NSLocalizedString(@"Comments", @""),
                                   NSLocalizedString(@"Story Report", @""),
                                   nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = CGRectMake(0, 0, 400, kCustomButtonHeight);
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
 
    self.navigationItem.titleView = segmentedControl;

}

- (void)viewWillAppear:(BOOL)animated
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)self.navigationItem.rightBarButtonItem.customView;
    
    // Before we show this view make sure the segmentedControl matches the nav bar style
    if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent || self.navigationController.navigationBar.barStyle == UIBarStyleBlackOpaque)
        segmentedControl.tintColor = [UIColor darkGrayColor];
    else
        segmentedControl.tintColor = defaultTintColor;
}

- (IBAction)segmentAction:(id)sender
{
    // The segmented control was clicked, handle it here
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSLog(@"Segment clicked: %ld", (long)segmentedControl.selectedSegmentIndex);
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        _storyTV.hidden = NO;
        _stepsTV.hidden = YES;
        _actualTV.hidden = YES;
        _testingTV.hidden = YES;
    }
   
    if (segmentedControl.selectedSegmentIndex == 1) {
        _storyTV.hidden = YES;
        _stepsTV.hidden = NO;
        _actualTV.hidden = YES;
         _testingTV.hidden = YES;
    }
    
    if (segmentedControl.selectedSegmentIndex == 2) {
        _storyTV.hidden =YES;
        _actualTV.hidden = NO;
        _stepsTV.hidden = YES;
         _testingTV.hidden = YES;
    }
    
    if (segmentedControl.selectedSegmentIndex == 3) {
        _storyTV.hidden = YES;
        _testingTV.hidden = NO;
        _stepsTV.hidden = YES;
        _actualTV.hidden = YES;
    }
    
    if (segmentedControl.selectedSegmentIndex == 4){
        MFMailComposeViewController *composer=[[MFMailComposeViewController alloc]init];
        [composer setMailComposeDelegate:(id)self];
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:@"EMAIL_ADDRESS_GOES_HERE", nil]];

            [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:composer animated:YES completion:nil];
        }
        else {
            NSLog(@"Message cannot be sent");
        }
        

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pragma mark Data Managed Objects Implementation Methods

+ (void)editStories:(Stories *)stories inNavigationController:(UINavigationController *)navigationController completion:(EditStoriesViewControllerCompletionHandler)completionHandler{
    
    EditStoriesViewController *editViewController = [[EditStoriesViewController alloc]initWithStories:stories completion:completionHandler];
    [navigationController pushViewController:editViewController animated:YES];
}

-(void)done{
    _stories.status = self.statusTextField.text;
    _stories.storynumber = self.storynumberTextField.text;
    _stories.priority = (self.priorityTextField.text ? self.priorityTextField.text:@"");
    _stories.bugnumber = (self.bugnumberTextField.text ? self.bugnumberTextField.text:@"");
    _stories.actualresults = (self.actualresultsTextView.text ? self.actualresultsTextView.text:@"");
    _stories.passfailiphone = (self.passfailiphoneTextField.text ? self.passfailiphoneTextField.text:@"");
    _stories.passfailipad = (self.passfailipadTestField.text ? self.passfailipadTestField.text:@"");
  //  _stories.storycomments = (self.storyTextView.text ? self.storyTextView.text:@"");
    _stories.stepstoexecute = (self.stepstoexecuteTextView.text ? self.stepstoexecuteTextView.text:@"");
    _stories.testingcomments = (self.testingcommentsTextView.text ? self.testingcommentsTextView.text:@"");
    _completionHandler(self, NO);
}

- (void)cancel
{
    _completionHandler(self, YES);
}

-(IBAction)chooseStatusButtonTapped:(id)sender{
    
    if (_statusPicker == nil) {
        _statusPicker = [[StatusPickerViewController alloc]initWithStyle:UITableViewStylePlain];
        _statusPicker.delegate = self;
    }
    
    if (_statusPickerPopover == nil) {
        _statusPickerPopover = [[UIPopoverController alloc]initWithContentViewController:_statusPicker];
        [_statusPickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [_statusPickerPopover dismissPopoverAnimated:YES];
        _statusPickerPopover = nil;
    }
}

-(IBAction)choosePFButtonOneTapped:(id)sender{
    if (_pfPicker == nil) {
        _pfPicker = [[PassFailPickerViewController alloc]initWithStyle:UITableViewStylePlain];
        _pfPicker.delegate = self;
    }
    
    if (_pfPickerPopover == nil) {
        _pfPickerPopover = [[UIPopoverController alloc]initWithContentViewController:_pfPicker];
        [_pfPickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [_pfPickerPopover dismissPopoverAnimated:YES];
        _pfPickerPopover = nil;
    }
}

-(IBAction)choosePriorityButtonTapped:(id)sender{
    if (_priorityPicker == nil) {
        _priorityPicker = [[PriorityPickerViewController alloc]initWithStyle:UITableViewStylePlain];
        _priorityPicker.delegate = self;
    }
    
    if (_priorityPickerPopover == nil) {
        _priorityPickerPopover = [[UIPopoverController alloc]initWithContentViewController:_priorityPicker];
        [_priorityPickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [_priorityPickerPopover dismissPopoverAnimated:YES];
        _priorityPicker.delegate = self;
    }
}


-(IBAction)chooseFailPassButtonTapped:(id)sender{
    if (_failpassPicker == nil) {
        _failpassPicker = [[FailPassPickerViewController alloc]initWithStyle:UITableViewStylePlain];
        _failpassPicker.delegate = self;
    }
    
    if (_failpassPopover == nil) {
        _failpassPopover = [[UIPopoverController alloc]initWithContentViewController:_failpassPicker];
        [_failpassPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        [_failpassPopover dismissPopoverAnimated:YES];
        _failpassPicker.delegate = self;
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"error" message:[NSString stringWithFormat:@"error %@",[error description]] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - StatusPickerDelegate method

-(void)selectStatusColor:(UIColor *)newColor{
    _statusTextField.textColor = newColor;
    
    if (_statusPickerPopover) {
        [_statusPickerPopover dismissPopoverAnimated:YES];
        _statusPickerPopover = nil;
    }
}

-(void)selectedString:(NSString *)newString{
    _statusTextField.text = newString;
    
    if (_statusPickerPopover) {
        [_statusPickerPopover dismissPopoverAnimated:YES];
        _statusPickerPopover = nil;
    }
}

#pragma mark - PassFailPickerDelegate method

-(void)selectPFStatusColorOne:(UIColor *)newColor{
    _passfailipadTestField.textColor = newColor;
    if (_pfPickerPopover) {
        [_pfPickerPopover dismissPopoverAnimated:YES];
        _pfPickerPopover = nil;
    }
}

-(void)selectedStringOne:(NSString *)newString{
    _passfailipadTestField.text = newString;
    
    if (_pfPickerPopover) {
        [_pfPickerPopover dismissPopoverAnimated:YES];
        _pfPickerPopover = nil;
    }
}

#pragma mark - PriorityPickerDelegate method

-(void)selectPriorityColor:(UIColor *)newColor{
    _priorityTextField.textColor = newColor;
    if (_priorityPickerPopover) {
        [_priorityPickerPopover dismissPopoverAnimated:YES];
        _priorityPickerPopover = nil;
    }
}

-(void)selectPriorityString:(NSString *)newString{
    _priorityTextField.text = newString;
    if (_priorityPickerPopover) {
        [_priorityPickerPopover dismissPopoverAnimated:YES];
        _priorityPickerPopover = nil;
    }
}

#pragma mark - FailPassPickerDelegate method

-(void)selectFailPassStatusColor:(UIColor *)newColor{
    _passfailiphoneTextField.textColor = newColor;
    if (_failpassPopover) {
        [_failpassPopover dismissPopoverAnimated:YES];
        _failpassPopover = nil;
    }
}

-(void)selectFailPassString:(NSString *)newString{
    _passfailiphoneTextField.text = newString;
    if (_failpassPopover) {
        [_failpassPopover dismissPopoverAnimated:YES];
        _failpassPopover = nil;
    }
}

@end
