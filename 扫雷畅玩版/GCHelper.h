//
//  GCHelper.h
//  五子棋-天梯（pvp）
//
//  Created by 国梁李 on 2019/5/27.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <Cocoa/Cocoa.h>
@protocol GCHelperDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end

@interface GCHelper : NSObject < GKTurnBasedMatchmakerViewControllerDelegate, GKLocalPlayerListener > {
    BOOL _gameCenterAvailable;
    BOOL _gameCenterFeaturesEnabled;
    BOOL _playerAuthenticated;
    
    NSViewController *_presentingViewController;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (assign, readonly) BOOL playerAuthenticated;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

@property (strong) GKTurnBasedMatch * currentMatch;

@property (nonatomic, assign) id <GCHelperDelegate> delegate;

+ (GCHelper *)sharedInstance;
- (BOOL)isGameCenterAvailable;
- (void)authenticationChanged;
- (void)authenticateLocalUserFromViewController:(NSViewController *)authenticationPresentingViewController;
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)identifier;
// Report a single achievement
- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
// Report multiple achievements
- (void)reportAchievements:(NSArray*)achievements;

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(NSViewController *)viewController;
@end
