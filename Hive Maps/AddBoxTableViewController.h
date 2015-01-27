//
//  AddBoxTableViewController.h
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/4/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBoxTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) NSString *units;
@property (weak, nonatomic) IBOutlet UITextField *boxName;
@property (weak, nonatomic) IBOutlet UITextField *numFramesNewBox;
@property (weak, nonatomic) IBOutlet UITextField *frameWidth;
@property (weak, nonatomic) IBOutlet UITextField *frameHeight;

@end
