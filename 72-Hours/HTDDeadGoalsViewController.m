//
//  HTDDeanGoalsViewController.m
//  72-Hours
//
//  Created by Ran on 17/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HTDDeadGoalsViewController.h"
#import "HTDDatabase.h"
#import "HTDGoal.h"
#import "HTDDeadGoalDetailViewController.h"
#import "HTDDefaultViewController.h"


// System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface HTDDeadGoalsViewController ()
@property (nonatomic) NSArray *deadGoals;
@end

@implementation HTDDeadGoalsViewController



#pragma mark - IBAction

- (IBAction)save:(UIStoryboardSegue *)segue {
    [[[HTDDatabase alloc] init] markDeadGoalDeadActionAlive:self.action];
    
    [self addLocalNotificationForAction:self.action];
    
    // mark the action as new by changing the highlight_indicate
    [[[HTDDatabase alloc] init] highlightGoalIndicator:self.action];
    
    [self showRedDotOnActiveTab];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.deadGoals = [[[HTDDatabase alloc] init] selectGoalsWithStatus:2];
    
    if ([self.deadGoals count] != 0) {
        [self removeDefaultViewController];
    }
    
    
    [self.tableView reloadData];
    
    
    
    [self hideRedDotOnDeadTab];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([self.deadGoals count] != 0) {
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
            defaultController.defaultText.text = @"Dead tab collects goals that are out of time.";
            [defaultController.defaultText setCenter:defaultController.view.center];
    //        defaultController.defaultText.layer.borderColor = [UIColor grayColor].CGColor;
    //        defaultController.defaultText.layer.borderWidth = 1.0;
            [self.tableView addSubview:defaultController.view];
            [defaultController didMoveToParentViewController:self];
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.deadGoals count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deadGoalCell" forIndexPath:indexPath];
    
    HTDGoal *goal = [[HTDGoal alloc] init];
    goal = self.deadGoals[indexPath.row];
    
    cell.textLabel.text = goal.goal_name;
    int deadCount = [[[HTDDatabase alloc] init] selectGoalDeadCount:goal.goal_id];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", deadCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HTDGoal *goal = [[HTDGoal alloc] init];
    goal = self.deadGoals[indexPath.row];
    
    [self performSegueWithIdentifier:@"showDeadGoalDetail" sender:goal];
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
    
    NSString *textSection0 = @"Dead count";
    
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
            sideLabel.text = @"Dead count";
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


#pragma mark - UIStoryboardSegue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDeadGoalDetail"]) {
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {

            HTDDeadGoalDetailViewController *deadGoalDetailViewController = segue.destinationViewController;
            HTDGoal *goal = sender;
            deadGoalDetailViewController.goalID = goal.goal_id;
        } else {
            UINavigationController *navigationController = segue.destinationViewController;
            HTDDeadGoalDetailViewController *deadGoalDetailViewController = (HTDDeadGoalDetailViewController *)navigationController.topViewController;
            HTDAction *action = sender;
            deadGoalDetailViewController.goalID = action.goal_id;
        }
    }
}


#pragma mark - Helper

- (void)removeDefaultViewController {
    if ([[self.childViewControllers lastObject] isKindOfClass:[HTDDefaultViewController class]]) {
        UIViewController *defaultController = [self.childViewControllers lastObject];
        
        [defaultController willMoveToParentViewController:nil];
        [defaultController.view removeFromSuperview];
        [defaultController removeFromParentViewController];
        [self removeDefaultViewController];
    }
}


- (void)hideRedDotOnDeadTab {
    UIView *viewToRemove = [self.tabBarController.tabBar viewWithTag:87];
    if (viewToRemove) {
        [viewToRemove removeFromSuperview];
        [self hideRedDotOnDeadTab];
    }
}


- (void)showRedDotOnActiveTab {
    UITabBarController *tabBarController = self.tabBarController;
    CGRect tabFrame = tabBarController.tabBar.frame;
    
    CGFloat x = ceilf(0.2 * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    UIImageView *dotImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dot"]];
    
    dotImage.backgroundColor = [UIColor clearColor];
    
    dotImage.frame = CGRectMake(x, y, 9, 9);
    
    dotImage.tag = 20;
    
    [tabBarController.tabBar addSubview:dotImage];
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
@end
