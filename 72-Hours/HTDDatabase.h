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


// for status
// 0 means goal finished;
// 1 means goal active;
// 2 means goal dead;



// Selection Queries
- (NSArray *)selectActionsWithStatus:(int)state;
- (NSArray *)selectActionsWithGoalID:(int)goalID;
- (int)selectGoalDeadCount:(int)goalID;
- (NSArray *)selectGoalsWithStatus:(int)state;


// Updating Queries
- (void)insertNewAction:(HTDAction *)action;
- (void)updateNextActionName:(HTDAction *)newNextAction;
- (void)flipActionStatus:(HTDAction *)action;
- (void)markGoalAchieved:(int)goalID;
- (void)insertNewNextAction:(HTDAction *)action;
- (void)markLastActionAndGoalDead:(HTDAction *)action;
- (void)markDeadGoalDeadActionAlive:(HTDAction *)action;

@end
