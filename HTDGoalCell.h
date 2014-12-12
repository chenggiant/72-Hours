//
//  HTDGoalCell.h
//  72-Hours
//
//  Created by Chi on 2/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDGoalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionName;
@property (weak, nonatomic) IBOutlet UILabel *goalName;
@property (weak, nonatomic) IBOutlet UIImageView *actionCheck;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;

@property (weak, nonatomic) IBOutlet UIButton *nextActionButton;

@end
