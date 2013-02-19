//
//  RobotSloverViewController.h
//  Sudoku
//
//  Created by mac on 11/12/10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuCreater.h"
#import <AudioToolbox/AudioToolbox.h>
@interface RobotSloverViewController : UIViewController{
    int board[9][9];
    int level;
    int selectedNum;
    SudokuCreater *sc;
    NSMutableArray *btnArray; // 81 btns
    NSMutableArray *nBtnArray; // 9 btns
    UIButton *clr;
    UIImage *btn1;
    UIImage *btn2;
    UIImage *btn3;
    UIImage *btn4;
    UIImage *bg;
    SystemSoundID btnPressSound;
}
-(id)initWithCustom:(int)n;
-(IBAction)boardBtnPress:(id)sender;
-(IBAction)selectBtnPress:(id)sender;
-(IBAction)backBtnPress:(id)sender;
-(IBAction)clrBtnPress:(id)sender;
-(IBAction)sloveBtnPress:(id)sender;
-(int)checkBoard;
-(int)numOfEmpty;
@end