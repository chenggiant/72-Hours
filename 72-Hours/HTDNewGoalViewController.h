//
//  HTDNewGoalViewController.h
//  72-Hours
//
//  Created by Chi on 9/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTDAction;
@class HTDNewGoalViewController;

@protocol HTDNewGoalViewControllerDelegate <NSObject>
- (void)HTDNewGoalViewControllerDidCancel:(HTDNewGoalViewController *)controller;
- (void)HTDNewGoalViewController:(HTDNewGoalViewController *)controller didAddGoal:(HTDAction *)action;

@end

@interface HTDNewGoalViewController : UITableViewController


@property (nonatomic, weak) id <HTDNewGoalViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *goalTextField;
@property (weak, nonatomic) IBOutlet UITextField *actionTextField;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
