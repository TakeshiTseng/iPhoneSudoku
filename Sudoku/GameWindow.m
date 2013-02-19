//
//  GameWindow.m
//  Sudoku
//
//  Created by Mac on 11/12/9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GameWindow.h"

@implementation GameWindow

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
    selectedNum = 1;
    time = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    isRunning = YES;
    NSURL *sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sBtnPress" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((CFURLRef)sound_url, &btnPressSound);
    
    
    // Do any additional setup after loading the view from its nib.
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
-(id)initWithCustom:(int)n;{
    switch (n) {
        case 15:
            bg = [UIImage imageNamed:@"SudokuBgView.jpg"];
            break;
        case 30:
            bg = [UIImage imageNamed:@"SudokuBgView2.jpg"];
            break;
        case 45:
            bg = [UIImage imageNamed:@"SudokuBgView3.jpg"];
            break;
    }
    btn1 = [UIImage imageNamed:@"sBtn1.png"];
    btn2 = [UIImage imageNamed:@"sBtn2.png"];
    btn3 = [UIImage imageNamed:@"sBtn3.png"];
    btn4 = [UIImage imageNamed:@"sBtn4.png"];
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bg];
    [self.view insertSubview:bgView atIndex:0];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(12, 320, 200, 15)];
    [l setTextColor:[UIColor blackColor]];
    [l setText:@"Choose a number to put:"];
    [l setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0]];
    [self.view addSubview:l];
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 400, 91, 40)];
    [timeLabel setText:@"00:00"];
    [timeLabel setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [self.view addSubview:timeLabel];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(208, 400, 91, 40)];
    [back setTitle:@"Back" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:btn4 forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:back];
    clr = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clr setFrame:CGRectMake(12, 400, 91, 40)];
    [clr setTitle:@"Clear" forState:UIControlStateNormal];
    [clr addTarget:self action:@selector(clrBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    [clr setBackgroundImage:btn4 forState:UIControlStateNormal];
    [clr setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:clr];
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
                [b setBackgroundImage:btn1 forState:UIControlStateNormal];
                [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    if([self numOfEmpty]==0 && [self checkBoard] == 0){
        [self gameOver];
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
-(void)gameOver{
    int r,c;
    isRunning = NO;
    for(r=0;r<9;r++){
        for(c=0;c<9;c++){
            UIButton *b = [[btnArray objectAtIndex:r]objectAtIndex:c];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b setBackgroundImage:[UIImage imageNamed:@"sBtn1.png"] forState:UIControlStateNormal];
            [b setEnabled:NO];
        }
    }
    for(c=0;c<9;c++){
        UIButton *b = [nBtnArray objectAtIndex:c];
        [b setEnabled:NO];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete！！" message:@"Press Ok to continue！！"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}
-(IBAction)backBtnPress:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    [timer invalidate];
    AudioServicesPlaySystemSound(btnPressSound);
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
-(void)timeCount{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    if(isRunning){
        time++;
        [timeLabel setText:[NSString stringWithFormat:@"%d.%d",time/10,time%10]];
    }
    [pool release];
}
@end
