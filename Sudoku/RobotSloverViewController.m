//
//  RobotSloverViewController.m
//  Sudoku
//
//  Created by mac on 11/12/10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RobotSloverViewController.h"

@implementation RobotSloverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sBtnPress" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((CFURLRef)sound_url, &btnPressSound);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(id)initWithCustom:(int)n{
    bg = [UIImage imageNamed:@"SudokuBgView4.jpg"];
    btn1 = [UIImage imageNamed:@"sBtn1.png"];
    btn2 = [UIImage imageNamed:@"sBtn2.png"];
    btn3 = [UIImage imageNamed:@"sBtn3.png"];
    btn4 = [UIImage imageNamed:@"sBtn4.png"];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bg];
    [self.view addSubview:bgView];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(12, 320, 200, 15)];
    [l setTextColor:[UIColor blackColor]];
    [l setText:@"Choose a number to put:"];
    [l setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0]];
    [self.view addSubview:l];
	
    // back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [back setFrame:CGRectMake(208, 400, 91, 40)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:btn4 forState:UIControlStateNormal];
    [self.view addSubview:back];
	
    // clear button
    clr = [UIButton buttonWithType:UIButtonTypeCustom];
    [clr setFrame:CGRectMake(12, 400, 91, 40)];
    [clr setTitle:@"Clear" forState:UIControlStateNormal];
    [clr addTarget:self action:@selector(clrBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [clr setBackgroundImage:btn4 forState:UIControlStateNormal];
    [clr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:clr];
	
    // slove button
    UIButton *slove = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [slove setFrame:CGRectMake(110, 400, 91, 40)];
    [slove setTitle:@"Slove" forState:UIControlStateNormal];
    [slove addTarget:self action:@selector(sloveBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [slove setBackgroundImage:btn4 forState:UIControlStateNormal];
    [slove setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:slove];
    sc = [[SudokuCreater alloc]initWithHole:n];
    btnArray = [[NSMutableArray alloc]initWithCapacity:9];
    nBtnArray = [[NSMutableArray alloc]initWithCapacity:9];
    int r,c,t;
    for(r=0;r<9;r++){
        NSMutableArray *colArray = [[NSMutableArray alloc]initWithCapacity:9];
        [btnArray addObject:colArray];
        for(c=0;c<9;c++){
            board[r][c] = sc->board[r][c];
            t = sc->board[r][c];
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectMake(12+(r/3)*5+r*31, 10+(c/3)*5+c*31, 30, 30);
            [b addTarget:self action:@selector(boardBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            if(t!=0){
                [b setTitle:[NSString stringWithFormat:@"%d",t] forState:UIControlStateNormal];
                [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [b setBackgroundImage:btn1 forState:UIControlStateNormal];
                [b setEnabled:NO];
            } else {
                [b setBackgroundImage:btn2 forState:UIControlStateNormal];
                [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [colArray addObject:b];
            [self.view addSubview:b];
            [b release];
        }
        [colArray release];
    }
    for(t=1;t<=9;t++){
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.frame = CGRectMake(12+((t-1)/3*5)+(t-1)*31, 350, 30, 30);
        [b addTarget:self action:@selector(selectBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [b setTitle:[NSString stringWithFormat:@"%d",t] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setBackgroundImage:btn3 forState:UIControlStateNormal];
        [nBtnArray addObject:b];
        [self.view addSubview:b];
        [b release];
    }
    return self;
}
-(IBAction)boardBtnPress:(id)sender{
    int r,c;
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            UIButton *b = [[btnArray objectAtIndex:r]objectAtIndex:c];
            if([b isEqual:(UIButton*)sender]){
                board[r][c] = selectedNum;
                sc->board[r][c] = selectedNum;
                if(selectedNum!=0){
                    [b setTitle:[NSString stringWithFormat:@"%d",selectedNum] forState:UIControlStateNormal];
                } else {
                    [b setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
                }
                if([self checkBoard]!=0){
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
                r=9;
                break;
            }
        }
    }
    AudioServicesPlaySystemSound(btnPressSound);
}
-(IBAction)selectBtnPress:(id)sender{
    int c;
    UIButton *s = (UIButton*)sender;
    for(c=0;c<9;c++){
        UIButton *temp = [nBtnArray objectAtIndex:c];
        if([temp isEqual:s]){
            [[nBtnArray objectAtIndex:c]setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            if(selectedNum-1!=c && selectedNum != 0){
                [[nBtnArray objectAtIndex:selectedNum-1]setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            } else if(selectedNum == 0){
                [clr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            selectedNum = c+1;
            break;
        }
    }
    AudioServicesPlaySystemSound(btnPressSound);
}
-(int)checkBoard{
    int r,c;
    int e=0;
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            UIButton *b = [[btnArray objectAtIndex:r]objectAtIndex:c];
            if(![sc checkOKWithNumber:board[r][c] inCol:c AndRow:r] && [b isEnabled]){
                [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                e++;
            } else {
                if([b isEnabled])
                    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }
        }
    }
    return e;
}
-(int)numOfEmpty{
    int r,c;
    int numOfE=0;
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            if(board[r][c] == 0){
                numOfE ++;
            }
        }
    }
    return numOfE;
}
-(IBAction)backBtnPress:(id)sender{
    AudioServicesPlaySystemSound(btnPressSound);
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)clrBtnPress:(id)sender{
    if(selectedNum!=0){
        [[nBtnArray objectAtIndex:selectedNum-1]setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIButton *b = (UIButton*)sender;
        [b setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        selectedNum = 0;
    }
    AudioServicesPlaySystemSound(btnPressSound);
}
-(IBAction)sloveBtnPress:(id)sender{
    int r,c;
    if([self checkBoard]!=0){
        UIAlertView *a = [[UIAlertView alloc]initWithTitle:@"" message:@"There are something wrongs in this board!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [a show];
        [a release];
        return ;
    }
    [sc initBoard];
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            sc->board[r][c] = board[r][c];
        }
    }
    [sc sloveSudoku:0 :0];
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            board[r][c] = sc->board[r][c];
            UIButton *b = [[btnArray objectAtIndex:r]objectAtIndex:c];
            [b setTitle:[NSString stringWithFormat:@"%d",board[r][c]] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b setBackgroundImage:btn2 forState:UIControlStateNormal];
            [[[btnArray objectAtIndex:r]objectAtIndex:c]setEnabled:NO];
        }
    }
    AudioServicesPlaySystemSound(btnPressSound);
}
@end
