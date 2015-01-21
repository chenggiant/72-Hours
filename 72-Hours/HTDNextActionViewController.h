//
//  HTDNextActionViewController.h
//  72-Hours
//
//  Created by Chi on 10/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTDNextActionViewController;

@protocol HTDNextActionViewControllerDelegate <NSObject>

- (void)showRedDotOnDoneTab:(HTDNextActionViewController *)controller;

@end

@interface HTDNextActionViewController : UITableViewController

@property (nonatomic, weak) id <HTDNextActionViewControllerDelegate> delegate;


@property int goalID;

@end
