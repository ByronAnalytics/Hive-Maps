//
//  MainTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MainTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>
//@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipGesture;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) NSIndexPath *accIndexPath;
//- (IBAction)swipeToEmail:(UISwipeGestureRecognizer *)sender;

@end
