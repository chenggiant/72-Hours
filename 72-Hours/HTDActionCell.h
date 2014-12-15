//
//  HTDActionCell.h
//  72-Hours
//
//  Created by Chi on 9/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTDActionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *actionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSpentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;

@end
