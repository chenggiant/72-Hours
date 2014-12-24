//
//  HTDGoalDetailViewController.h
//  72-Hours
//
//  Created by Chi on 10/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDGoalDetailViewController : UITableViewController

@property int goalID;

@property (nonatomic, copy) void (^dismissBlock) (void);

- (IBAction)save:(id)sender;

@end
