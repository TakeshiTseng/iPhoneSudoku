//
//  SudokuCreater.m
//  Sudoku
//
//  Created by Mac on 11/12/8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SudokuCreater.h"
@implementation SudokuCreater
-(void)showBoard{
    
    int r,c;
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            printf("%d ",board[r][c]);
        }
        printf("\n");
    }
}
-(void)initBoard{
    srand((unsigned)time(NULL));
    int r,c;
    tag=0;
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            board[r][c] = 0;
        }
    }
}
-(void)createRandomMBoard{
    int r,c;
    int n=1;
    int tr,tc;
    int t;
    for(r=0;r<3;r++){
        for(c=0;c<3;c++){
            board[r][c] = n;
            board[r+3][c+3] = n;
            board[r+6][c+6] = n;
            n++;
        }
    }
    for(n=0;n<3;n++){
        for(r=n*3;r<n*3+3;r++){
            for(c=n*3;c<n*3+3;c++){
                tr = rand()%3+3*n;
                tc = rand()%3+3*n;
                t = board[tr][tc];
                board[tr][tc] = board[r][c];
                board[r][c] = t;
            }
        }
    }
}
-(void)sloveSudoku:(int)row:(int) col{
    int n;
    if(row>8){
        tag=1;
        return;
    }
    if(tag==1)return ;
    //printf("%d %d\n",row,col);
    if(board[row][col] != 0){
        if(col==8){
            [self sloveSudoku:row+1 :0];
        } else {
            [self sloveSudoku:row :col+1];
        }
    } else {
        for(n=1;n<=9;n++){
            if([self checkOKWithNumber:n inCol:col AndRow:row]){
                board[row][col] = n;
                if(col==8){
                    [self sloveSudoku:row+1 :0];
                } else {
                    [self sloveSudoku:row :col+1];
                }
                if(tag==0)board[row][col] = 0;
            }
        }
    }
}
-(BOOL)checkOKWithNumber:(int)n inCol:(int)col AndRow:(int)row{
    int r,c;
    for(c=0;c<9;c++){
        if(board[row][c]==n&&c!=col&&board[row][c]!=0){
            return NO;
        }
    }
    for(r=0;r<9;r++){
        if(board[r][col]==n&&r!=row&&board[r][col]!=0){
            return NO;
        }
    }
    for(r=(row/3)*3;r<(row/3)*3+3;r++){
        for(c=(col/3)*3;c<(col/3)*3+3;c++){
            if(board[r][c] == n && r!=row && c!=col &&board[r][c]!=0){
                return NO;
            }
        }
    }
    return YES;
}
-(void)digHole:(int)n{
    int c;
    int tr,tc;
    for(c=0;c<n;c++){
        tr = rand()%9;
        tc = rand()%9;
        if(board[tr][tc] == 0){
            c--;
        }
        else{
            board[tr][tc] = 0;
        }
    }
}
-(id)initWithHole:(int)H{
    [self initBoard];
    [self createRandomMBoard];
    [self sloveSudoku:0 :0];
    [self digHole:H];
    return self;
}
@end
