//
//  boardView.m
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/8/4.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import "boardView.h"

@implementation boardView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)mouseMoved:(NSEvent *)event
{
    [super mouseMoved:event];
  //  NSLog(@"mouse moved");
}
-(void)updateTrackingAreas
{     //追踪mouse move
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                    NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
}
@end
