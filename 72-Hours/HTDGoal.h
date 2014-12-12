//
//  HTDGoal.h
//  72-Hours
//
//  Created by Chi on 11/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDGoal : NSObject


// for status
// 0 means goal finished;
// 1 means goal active;
// 2 means goal dead;


@property (strong, nonatomic) NSString *goal_name;
@property float duration;
@property int status;
@property int goal_id;
@property int dead_count;

@end
