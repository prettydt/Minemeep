//
//  ViewController.m
//  OcMeep
//
//  Created by dt on 2019/4/1.
//  Copyright © 2019年 dt. All rights reserved.
//

//开始和结束没做呢
//雷数和时间需要UI,位置
//gameCenter我不知道，还是做一个吧，有时间的话
#import "ViewController.h"
#import "Grid.h"
@implementation ViewController
BOOL _gameCenterEnabled;
NSString *_leaderboardIdentifier = @"543109";
-(void)showLadder
{
    [self showLeaderboard];
}
-(void)viewDidAppear{
    
    [self.view.window setFrame:NSMakeRect(300,300, self.rowNumber*31, self.colNumber*31+self.colNumber*5) display:true animate:true];
    //gameCenter本地授权
    [self authenticateLocalPlayer];
    [self showTopBg];
    // 设置图片拉伸形式

    
}
-(void)showTopBg
{
    NSImageView *white = [[NSImageView alloc]initWithFrame:NSMakeRect(0,496,930 ,58)];
    white.imageScaling = NSImageScaleAxesIndependently;
    white.imageFrameStyle = NSImageFrameGroove;
    //    white.imageScaling = NSImageScaling.scaleProportionallyDown;
    //    // 设置图片对齐方式, 默认居中
    //    white.imageAlignment = NSImageAlignment.alignTopLeft;
    //
    NSString *whiteString = @"white.png";
    NSImage *whiteImage = [NSImage imageNamed:whiteString];
    [white setImage:whiteImage];
    [self.view addSubview:white];
    [self numberToLabel:self.leiNumber secOrLei:@"lei"];
    [self numberToLabel:00 secOrLei:@"sec"];
    //生成新游戏按钮: newGame
    NSButton *button = [[NSButton alloc]init];
    button.frame=CGRectMake(420, 505, 31, 31);
   // button.title = @"☺";
    [button setTarget:self];
    [button setImage:[NSImage imageNamed:@"smile1.png"]];
    
    [button setAction:@selector(viewDidLoad)];
    
    [self.view addSubview:button];
    
    
}
/////////////////////////////
- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
       // gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        NSLog(@"leaderboardID%@",leaderboardID);
        gameCenterController.leaderboardIdentifier = leaderboardID;

        [self presentViewControllerAsSheet:gameCenterController];
     
        
    }
}
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    if (gameCenterViewController != NULL)
    {

        
        [gameCenterViewController dismissViewController:gameCenterViewController];
    }
}
//////////////////////////
-(void)updateTime:(BOOL)first{

    if(first == true)
	{
		self.passSecond =0;
		NSLog(@"this is 0");
	}
    self.SecondTime.integerValue = self.passSecond;
    self.passSecond ++;
	[self numberToLabel:self.passSecond secOrLei:@"sec"];

}
-(void)numberToLabel:(int)number secOrLei:(NSString *)secOrLei
{
	int initX = 0;
	if([secOrLei isEqualToString:@"lei"])
	{
		initX = 100;
	}else
	{
		initX = 800;
	}
	NSString *passSecond = [NSString stringWithFormat:@"%d",number];
	
	NSString *valuePassSecond = [self addString:@"0" Length:3 OnString:passSecond];
	
	NSLog(@"passSecond == %@",valuePassSecond);

	for(int i = 0 ;i< 3; i++)
	{
		NSImageView *imView2=[[NSImageView alloc] initWithFrame:NSMakeRect(initX+13*i, 510, 13, 23)];
		NSString *named = [NSString  stringWithFormat:@"number_%@.png",[valuePassSecond substringWithRange:NSMakeRange(i, 1)] ];
        NSImage *myImage2 = [NSImage imageNamed:named];
		[imView2 setImage:myImage2];
		[self.view addSubview:imView2];
	}
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"size == %@",NSStringFromSize(self.view.bounds.size));
	[self numberToLabel:00 secOrLei:@"sec"];
    //[self numberToLabel:99 secOrLei:@"lei"];
    
    NSMenu *mainMenu = [NSApp mainMenu];
    NSLog(@"%@ - %@",mainMenu,[mainMenu itemArray]);
    NSMenuItem *oneItem = [[NSMenuItem alloc] init];
    [oneItem setTitle:@"Load_TEXT"];
    [mainMenu addItem:oneItem];
    //初始化时间和地雷数
    self.SecondTime = [NSTextField new];
    self.NumberLei = [NSTextField new];
    self.SecondTime.editable = NO;
  //  self.SecondTime.drawsBackground = NO;
    self.NumberLei.editable = NO;
    //开始游戏
    [self startGame:30 colNumber:16 leiNumber:99];

    
}
-(void)startGame:(int)rowNumber colNumber:(int)colNumber leiNumber:(int)leiNumber
{
    [self.timer invalidate];
    [self numberToLabel:00 secOrLei:@"sec"];
    //显示秒
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

	//[self initPassSecond];
    self.SecondTime.integerValue = 0;
    self.passSecond = 0;

    //初始的行和列
    self.rowNumber = rowNumber;
    self.colNumber = colNumber;
    //初始的雷数
    self.leiNumber = leiNumber;
    self.leiNumberOrigin = leiNumber;
	[self numberToLabel:self.leiNumber secOrLei:@"lei"];
    //剩余格子
    self.leftGrid = self.rowNumber * self.colNumber;
    self.muArr = [NSMutableArray new];
    for (int x= 0; x < self.rowNumber; x++) {
        NSMutableArray *arr = [NSMutableArray new];
        for (int y = 0 ; y < self.colNumber; y++) {
            //生成按钮
            NSButton *button = [[NSButton alloc]init];
            button.frame=CGRectMake(0+31*x, 0+31*y, 31, 31);
            button.title = @"";
            [button setToolTip:[NSString stringWithFormat:@"%d_%d",x,y]];
            [button setTarget:self];
            [button setImage:[NSImage imageNamed:@"tile_mask.png"]];
            
            [button setAction:@selector(buttonClick:)];
            [self.view addSubview:button];
            //把生成的按钮加到grid的属性里面
            Grid *grid1 = [Grid new];
            grid1.btn = button;
            [arr addObject:grid1];
        }
        [self.muArr addObject:arr];
        
    }

    //生成雷，算法是，按照雷的总数，random每一个类，知道到了总数，如果重复则进行下一次
    
    int k = 0;
    while(k<self.leiNumber)
    {
        int row  = arc4random() % self.rowNumber;
        int col  = arc4random() % self.colNumber;
        Grid *grid2 = [Grid new];
        grid2 = (Grid*)self.muArr[row][col];
        if(!grid2.IsLei)
        {
            grid2.IsLei = true;
            k++;
        }
    }

    //设置时间和地雷数的位置
//    self.SecondTime.frame = NSMakeRect(20, self.colNumber*32, 60, 20);    // Do any additional setup after loading the view.
//    self.SecondTime.bezeled = NO;
//    self.SecondTime.backgroundColor = [NSColor grayColor];
//    self.SecondTime.textColor = [NSColor redColor];
//    [self.view addSubview:self.SecondTime];
//    self.NumberLei.frame = NSMakeRect(120, self.colNumber*32, 60, 20);
//    self.NumberLei.bezeled = NO;
//    self.NumberLei.backgroundColor = [NSColor grayColor];
//    [self.view addSubview:self.NumberLei];
}
- (void)rightMouseDown:(NSEvent *)event
{

    [self succSituation];
    for (NSArray* arr in self.muArr)
    {
        for (Grid* grid in arr){
            if(NSPointInRect(event.locationInWindow, grid.btn.frame))
            {
                NSLog(@"grid.btn.title %@",grid.btn.title);
                if (!grid.IsClicked) {
                    if([grid.btn.title  isEqual: @"🚩"])
                    {
                        NSLog(@"1");
                        grid.btn.title = @"❓";

                    }else
                        if([grid.btn.title  isEqual: @"❓"])
                        {
                            NSLog(@"2");
                            grid.btn.title = @"";
                            
                        }else
                        if([grid.btn.title  isEqual: @""])
                        {
                            NSLog(@"3");
                            grid.btn.title = @"🚩";
                           // self.leiNumber --;
                        }
                }
                    NSLog(@"mouse is clicked %@",grid);
                //如果 grid.btn.title ==🚩，self.leiNumber --
                //else self.leiNumber ++
                if([grid.btn.title isEqualToString:@"🚩"])
                {
                    self.leiNumber --;
                }
                if([grid.btn.title isEqualToString:@"❓"])
                {
                    self.leiNumber ++;
                }
                
            }

               
        }
    }
    self.NumberLei.integerValue = self.leiNumber;
	[self numberToLabel:self.leiNumber secOrLei:@"lei"];
}
- (IBAction)buttonClick:(id)sender {
    NSLog(@"clicked");

    NSButton *btn = (NSButton *)sender;
    


    int row = [[btn.toolTip componentsSeparatedByString:@"_"][0] integerValue];
    int col = [[btn.toolTip componentsSeparatedByString:@"_"][1] integerValue];

    
    Grid *clickGrid = self.muArr[row][col];
    NSLog(@"toolTip%@",clickGrid.btn.title);
    if((!clickGrid.IsClicked) && ([clickGrid.btn.title isEqualToString: @""]))
    {

        btn.enabled = false;
        clickGrid.IsClicked = true;
        clickGrid = self.muArr[row][col];
        if (clickGrid.IsLei) {
            [self showAlert];
             btn.title = @"💥";
            return;
        }
        NSArray *arrays = @[@[@-1,@-1],@[@-1,@0],@[@-1,@+1],@[@0,@-1],@[@0,@1],@[@1,@0],@[@1,@1],@[@1,@-1]];
        int count = 0;
        int x = 0;
        int y = 0;
        for (NSArray *array in arrays) {
            NSLog(@"%@",array);
            x = row + [array[0] intValue];
            y = col + [array[1] intValue];
            if(x >= 0 && x< self.rowNumber && y >= 0 && y < self.colNumber )
            {
                Grid *grid = self.muArr[x][y];
                NSLog(@"grid == %@",grid);
                if(grid.IsLei)
                {
                    count ++;
                    
                }
            }
        }
        if(count == 0)
        {
            
            for (NSArray *array1 in arrays)
            {
                NSLog(@"A");
                int x1 = row + [array1[0] intValue];
                int y1 = col + [array1[1] intValue];
                if(x1 >= 0 && x1< self.rowNumber && y1 >= 0 && y1 < self.colNumber )
                {
                    Grid *grid8 = [Grid new];
                    grid8 = self.muArr[x1][y1];
                    
                    [self buttonClick:grid8.btn];
                }
            }
        }
        if(count == 0)
        {
           
            [btn setImage:[NSImage imageNamed:@"tile_base.png"]];
        }else
        {
            NSString *title = [NSString stringWithFormat:@"%d",count];
            NSColor *color = [NSColor redColor];
           // [self setButtonTitleFor:btn toString:title withColor:color];
            [btn setImage:[NSImage imageNamed:[NSString stringWithFormat:@"tile_%d.png",count]]];
        }

        //   btn.title = [NSString stringWithFormat:@"%d",count];
    }
    
 //判断胜利,开始是进入循环累加了，最后想明白，初始化成0解决问题
    [self succSituation];
}
-(void)succSituation
{
    self.leftGrid = 0;
    for (NSArray* arr in self.muArr) {
        for (Grid *grid in arr) {
            if(!grid.IsClicked){
                self.leftGrid++;
            }
        }
        
    }
    NSLog(@"----");
    NSLog(@"%d", self.leftGrid);
    NSLog(@"%d",self.leiNumber);
    if(self.leftGrid == self.leiNumberOrigin)
    {
        [self uploadScore];
        [self showSuccAlert];
    }
}
- (void)setButtonTitleFor:(NSButton*)button toString:(NSString*)title withColor:(NSColor*)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:title attributes:attrsDictionary];
    [button setAttributedTitle:attrString];
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    

}

