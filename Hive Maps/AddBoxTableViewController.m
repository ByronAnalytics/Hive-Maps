//
//  AddBoxTableViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "AddBoxTableViewController.h"
#import "BoxData.h"
#import "AppDelegate.h"

@interface AddBoxTableViewController ()

  @property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
  - (IBAction)indexChanged:(UISegmentedControl *)sender;

@end

@implementation AddBoxTableViewController

  @synthesize managedObjectContext = _managedObjectContext;

  @synthesize units;
  @synthesize boxName;
  @synthesize numFramesNewBox;
  @synthesize frameWidth;
  @synthesize frameHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Dismiss Keyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    NSString *messageText = @"Standard Comercial and common DIY hive boxes are built in for your use. Add a custom box only if your size isn't represented. \n If you need a custom box, include accurate dimensions for your box so that comparisons between your setup and the bee keeping community are as accurate as possible.\n ALL VALUES ARE CRITICAL\n For more info see:\n hivemapers.com/BoxSetup";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATTENTION!!!"
                                                    message:messageText
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];  //add link-out button for website
   /*
    NSArray *subviewArray = alert.subviews;
    for(int x = 0; x < [subviewArray count]; x++){
        
        if([[[subviewArray objectAtIndex:x] class] isSubclassOfClass:[UILabel class]]) {
            UILabel *label = [subviewArray objectAtIndex:x];
            label.textAlignment = NSTextAlignmentLeft;
        }
    }
    */
    
    [alert show];
    
    //email Bug Report
    UISwipeGestureRecognizer *swipeRightForEmail = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToEmail:)];
    swipeRightForEmail.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightForEmail.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:swipeRightForEmail];

}

- (void) hideKeyboard {
    [boxName resignFirstResponder];
    [numFramesNewBox resignFirstResponder];
    [frameHeight resignFirstResponder];
    [frameWidth resignFirstResponder];
}


// link out function for warning
- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ByronAnalytics.com"]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
    
}


-(IBAction)indexChanged:(UISegmentedControl *)sender{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            units = @"in";
            NSLog(@"Inches Selected");
            break;
            
        case 1:
            units = @"cm";
            NSLog(@"Cm Selected");
            break;
            
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBox:(id)sender {
    
    BoxData *boxData = (BoxData *) [NSEntityDescription insertNewObjectForEntityForName:@"BoxData" inManagedObjectContext:_managedObjectContext];
    
    boxData.nameBoxType = boxName.text;
    boxData.numFrames = [NSNumber numberWithInteger:[numFramesNewBox.text integerValue]];
    
    if ([units isEqualToString:@"in"]) {
        boxData.frameHeight = [NSNumber numberWithFloat:[frameHeight.text floatValue]];
        boxData.frameWidth = [NSNumber numberWithFloat:[frameWidth.text floatValue]];
        NSLog(@"Entered as inches/inputed values");
        
    } else {
        //Store values in inches, 2.54 cm per inch
        float tempHeight = [frameHeight.text floatValue] / 2.54;
        float tempWidth = [frameWidth.text floatValue] / 2.54;
        
        boxData.frameHeight = [NSNumber numberWithFloat:tempHeight];
        boxData.frameWidth = [NSNumber numberWithFloat:tempWidth];
        NSLog(@"Width: %f; inputed Width: %@", tempWidth, frameWidth.text);
        
    }
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        //Handle the error.
        NSLog(@"%@", boxData);
    }
    
    boxName.text = nil;
    numFramesNewBox.text = nil;
    frameWidth.text = nil;
    frameHeight.text = nil;
    
    [self performSegueWithIdentifier:@"unwindToAddHive" sender:self];
}

#pragma mark ----------- Email Bug Report -----------
- (void)swipeToEmail:(UISwipeGestureRecognizer *)sender {
    NSString *viewString = @"Custom Box";
    
    // Email Subject
    NSString *emailTitle = @"Hive Maps Bug Report to Developer";
    // Email Content
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *deviceType = [UIDevice currentDevice].model;
    NSString *messageBody = [NSString stringWithFormat:@"Describe the Bug:\n\nwhat were you doing:\n\nWhat happened?\n\nAny additional information\n\n\n\n---------system info------------\niOS: %@, Device: %@\nCurrent View:%@",currSysVer, deviceType, viewString];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"kwbyron@byronanalytics.com"];
    NSArray *ccRecipents = [NSArray arrayWithObject:@"quentinalexander2000@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    [mc setCcRecipients:ccRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
