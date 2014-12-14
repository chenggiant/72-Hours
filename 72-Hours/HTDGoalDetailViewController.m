//
//  HTDGoalDetailViewController.m
//  72-Hours
//
//  Created by Chi on 10/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDGoalDetailViewController.h"
#import "HTDGoalsViewController.h"
#import "HTDActionCell.h"
#import "HTDDatabase.h"

@interface HTDGoalDetailViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *txtField;
@property NSArray *actionsOfGoal;

@end

@implementation HTDGoalDetailViewController


- (IBAction)save:(id)sender {
    // Update database with new next action
    HTDAction *newAction  = [[HTDAction alloc] init];
    newAction = self.actionsOfGoal[0];
    newAction.action_name = self.txtField.text;
    
    [[[HTDDatabase alloc] init] updateNextActionName:newAction];
    
//    [self dismissViewControllerAnimated:YES completion:self.dismissBlock];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = 1;
            break;
        case 1:
            rows = [self.actionsOfGoal count] - 1;
            break;
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDActionCell" forIndexPath:indexPath];
    
    HTDAction *action = [[HTDAction alloc] init];    
    
    if (indexPath.section == 0) {
        action = self.actionsOfGoal[0];
        cell.actionNameLabel.text = @"";
        self.txtField.text = action.action_name;
        [cell addSubview:self.txtField];
        
        
        NSDate *today = [NSDate date];
        NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:action.date_start];
        double secondsInAnHour = 3600;
        int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        cell.timeSpentLabel.text = [NSString stringWithFormat:@"%d", (72-hoursBetweenDates)];
        
    } else {
        action = self.actionsOfGoal[indexPath.row + 1];
        cell.actionNameLabel.text = action.action_name;
    
        NSTimeInterval distanceBetweenDates = [action.date_end timeIntervalSinceDate:action.    date_start];
        double secondsInAnHour = 3600;
        int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
        cell.timeSpentLabel.text = [NSString stringWithFormat:@"%d", hoursBetweenDates];
    }
    
    
    cell.timeSpentLabel.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y - cell.timeSpentLabel.frame.size.height, cell.imageView.frame.size.width, cell.timeSpentLabel.frame.size.height);
    cell.timeSpentLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 10, tableView.frame.size.width, 16);
    
    NSString *textSection0 = @"Hours left";
    NSString *textSection1 = @"Hours spent";

    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGSize stringSection0 = [textSection0 sizeWithAttributes:userAttributes];
    CGSize stringSection1 = [textSection1 sizeWithAttributes:userAttributes];

    
    UILabel *sideLabel = [[UILabel alloc] init];

    
    myLabel.font = [UIFont systemFontOfSize:12];
    sideLabel.font = [UIFont systemFontOfSize:12];
    
    switch (section) {
        case 0:
            myLabel.text = @"Next action";
            sideLabel.text = @"Hours left";
            sideLabel.frame = CGRectMake(tableView.frame.size.width - stringSection0.width - 10, 10, tableView.frame.size.width - 100, 16);
            break;
        case 1:
            myLabel.text = @"Past actions";
            sideLabel.text = @"Hours spent";
            sideLabel.frame = CGRectMake(tableView.frame.size.width - stringSection1.width - 10, 10, tableView.frame.size.width - 100, 16);
            break;
        default:
            break;
    }
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    [headerView addSubview:sideLabel];
    
    return headerView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtField=[[UITextField alloc]initWithFrame:CGRectMake(10, 4, 320, 39)];
    self.txtField.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.txtField.autoresizesSubviews=YES;
    self.txtField.layer.cornerRadius=10.0;
    [self.txtField setBorderStyle:UITextBorderStyleNone];

    // load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HTDActionCell" bundle:nil];
    
    // register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HTDActionCell"];
    
    self.txtField.delegate = self;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    // add the observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:@"UITextFieldTextDidChangeNotification"
                                               object:nil];

}


// the method to call on a change
- (void)textFieldDidChange:(NSNotification*)aNotification
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (void)dismissKeyboard {
    [self.txtField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"Goal ID is %d", self.goalID);
    
    self.actionsOfGoal = [[[HTDDatabase alloc] init] selectActionsWithGoalID:self.goalID];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
}

@end