-(void)recursion:(int) row and:(int) col btn:(NSButton *)btn{
    Grid *clickGrid = self.muArr[row][col];
    if(!clickGrid.IsClicked)
    {
        clickGrid.IsClicked = true;
        clickGrid = self.muArr[row][col];
        if (clickGrid.IsLei) {
           // [self showAlert];
            //   btn.title = @"😭";
            return;
        }
        NSArray *arrays = @[@[@-1,@-1],@[@-1,@0],@[@-1,@+1],@[@0,@-1],@[@0,@1],@[@1,@0],@[@1,@1],@[@1,@-1]];
        int count = 0;
        for (NSArray *array in arrays) {
            NSLog(@"%@",array);
            int x = row + [array[0] intValue];
            int y = col + [array[1] intValue];
            if(x >= 0 && x< self.rowNumber && y >= 0 && y < self.colNumber )
            {
                Grid *grid = self.muArr[x][y];
                NSLog(@"grid == %@",grid);
                if(grid.IsLei)
                {
                    count ++;
                }
                if(count <= 0)
                {
                    for (NSArray *array1 in arrays)
                    {
                        int x1 = x + [array1[0] intValue];
                        int y1 = y + [array1[1] intValue];
                        if(x1 >= 0 && x1< self.rowNumber && y1 >= 0 && y1 < self.colNumber )
                        {
                            [self recursion:x1 and:y1 btn:btn];
                        }
                    }
                }
            }
        }
        
        //为不同的数字赋予不同的颜色
        NSColor *color = [NSColor greenColor];
        btn.attributedTitle = @1;
        NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[btn attributedTitle]];
        NSRange titleRange = NSMakeRange(0, [colorTitle length]);
        [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
        btn.attributedTitle = colorTitle;
        
        //btn.title = [NSString stringWithFormat:@"%d",count];
    }
}
-(void)uploadScore{
    NSLog(@"ffffff%hhd",_gameCenterEnabled);
    if (_gameCenterEnabled) {
        GKScore *gkscore = [[GKScore alloc]initWithLeaderboardIdentifier:_leaderboardIdentifier];
        gkscore.shouldSetDefaultLeaderboard = YES;
        gkscore.value = [self.SecondTime integerValue];
        [GKScore reportScores:@[gkscore] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }


    
}
- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) identifier
{
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        //Do something interesting here.
    }];
}
//弹框，其实想做一个不太正经的弹框，比如每次都出个笑话这种，先做个正规的，后续再加这个
- (IBAction)showAlert {
    //上传分数

    [self.timer invalidate];
    NSAlert * alert = [[NSAlert alloc]init];
    alert.messageText = @"     不好意思，您输了，下次走运！";
    alert.alertStyle = NSAlertStyleInformational;
    [alert addButtonWithTitle:@"再玩一局"];
    [alert setInformativeText:@"有位科学家到了南极，碰到一群企鹅。他问其中一个：“你每天都干什么呀？”那企鹅说：“吃饭睡觉打豆豆。”\r他又问另一个：“你每天都干什么呀？”那企鹅也说：“吃饭睡觉打豆豆。”\r 他问了许多许多的企鹅，都说：“吃饭睡觉打豆豆。”\r后来他碰到了一只小企鹅，很可爱的样子，就问它：“小朋友，你每天都干什么呀？”小企鹅说：“吃饭睡觉。”科学家一愣，随即问到：“你怎么不打豆豆？”\r小企鹅说：“因为我就是豆豆。”"];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK){
            NSLog(@"(returnCode == NSOKButton)");
        }else if (returnCode == NSModalResponseCancel){
            NSLog(@"(returnCode == )");
        }else if(returnCode == NSAlertFirstButtonReturn){
            [self startGame:30 colNumber:16 leiNumber:99];
        }else if (returnCode == NSAlertSecondButtonReturn){
            NSLog(@"退出");
        }else if (returnCode == NSAlertThirdButtonReturn){
            NSLog(@"else if (returnCode == NSAlertThirdButtonReturn)");
        }else{
            NSLog(@"All Other return code %ld",(long)returnCode);
        }
    }];
    
}

