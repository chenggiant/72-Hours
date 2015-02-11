//
//  HTDDoneGoalDetailViewController.m
//  72-Hours
//
//  Created by Ran on 17/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDDoneGoalDetailViewController.h"
#import "HTDActionCell.h"
#import "HTDAction.h"
#import "HTDDatabase.h"

@interface HTDDoneGoalDetailViewController ()

@property NSArray *actionsOfGoal;

@end

@implementation HTDDoneGoalDetailViewController

#pragma mark - UITableView DataSource and Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.actionsOfGoal count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDActionCell" forIndexPath:indexPath];
    
    HTDAction *action = [[HTDAction alloc] init];
    
    action = self.actionsOfGoal[indexPath.row];
    cell.actionNameLabel.text = action.action_name;
        
    NSTimeInterval distanceBetweenDates = [action.date_end timeIntervalSinceDate:action.   date_start];
    double secondsInAnHour = 3600;
    int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    cell.timeSpentLabel.text = [NSString stringWithFormat:@"%d", hoursBetweenDates];
    
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
    
    NSString *textSection0 = @"Hours spent";
    
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *userAttributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGSize stringSection0 = [textSection0 sizeWithAttributes:userAttributes];
    
    
    UILabel *sideLabel = [[UILabel alloc] init];
    
    
    myLabel.font = [UIFont systemFontOfSize:12];
    sideLabel.font = [UIFont systemFontOfSize:12];
    
    switch (section) {
        case 0:
            myLabel.text = @"Past actions";
            sideLabel.text = @"Hours spent";
            sideLabel.frame = CGRectMake(tableView.frame.size.width - stringSection0.width - 10, 10, tableView.frame.size.width - 100, 16);
            break;
        default:
            break;
    }
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    [headerView addSubview:sideLabel];
    
    return headerView;
}


#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HTDActionCell" bundle:nil];
    
    // register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HTDActionCell"];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.actionsOfGoal = [[[HTDDatabase alloc] init] selectActionsWithGoalID:self.goalID];
    
    [self.tableView reloadData];
}


@end
