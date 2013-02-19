//
//  ViewController.m
//  Sudoku
//
//  Created by Mac on 11/12/8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GameWindow.h"
#import "RobotSloverViewController.h"
@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMusicPlayer];
    [musicPlayer play];
    NSURL *sound_url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sBtnPress" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((CFURLRef)sound_url, &btnPressSound);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [musicPlayer release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}
-(IBAction)btnEasyPress:(id)sender{
    GameWindow *gw = [[GameWindow alloc]initWithCustom:15];
    AudioServicesPlaySystemSound(btnPressSound);
    [self presentModalViewController:gw animated:YES];
    [gw release];
}
-(IBAction)btnNormalPress:(id)sender{
    GameWindow *gw = [[GameWindow alloc]initWithCustom:30];
    AudioServicesPlaySystemSound(btnPressSound);
    [self presentModalViewController:gw animated:YES];
    [gw release];
}
-(IBAction)btnHardPress:(id)sender{
    GameWindow *gw = [[GameWindow alloc]initWithCustom:45];
    AudioServicesPlaySystemSound(btnPressSound);
    [self presentModalViewController:gw animated:YES];
    [gw release];
}
-(IBAction)btnRSPress:(id)sender{
    RobotSloverViewController *rs = [[RobotSloverViewController alloc]initWithCustom:81];
    AudioServicesPlaySystemSound(btnPressSound);
    [self presentModalViewController:rs animated:YES];
    [rs release];
}

- (void)initMusicPlayer {
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]
                                                     pathForResource:@"sBgm" ofType:@"mp3"] isDirectory:NO];
    NSError* error = nil;
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (!url || error) {
    }
    musicPlayer.volume = 0.5;
    musicPlayer.numberOfLoops = -1;
    [url release];
}
@end
