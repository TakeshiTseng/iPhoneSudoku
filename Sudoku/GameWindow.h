//
//  GameWindow.h
//  Sudoku
//
//  Created by Mac on 11/12/9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuCreater.h"
#import <AudioToolbox/AudioToolbox.h>
@interface GameWindow : UIViewController{
    int board[9][9];
    int level;
    int selectedNum;
    int time;
    SudokuCreater *sc;
    NSMutableArray *btnArray; // 81 btns
    NSMutableArray *nBtnArray; // 9 btns
    NSTimer *timer;
    UIButton *clr;
    UILabel *timeLabel;
    UIImage *bg;
    UIImage *btn1;
    UIImage *btn2;
    UIImage *btn3;
    UIImage *btn4;
    SystemSoundID btnPressSound;
    BOOL isRunning;
}
-(id)initWithCustom:(int)n;
-(IBAction)boardBtnPress:(id)sender;
-(IBAction)selectBtnPress:(id)sender;
-(IBAction)backBtnPress:(id)sender;
-(IBAction)clrBtnPress:(id)sender;
-(int)checkBoard;
-(int)numOfEmpty;
-(void)gameOver;
-(void)timeCount;
@end
