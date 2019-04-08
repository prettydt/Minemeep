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
-(void)viewDidAppear{
    [self.view.window setFrame:NSMakeRect(300,300, self.rowNumber*31, self.colNumber*31+self.colNumber*6) display:true animate:true];
}
-(void)updateTime{
    self.SecondTime.integerValue = self.passSecond;
    self.passSecond ++;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示秒
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //初始的行和列
    self.rowNumber = 16;
    self.colNumber = 16;
    //初始的雷数
    self.leiNumber = 10;
    self.leiNumberOrigin = 10;
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
    for (NSMutableArray *arr1 in self.muArr) {
        for(Grid * arr2 in arr1){
            NSLog(@"hhu%hhu",arr2.IsLei);
        }
    }
    
    // Do any additional setup after loading the view.
}

- (void)rightMouseDown:(NSEvent *)event
{
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
//弹框，其实想做一个不太正经的弹框，比如每次都出个笑话这种，先做个正规的，后续再加这个
- (IBAction)showAlert {
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
            NSLog(@"再玩一局");
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
    NSAlert * alert = [[NSAlert alloc]init];
    alert.messageText = @"     you win the ganme！";
    alert.alertStyle = NSAlertStyleInformational;
    [alert addButtonWithTitle:@"再玩一局"];

    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSModalResponseOK){
            NSLog(@"(returnCode == NSOKButton)");
        }else if (returnCode == NSModalResponseCancel){
            NSLog(@"(returnCode == )");
        }else if(returnCode == NSAlertFirstButtonReturn){
            NSLog(@"再玩一局");
        }else if (returnCode == NSAlertSecondButtonReturn){
            NSLog(@"退出");
        }else if (returnCode == NSAlertThirdButtonReturn){
            NSLog(@"else if (returnCode == NSAlertThirdButtonReturn)");
        }else{
            NSLog(@"All Other return code %ld",(long)returnCode);
        }
    }];
    
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
