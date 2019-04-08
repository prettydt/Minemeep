//
//  ViewController.h
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/3/29.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (weak) IBOutlet NSTextField *SecondTime;
@property (weak) IBOutlet NSTextField *NumberLei;

@property NSMutableArray *muArr;
@property int rowNumber;
@property int colNumber;
@property int leiNumber;
//初始的雷数
@property int leiNumberOrigin;
@property int passSecond;
@property int leftGrid;
@end

