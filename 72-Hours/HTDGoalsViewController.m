//
//  ViewController.m
//  72-Hours
//
//  Created by Chi on 2/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDGoalsViewController.h"
#import "HTDGoalDetailViewController.h"
#import "HTDNextActionViewController.h"
#import "HTDGoalCell.h"
#import "HTDAction.h"
#import "HTDGoal.h"
#import "HTDDatabase.h"

@interface HTDGoalsViewController ()

@property (strong, nonatomic) NSArray *activeActions;
@property int goalID;

@end

@implementation HTDGoalsViewController


- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numSections = 1;
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activeActions count];
}


- (IBAction)nextActionButton:(UIButton *)sender {
    HTDAction *action = self.activeActions[sender.tag];
    
    // flip action status
    [[[HTDDatabase alloc] init] flipActionStatus:action];
    
    [self performSegueWithIdentifier:@"addNextAction" sender:action];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDGoalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HTDGoalCell" forIndexPath:indexPath];
    
    HTDAction *action = [[HTDAction alloc] init];
    action = self.activeActions[indexPath.row];
    
    
    cell.actionName.text = action.action_name;
    cell.goalName.text = action.goal_name;

    
    NSDate *today = [NSDate date];
    NSTimeInterval distanceBetweenDates = [today timeIntervalSinceDate:action.date_start];
    double secondsInAnHour = 3600;
    int hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    cell.timeLeft.text = [NSString stringWithFormat:@"%d", (72-hoursBetweenDates)];
    
    
    if (hoursBetweenDates <= 24) {
        UIImage *image = [UIImage imageNamed: @"Oval_green"];
        [cell.ovalImageView setImage:image];
    } else if (hoursBetweenDates <= 48) {
        UIImage *image = [UIImage imageNamed: @"Oval"];
        [cell.ovalImageView setImage:image];
    } else if (hoursBetweenDates <= 72){
        UIImage *image = [UIImage imageNamed: @"Oval_red"];
        [cell.ovalImageView setImage:image];
    } else {
        // mark action dead and also mark goal dead
        [[[HTDDatabase alloc] init] markLastActionAndGoalDead:action];
    }
    
//    cell.timeLeft.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y - cell.timeLeft.frame.size.height, cell.imageView.frame.size.width, cell.timeLeft.frame.size.height);
    cell.timeLeft.textAlignment = NSTextAlignmentCenter;
    
    
    cell.nextActionButton.tag = indexPath.row;
    [cell.nextActionButton addTarget:self action:@selector(nextActionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDAction *action = [[HTDAction alloc] init];
    action = self.activeActions[indexPath.row];
    
    [self performSegueWithIdentifier:@"showGoalDetail" sender:action];
}


- (void)refreshTable {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HTDGoalCell" bundle:nil];
    
    // register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HTDGoalCell"];
    
    // reload tableview every 10 min to update the timeleft
    [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.activeActions = [[[HTDDatabase alloc] init] selectActionsWithStatus:1];
    
    [self.tableView reloadData];
}


- (void)HTDNewGoalViewController:(HTDNewGoalViewController *)controller didAddGoal:(HTDAction *)action {
    // Insert action to database
    [[HTDDatabase alloc] insertNewAction:action];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)HTDNewGoalViewControllerDidCancel:(HTDNewGoalViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNewGoal"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        HTDNewGoalViewController *newGoalViewController = [navigationController viewControllers][0];
        newGoalViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"showGoalDetail"]) {
        // segue: show segue
        
        // works for iOS 7
        HTDGoalDetailViewController *goalDetailViewController = segue.destinationViewController;
        HTDAction *action = sender;
        goalDetailViewController.goalID = action.goal_id;
        
        // works for iOS 8
//        UINavigationController *navigationController = segue.destinationViewController;
//        HTDGoalDetailViewController *goalDetailViewController = (HTDGoalDetailViewController *)navigationController.topViewController;
//        HTDAction *action = sender;
//        goalDetailViewController.goalID = action.goal_id;
        

    } else if ([segue.identifier isEqualToString:@"addNextAction"]) {
        // segue: modally segue
        UINavigationController *navigationController = segue.destinationViewController;
        
        HTDNextActionViewController *nextActionViewController = (HTDNextActionViewController *)navigationController.topViewController;
        HTDAction *action = sender;
        
        nextActionViewController.goalID = action.goal_id;
    }
}


@end