- (IBAction)showSuccAlert {
    [self.timer invalidate];
    NSAlert * alert = [[NSAlert alloc]init];
    NSString *message = [NSString stringWithFormat:@"     你真棒，你的成绩是:%d秒",self.passSecond -1];
    alert.messageText = message;
    alert.alertStyle = NSAlertStyleInformational;
    [alert addButtonWithTitle:@"再玩一局"];

    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK){
            NSLog(@"(returnCode == NSOKButton)");
        }else if (returnCode == NSModalResponseCancel){
            NSLog(@"(returnCode == )");
        }else if(returnCode == NSAlertFirstButtonReturn){
        
           [self startGame:30 colNumber:16 leiNumber:99];

        }else if (returnCode == NSAlertSecondButtonReturn){
            NSLog(@"退出");
        }else if (returnCode == NSAlertThirdButtonReturn){
            NSLog(@"else if (returnCode == NSAlertThirdButtonReturn)");
        }else{
            NSLog(@"All Other return code %ld",(long)returnCode);
        }
    }];
    
}
-(void)initPassSecond{
	//雷数字
	NSString *value = [NSString stringWithFormat:@"%d",000];
	
	NSString *valueInt = [self addString:@"0" Length:3 OnString:value];
	
	NSLog(@"leiNumber == %@",valueInt);
	for(int i = 0 ;i< 3; i++)
	{
		NSImageView *imView2=[[NSImageView alloc] initWithFrame:NSMakeRect(100+13*i, 280, 13, 23)];
		NSString *named = [NSString  stringWithFormat:@"number_%@.png",[valueInt substringWithRange:NSMakeRange(i, 1)] ];
		NSImage *myImage2 = [NSImage imageNamed:named];
		[imView2 setImage:myImage2];
		[self.view addSubview:imView2];
	}
}

    //补位的方法,这段程序写的好
