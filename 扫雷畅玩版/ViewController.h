//
//  ViewController.h
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/3/29.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GameKit/GameKit.h>
#import "GCHelper.h"
#import "boardView.h"
#import "gridButton.h"
@interface ViewController : NSViewController<GKGameCenterControllerDelegate,leftButtonAndRightButtonAllPressed>
@property (retain) IBOutlet NSTextField *SecondTime;
@property (retain) IBOutlet NSTextField *NumberLei;

@property NSMutableArray *muArr;
@property int rowNumber;
@property int colNumber;
@property int leiNumber;
//初始的雷数
@property int leiNumberOrigin;
@property int passSecond;
@property int leftGrid;
@property NSTimer* timer;
@property BOOL leftMouseDown;
@property BOOL rightMouseDown;
@property BOOL leftAndRightAllPressedFlag;
@property NSMutableArray *buttonArray;
@property BOOL isRoundFail;
@property (weak) IBOutlet boardView *boardView;
@property NSMutableArray* aroundGrid;
-(void)showLadder;
@end

