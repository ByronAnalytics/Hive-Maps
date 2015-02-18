//
//  HiveBoxesTableViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/19/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "HiveBoxesTableViewController.h"
#import "AddHiveTableViewController.h"
#import "AppDelegate.h"

@interface HiveBoxesTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSSet *boxes;

@property (strong, nonatomic) NSArray *boxID;

@end

@implementation HiveBoxesTableViewController
@synthesize hive;
@synthesize boxes;
@synthesize boxID;


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   _managedObjectContext = [appDelegate managedObjectContext];
   
    //email Bug Report
    UISwipeGestureRecognizer *swipeRightForEmail = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToEmail:)];
    swipeRightForEmail.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightForEmail.numberOfTouchesRequired = 2;
    [self.tableView addGestureRecognizer:swipeRightForEmail];

}

-(void) viewDidAppear:(BOOL)animated{
    [self getTableData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getTableData{
    boxes = hive.hiveBoxes;
    
    NSLog(@"Boxes: %@", boxes);
    
    NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"boxID" ascending:YES]];
    boxID = [boxes sortedArrayUsingDescriptors:sort];
    
    NSLog(@"Box ID array: %@", boxID);
    
    
    
    [self.tableView reloadData];
   
}


#pragma mark - Table view data source

//Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

//Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return boxID.count;
    
}

//Customize cell
-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.textLabel.text = [boxID objectAtIndex:indexPath.row];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"boxCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //configure cell
    HiveBox *info = [boxID objectAtIndex:indexPath.row];
    cell.textLabel.text = info.boxID;
    cell.detailTextLabel.text = info.boxType;
    
    return cell;
    
}

#pragma mark ------------------------------ editing ----------------------------------------------------------
// Disable Re-Order
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

//Delete Hive implimentation
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the managed object.
       // NSManagedObjectContext *context = _managedObjectContext;
        [_managedObjectContext deleteObject:[boxID objectAtIndex:indexPath.row]];
        NSLog(@"obj deleted");
        
        NSError *error = nil;
        if (![_managedObjectContext save:&error]) {
 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
           abort();
        }
        
        [self getTableData];
    }
        
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"addBoxSegue"]){
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        AddHiveTableViewController *addHiveTVC = (AddHiveTableViewController *)[navController topViewController];
        addHiveTVC.sourceVC = @"addBoxSegue";
        addHiveTVC.hive = hive;

    } else if ([[segue identifier] isEqualToString:@"editBoxSegue"]) {
        // Hive Detail View
        NSIndexPath *indexPath =  [self.tableView indexPathForCell:sender];
        HiveBox *selectedBox = (HiveBox *)[boxID objectAtIndex:indexPath.row];
        
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        AddHiveTableViewController *addHiveTVC = (AddHiveTableViewController *)[navController topViewController];
        addHiveTVC.sourceVC = @"editBoxSegue";
        addHiveTVC.hive = hive;
        addHiveTVC.box = selectedBox;
    }

}

- (IBAction)unwindToBoxDetails:(UIStoryboardSegue *)segue{
    
}


#pragma mark ----------- Email Bug Report -----------
- (void)swipeToEmail:(UISwipeGestureRecognizer *)sender {
    NSString *viewString = @"Hive Boxes TV";
    
    // Email Subject
    NSString *emailTitle = @"Hive Maps Bug Report to Developer";
    // Email Content
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    NSString *deviceType = [UIDevice currentDevice].model;
    NSString *appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *versionBuildString = [NSString stringWithFormat:@"Version: %@ (%@)", appVersionString, appBuildString];
    
    NSString *messageBody = [NSString stringWithFormat:@"Describe the Bug:\n\nwhat were you doing:\n\nWhat happened?\n\nAny additional information\n\n\n\n---------system info------------\nApp %@\niOS: %@, Device: %@\nCurrent View: %@",versionBuildString, currSysVer, deviceType, viewString];
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
