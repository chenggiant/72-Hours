//
//  ViewController.m
//  72-Hours
//
//  Created by Chi on 2/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import "HTDGoalsViewController.h"
#import "HTDGoalDetailViewController.h"
#import "HTDGoalCell.h"
#import "HTDGoal.h"
#import "HTDDatabase.h"
#import "HTDDefaultViewController.h"


// System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

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



#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HTDGoalCell" bundle:nil];
    
    // register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"HTDGoalCell"];
    
    // reload tableview every 10 min to update the timeleft
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(refreshTable) userInfo:nil repeats:YES];
    
    // change the tint color for tab bar
    //    self.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    
    // change the tint color for navigation bar
    //    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    //    self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.activeActions = [[[HTDDatabase alloc] init] selectActionsWithStatus:1];
    
    if ([self.activeActions count] > 0) {
        [self removeDefaultViewController];
    }
    
    // remove empty cells
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView reloadData];
    
    [self hideRedDotOnActiveTab];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[[HTDDatabase alloc] init] unhighlightAllGoalsIndicator];
    
}

#pragma mark - UITableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([self.activeActions count] != 0) {
        
        [self removeDefaultViewController];
        
        return 1;
    } else {
        // Display a message when the table is empty
        if (![[self.childViewControllers lastObject] isKindOfClass:[HTDDefaultViewController class]]) {
            HTDDefaultViewController *defaultController = [[HTDDefaultViewController alloc] init];
            
            [self addChildViewController:defaultController];
            
            CGFloat width = self.tableView.frame.size.width;
            CGFloat height = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.bounds.size.height;
            CGRect frame = CGRectMake(0, 0, width, height);
            defaultController.view.frame = frame;
            defaultController.defaultText.text = @"Active tab collects goals you want to achieve.";
            [defaultController.defaultText setCenter:defaultController.view.center];
            //        defaultController.defaultText.layer.borderColor = [UIColor grayColor].CGColor;
            //        defaultController.defaultText.layer.borderWidth = 1.0;
            [self.view addSubview:defaultController.view];
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.activeActions count];
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
    cell.indicateNewAction.text = @"";
    
    if (action.highlight_indicate == 1) {
//        cell.backgroundColor = [UIColor grayColor];
        cell.indicateNewAction.text = @"New";
    }
    
    if (hoursBetweenDates <= 24) {
        UIImage *image = [UIImage imageNamed: @"Oval_green"];
        [cell.ovalImageView setImage:image];
    } else if (hoursBetweenDates <= 48) {
        UIImage *image = [UIImage imageNamed: @"Oval"];
        [cell.ovalImageView setImage:image];
    } else if (hoursBetweenDates < 72){
        UIImage *image = [UIImage imageNamed: @"Oval_red"];
        [cell.ovalImageView setImage:image];
    } else {
        // mark action dead and also mark goal dead
        [[[HTDDatabase alloc] init] markLastActionAndGoalDead:action];
        
        // update the actions in this view controller !!!
        self.activeActions = [[[HTDDatabase alloc] init] selectActionsWithStatus:1];

        [self refreshTable];
        
        // activate red dot on dead view
        [self showRedDotOnDeadTab];
    }
    
//    cell.timeLeft.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y - cell.timeLeft.frame.size.height, cell.imageView.frame.size.width, cell.timeLeft.frame.size.height);
    cell.timeLeft.textAlignment = NSTextAlignmentCenter;
    
    cell.actionCheck.highlighted = NO;
    cell.actionCheck.highlightedImage = nil;

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


#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addNewGoal"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        HTDNewGoalViewController *newGoalViewController = [navigationController viewControllers][0];
        newGoalViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"showGoalDetail"]) {
        // segue: show segue
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            // works for iOS 7
            HTDGoalDetailViewController *goalDetailViewController = segue.destinationViewController;
            HTDAction *action = sender;
            goalDetailViewController.goalID = action.goal_id;
        } else {
        
        // works for iOS 8
            UINavigationController *navigationController = segue.destinationViewController;
            HTDGoalDetailViewController *goalDetailViewController = (HTDGoalDetailViewController *)navigationController.topViewController;
            HTDAction *action = sender;
            goalDetailViewController.goalID = action.goal_id;
        }
    } else if ([segue.identifier isEqualToString:@"addNextAction"]) {
        // segue: modally segue
        UINavigationController *navigationController = segue.destinationViewController;
        
        HTDNextActionViewController *nextActionViewController = (HTDNextActionViewController *)navigationController.topViewController;
        HTDAction *action = sender;
        nextActionViewController.delegate = self;
        nextActionViewController.goalID = action.goal_id;
    }
}


