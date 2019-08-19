//
//  gridButton.h
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/8/4.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import <Cocoa/Cocoa.h>
NS_ASSUME_NONNULL_BEGIN
@protocol leftButtonAndRightButtonAllPressed
-(void)lAndRallPressed:(id)btn;
@end
@interface gridButton : NSButton
@property NSString* leftbuttonTime;
@property NSString* rightbuttonTime;
@property BOOL allPressFlag;
@property (nonatomic, retain) id <leftButtonAndRightButtonAllPressed> delegate;
@end

NS_ASSUME_NONNULL_END
