//
//  ViewController.h
//  72-Hours
//
//  Created by Chi on 2/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTDNewGoalViewController.h"
#import "HTDNextActionViewController.h"
#import "HTDAction.h"

@interface HTDGoalsViewController : UITableViewController <HTDNewGoalViewControllerDelegate, HTDNextActionViewControllerDelegate>

@property (nonatomic, strong) HTDAction *action;


@property (nonatomic) BOOL showRedDot;

@end

