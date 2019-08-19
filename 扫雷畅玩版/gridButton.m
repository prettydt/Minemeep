//
//  gridButton.m
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/8/4.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import "gridButton.h"

@implementation gridButton
-(void)mouseExited:(NSEvent *)event
{
    if (self.image == [NSImage imageNamed:@"after.png"] ) {
        [self setImage:[NSImage imageNamed:@"tile_mask.png"]];
    }
    
}
-(void)mouseMoved:(NSEvent *)event
{
    // [super mouseMoved:event];
    if (self.image == [NSImage imageNamed:@"tile_mask.png"] ) {
        [self setImage:[NSImage imageNamed:@"after.png"]];
    }

    //  NSLog(@"mouse moved");
}

-(void)updateTrackingAreas
{     //追踪mouse move
    NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways | NSTrackingInVisibleRect |
                                    NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
    
}
-(void)mouseDown:(NSEvent *)event
{
    // self.leftbuttonTime = event.timestamp;
    //  NSLog(@"time==%f",event.timestamp);
    self.leftbuttonTime = 0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:event.timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    self.leftbuttonTime = [formatter stringFromDate:date];
    if (self.rightbuttonTime) {
        if ( [self pleaseInsertStarTime:self.leftbuttonTime andInsertEndTime:self.rightbuttonTime] < 0.5 &&
            [self pleaseInsertStarTime:self.leftbuttonTime andInsertEndTime:self.rightbuttonTime] > -0.5) {
            self.allPressFlag = true;
            [self.delegate lAndRallPressed:self];
        }else
        {
            [super rightMouseDown:event];
        }
    }else
    {
        [super mouseDown:event];
    }

   // [super mouseDown:event];
    NSLog(@"left%@",self.leftbuttonTime);
}
//-(NSView *)hitTest:(NSPoint)point
//{
//    return self;
//
//}
-(void)rightMouseDown:(NSEvent *)event
{
    NSLog(@"rightMouseDown");
    self.rightbuttonTime = 0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:event.timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
    self.rightbuttonTime = [formatter stringFromDate:date];
    NSLog(@"right%@",self.rightbuttonTime);
    if (self.leftbuttonTime) {
        if ( [self pleaseInsertStarTime:self.rightbuttonTime andInsertEndTime:self.leftbuttonTime] < 0.5 &&
           [self pleaseInsertStarTime:self.rightbuttonTime andInsertEndTime:self.leftbuttonTime] > -0.5)
        {
            self.allPressFlag = true;
            [self.delegate lAndRallPressed:self];
        }else
        {
            [super rightMouseDown:event];
        }
    }else
    {
        [super rightMouseDown:event];
    }
    
  //  [super setRefusesFirstResponder:true];
    
  //
    //NSLog(event);
}
-(void)rightMouseUp:(NSEvent *)event
{
    NSLog(@"rightMouseUP");
//    self.rightbuttonTime = 0;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:event.timestamp];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
//    self.rightbuttonTime = [formatter stringFromDate:date];
//    NSLog(@"right%@",self.rightbuttonTime);
//    if (self.leftbuttonTime) {
//        if ( [self pleaseInsertStarTime:self.rightbuttonTime andInsertEndTime:self.leftbuttonTime] < 0.5 &&
//            [self pleaseInsertStarTime:self.rightbuttonTime andInsertEndTime:self.leftbuttonTime] > -0.5)
//        {
//            self.allPressFlag = true;
//            [self.delegate lAndRallPressed:self];
//        }else
//        {
//            [super rightMouseDown:event];
//        }
//    }else
//    {
//        [super rightMouseDown:event];
//    }


    //[self acceptsFirstMouse:event];
    [super rightMouseUp:event];
}
- (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    NSLog(@"time ==%f",time);
    return time;
}
@end
