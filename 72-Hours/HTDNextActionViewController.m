//
//  HTDNextActionViewController.m
//  72-Hours
//
//  Created by Chi on 10/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDNextActionViewController.h"
#import "HTDActionCell.h"
#import "RowForInputCell.h"
#import "HTDAction.h"
#import "RowForToggleCell.h"
#import "HTDDatabase.h"

@interface HTDNextActionViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *inputField;
@property (nonatomic) BOOL goalState;
@property NSArray *actionsOfGoal;

@end

@implementation HTDNextActionViewController

- (IBAction)cancel:(id)sender {
    [[[HTDDatabase alloc] init] flipActionStatus:self.actionsOfGoal[0]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    if (self.goalState) {
        // Update TABLE goal and action to change goal state to finished
        [[[HTDDatabase alloc] init] markGoalAchieved:self.goalID];
    } else {
        // Insert new action to database
        HTDAction *action = [[HTDAction alloc] init];
        action.action_name = self.inputField.text;
        action.goal_id = self.goalID;
        [[[HTDDatabase alloc] init] insertNewNextAction:action];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows;
    
    switch (section) {
        case 0:
            numRows = 2;
            break;
        case 1:
            numRows = [self.actionsOfGoal count];
        default:
            break;
    }
    return numRows;
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


- (void)switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if (switchControl.on) {
        self.goalState = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.goalState = NO;
    }
//    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    HTDActionCell *cellAction;

    
    HTDAction *action = [[HTDAction alloc] init];

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                RowForInputCell *cellInput = [tableView dequeueReusableCellWithIdentifier:@"RowForInputCell" forIndexPath:indexPath];
                cell = cellInput;
                
                [cell addSubview:self.inputField];
                
            } else {
                RowForToggleCell *cellToggle = [tableView dequeueReusableCellWithIdentifier:@"RowForToggleCell" forIndexPath:indexPath];
                //add a switch
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
                [switchView setOn:NO animated:NO];
                [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                cellToggle.accessoryView = switchView;
                cell = cellToggle;
            }
            break;
        case 1:
            cellAction = [tableView dequeueReusableCellWithIdentifier:@"HTDActionCell" forIndexPath:indexPath];
            
            action = self.actionsOfGoal[indexPath.row];

            cellAction.actionNameLabel.text = action.action_name;
            
            NSTimeInterval distanceBetweenDates = [action.date_end timeIntervalSinceDate:action.    date_start];
            double secondsInAnHour = 3600;
            int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
            cellAction.timeSpentLabel.text = [NSString stringWithFormat:@"%d", hoursBetweenDates];
            
            
//            cellAction.timeSpentLabel.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y - cellAction.timeSpentLabel.frame.size.height, cell.imageView.frame.size.width, cellAction.timeSpentLabel.frame.size.height);
            cellAction.timeSpentLabel.textAlignment = NSTextAlignmentCenter;
            
            cell = cellAction;
            break;
        default:
            break;
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(10, 10, tableView.frame.size.width, 16);
    
    NSString *textSection0 = @"Time left";
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
            myLabel.text = @"Next action...";
            sideLabel.text = @"";
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
    
    self.inputField=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, 320, 39)];
    self.inputField.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    self.inputField.autoresizesSubviews=YES;
    self.inputField.layer.cornerRadius=10.0;
    [self.inputField setBorderStyle:UITextBorderStyleNone];
    
    self.inputField.delegate = self;
    
    
    // load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HTDActionCell" bundle:nil];
    
    // register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HTDActionCell"];
    
    self.actionsOfGoal = [[[HTDDatabase alloc] init] selectActionsWithGoalID:self.goalID];

    
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
    [self.inputField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
}



@end
