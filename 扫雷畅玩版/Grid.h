//
//  Grid.h
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/3/29.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "gridButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface Grid : NSObject
@property Boolean IsLei;
@property Boolean IsClicked;
@property int Count;
@property gridButton* btn;
@property int row;
@property int column;
@end

NS_ASSUME_NONNULL_END
