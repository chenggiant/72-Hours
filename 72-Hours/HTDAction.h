//
//  HTDAction.h
//  72-Hours
//
//  Created by Chi on 11/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDAction : NSObject


// for status
// 0 means action finished;
// 1 means action active;
// 2 means action dead;


@property (strong, nonatomic) NSString *action_name;
@property (strong, nonatomic) NSString *goal_name;
@property (strong, nonatomic) NSDate *date_start;
@property (strong, nonatomic) NSDate *date_end;
@property float duration;
@property int status;
@property int action_id;
@property int goal_id;
@property int highlight_indicate;


@end
