//
//  MultiHivePlotViewController.m
//  Hive Maps
//
//  Created by Byron Analytics LLC on 1/8/15.
//  Copyright (c) 2015 HiveMaps. All rights reserved.
//

#import "MultiHivePlotViewController.h"

@interface MultiHivePlotViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MultiHivePlotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.plotElementsTV.hidden = YES;
    
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
