//
//  AppDelegate.m
//  扫雷畅玩版
//
//  Created by 国梁李 on 2019/3/29.
//  Copyright © 2019 国梁李. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (IBAction)helpButton:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.jianshu.com/p/e9e1e712272b"]];
    
}
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return true;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (IBAction)rankChoose:(id)sender {
    NSButton *btn = (NSButton*)sender;
    NSLog(btn.title);
    
}
    
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
//gameCenter排行榜
- (IBAction)showLadder:(id)sender {
    ViewController *viewController = [NSApplication sharedApplication].mainWindow.contentViewController;
    [viewController showLadder];
}


@end
