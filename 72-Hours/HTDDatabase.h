//
//  HTDDatabase.h
//  72-Hours
//
//  Created by Chi on 11/12/14.
//  Copyright (c) 2014 CHI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "HTDAction.h"

@interface HTDDatabase : NSObject

- (NSArray *)selectActionsWithStatus:(int)state;
- (NSArray *)selectActionsWithGoalID:(int)goalID;


- (void)insertNewAction:(HTDAction *)action;
- (void)updateNextActionName:(HTDAction *)newNextAction;
- (void)flipActionStatus:(HTDAction *)action;

- (void)markGoalAchieved:(int)goalID;
- (void)insertNewNextAction:(HTDAction *)action;
- (void)markLastActionAndGoalDead:(HTDAction *)action;

@end
