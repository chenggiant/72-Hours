//
//  HTDDoneGoalsViewController.m
//  72-Hours
//
//  Created by Ran on 17/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDDoneGoalsViewController.h"
#import "HTDDatabase.h"
#import "HTDAction.h"
#import "HTDGoal.h"
#import "HTDDoneGoalDetailViewController.h"


// System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface HTDDoneGoalsViewController ()
@property (nonatomic) NSArray *doneGoals;
@end

@implementation HTDDoneGoalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.doneGoals = [[[HTDDatabase alloc] init] selectGoalsWithStatus:0];
    
    [self.tableView reloadData];
    [self hideRedDotOnDoneTab];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.doneGoals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneGoalCell" forIndexPath:indexPath];
    
    HTDGoal *goal = [[HTDGoal alloc] init];
    goal = self.doneGoals[indexPath.row];
    
    NSArray *actions = [[[HTDDatabase alloc] init] selectActionsWithGoalID:goal.goal_id];
    
    
    // calculate total time spent for a specific goal
    int totalTime = 0;
    
    for (HTDAction *action in actions) {
        NSTimeInterval distanceBetweenDates = [action.date_end timeIntervalSinceDate:action.date_start];
        totalTime += distanceBetweenDates/3600;
    }
    
    cell.textLabel.text = goal.goal_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", totalTime];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDGoal *goal = [[HTDGoal alloc] init];
    goal = self.doneGoals[indexPath.row];
    
    [self performSegueWithIdentifier:@"showDoneGoalDetail" sender:goal];
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
    myLabel.frame = CGRectMake(15, 10, tableView.frame.size.width, 16);
    
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
            myLabel.text = @"Goal name";
            sideLabel.text = @"Hours spent";
            sideLabel.frame = CGRectMake(tableView.frame.size.width - stringSection0.width - 15, 10, tableView.frame.size.width - 100, 16);
            break;
        default:
            break;
    }
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    [headerView addSubview:sideLabel];
    
    return headerView;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDoneGoalDetail"]) {
        
        HTDDoneGoalDetailViewController *doneGoalDetailViewController = segue.destinationViewController;
        HTDGoal *goal = sender;
        doneGoalDetailViewController.goalID = goal.goal_id;
    }
}

- (void)hideRedDotOnDoneTab {
    UIView *viewToRemove = [self.tabBarController.tabBar viewWithTag:53];
    if (viewToRemove) {
        [viewToRemove removeFromSuperview];
    }
}


@end