#pragma mark - HTDNewGoalViewController Delegate


- (void)HTDNewGoalViewController:(HTDNewGoalViewController *)controller didAddGoal:(HTDAction *)action {
    // Insert action to database
    
    [[[HTDDatabase alloc] init] insertNewAction:action];
    [[[HTDDatabase alloc] init] highlightGoalIndicator:action];
    
    // add local notification
    [self addLocalNotificationForAction:action];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)HTDNewGoalViewControllerDidCancel:(HTDNewGoalViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - IBAction


- (IBAction)nextActionButton:(UIButton *)sender {
    HTDAction *action = self.activeActions[sender.tag];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    HTDGoalCell *cell = (HTDGoalCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    UIImage *image = [UIImage imageNamed:@"Checked"];
    
    cell.actionCheck.highlightedImage = image;
    cell.actionCheck.highlighted = YES;
    
    // flip action status to mark action done
    [[[HTDDatabase alloc] init] flipActionStatus:action];
    
    // remove old notification
    NSString *oldNotification = [NSString stringWithFormat:@"Action [%@] has 24 hours left", action.action_name];
    [self removeLocalNotification:oldNotification];
    
    [self performSegueWithIdentifier:@"addNextAction" sender:action];
}

- (IBAction)save:(UIStoryboardSegue *)segue {
    
    
    NSString *oldActionName = [[[HTDDatabase alloc] init] selectActionNameWithActionID:self.action.action_id];
    NSString *oldNotification = [NSString stringWithFormat:@"Action [%@] has 24 hours left", oldActionName];
    
    // remove old notification
    [self removeLocalNotification:oldNotification];
    
    // update the action name
    [[[HTDDatabase alloc] init] updateNextActionName:self.action];
    
    // add new notification with new action name
    [self addLocalNotificationForAction:self.action];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - Local Notification

- (void)addLocalNotificationForAction:(HTDAction *)action {
    UILocalNotification *notification = [[UILocalNotification alloc] init] ;
    
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:action.date_start];

    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:48*3600-distanceBetweenDates];
    notification.timeZone = [NSTimeZone defaultTimeZone] ;
    notification.alertBody = [NSString stringWithFormat:@"Action [%@] has 24 hours left", action.action_name];
    notification.soundName=UILocalNotificationDefaultSoundName;
//    notification.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification] ;
}

- (void)removeLocalNotification:(NSString *)notification {
    NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
    
    for (UILocalNotification *localNotification in arrayOfLocalNotifications) {
        if ([localNotification.alertBody isEqualToString:notification]) {
//            NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
            
            // delete the notification from the system
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ;
            
        }
    }
}


#pragma mark - Helper


- (void)showRedDotOnDeadTab {
    UITabBarController *tabBarController = self.tabBarController;
    CGRect tabFrame = tabBarController.tabBar.frame;
    
    CGFloat x = ceilf(0.87 * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    UIImageView *dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dot"]];
    
    dotImage.backgroundColor = [UIColor clearColor];
    
    dotImage.frame = CGRectMake(x, y, 9, 9);
    
    dotImage.tag = 87;
    
    [tabBarController.tabBar addSubview:dotImage];
}


- (void)hideRedDotOnActiveTab {
    UIView *viewToRemove = [self.tabBarController.tabBar viewWithTag:20];
    if (viewToRemove) {
        [viewToRemove removeFromSuperview];
        [self hideRedDotOnActiveTab];
    }
}


- (void)showRedDotOnDoneTab:(HTDNextActionViewController *)controller {
    UITabBarController *tabBarController = self.tabBarController;
    CGRect tabFrame = tabBarController.tabBar.frame;
    
    CGFloat x = ceilf(0.53 * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    UIImageView *dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dot"]];
    
    dotImage.backgroundColor = [UIColor clearColor];
    
    dotImage.frame = CGRectMake(x, y, 9, 9);
    
    dotImage.tag = 53;
    
    [tabBarController.tabBar addSubview:dotImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)removeDefaultViewController {
    if ([[self.childViewControllers lastObject] isKindOfClass:[HTDDefaultViewController class]]) {
        UIViewController *defaultController = [self.childViewControllers lastObject];
        
        [defaultController willMoveToParentViewController:nil];
        [defaultController.view removeFromSuperview];
        [defaultController removeFromParentViewController];
        [self removeDefaultViewController];
    }
}


- (void)refreshTable {
    // this may be too heavy to process
    //    self.activeActions = [[[HTDDatabase alloc] init] selectActionsWithStatus:1];
    
    [self.tableView reloadData];
}

@end