-(NSString*)addString:(NSString*)string Length:(NSInteger)length OnString:(NSString*)str{
    
    NSMutableString * nullStr = [[NSMutableString alloc] initWithString:@""];
    if ((length-str.length)> 0) {
        for (int i = 0; i< (length-str.length); i++) {
            [nullStr appendString:string];
        }
    }
    return [NSString stringWithFormat:@"%@%@",nullStr,str];
}

#pragma mark leaderboard
- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(NSViewController *viewController, NSError *error){
        if (viewController != nil) {
            [self presentViewControllerAsSheet:viewController];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                NSLog(@"authenticated");
              
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    NSLog(@"%@", leaderboardIdentifier);
                    if (error != nil) {
                        NSLog(@"here");
                        NSLog(@"%@", [error description]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];

            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}


- (void)reportScore:(NSNotification *) notification {
    if (_gameCenterEnabled) {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *score = [userInfo objectForKey:@"highestScore"];
        GKScore *gkscore = [[GKScore alloc]initWithLeaderboardIdentifier:_leaderboardIdentifier];
        gkscore.shouldSetDefaultLeaderboard = YES;
        gkscore.value = [score integerValue];
        [GKScore reportScores:@[gkscore] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
    
    
}

- (void)showLeaderboard{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    gcViewController.leaderboardIdentifier = _leaderboardIdentifier;
    NSLog(@"_leaderboardIdentifier%@", _leaderboardIdentifier);
    [self presentViewControllerAsSheet:gcViewController];
}


@end
//实验button的字体是否能变成红色，失败了，暂时搁浅

//NSColor *color = [NSColor blueColor];
//NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//[paragraphStyle setAlignment:NSTextAlignmentCenter];
//NSString *content = btn.title;
//NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:btn.title attributes:@{
//                                                                                                            NSForegroundColorAttributeName: [NSColor redColor],
//                                                                                                            NSBaselineOffsetAttributeName: @3,
//                                                                                                            NSParagraphStyleAttributeName: paragraphStyle
//                                                                                                            }];
//[btn setAttributedTitle:title];
//
//////  btn setTitle:<#(NSString * _Nonnull)#>
//[btn setImage:[NSImage imageNamed:@"after.png"]];
