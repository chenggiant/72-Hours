//
//  HTDNewGoalViewController.m
//  72-Hours
//
//  Created by Chi on 9/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDNewGoalViewController.h"
#import "HTDGoal.h"
#import "HTDAction.h"

@interface HTDNewGoalViewController () <UITextFieldDelegate>

@end

@implementation HTDNewGoalViewController


- (IBAction)cancel:(id)sender {
    [self.delegate HTDNewGoalViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender {
    HTDAction *action = [[HTDAction alloc] init];
    action.action_name = self.actionTextField.text;
    action.goal_name = self.goalTextField.text;
    action.status = 1;
    action.date_start = [NSDate date];
    [self.delegate HTDNewGoalViewController:self didAddGoal:action];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 10, tableView.frame.size.width, 16);
    
    NSString *text = @"Time left";
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    CGSize stringSize = [text sizeWithAttributes:userAttributes];
    
    UILabel *sideLabel = [[UILabel alloc] init];
    sideLabel.frame = CGRectMake(tableView.frame.size.width - stringSize.width - 10, 10, tableView.frame.size.width-100, 16);
    
    myLabel.font = [UIFont systemFontOfSize:12];
    sideLabel.font = [UIFont systemFontOfSize:12];
    
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.goalTextField becomeFirstResponder];
    } else if (indexPath.section == 1) {
        [self.actionTextField becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goalTextField.delegate = self;
    self.actionTextField.delegate = self;

    // add the observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];
}

// the method to call on a change
- (void)textFieldDidChange:(NSNotification*)aNotification
{
    self.navigationItem.rightBarButtonItem.enabled = [self bothTextFieldsHaveContent];
}

- (BOOL)bothTextFieldsHaveContent {
    return ![self isStringEmptyWithString:self.goalTextField.text] && ![self isStringEmptyWithString:self.actionTextField.text];
}
               
               // a category would be more elegant
- (BOOL)isStringEmptyWithString:(NSString *)aString {
    NSString * temp = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        return [temp isEqual:@""];
}


@end
