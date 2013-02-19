//
//  SudokuCreater.h
//  Sudoku
//
//  Created by Mac on 11/12/8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudokuCreater : NSObject{
    @public
    int board[9][9];
    int tag;
}

-(void)initBoard;
-(void)createRandomMBoard;
-(void)sloveSudoku:(int)row:(int) col;
-(void)showBoard;
-(BOOL)checkOKWithNumber:(int) n inCol:(int)col AndRow: (int)row;
-(void)digHole:(int)n;

-(id)initWithHole:(int)H;
@end
