//
//  ViewController.h
//  Sudoku
//
//  Created by Mac on 11/12/8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuCreater.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface ViewController : UIViewController{
    int n;
    AVAudioPlayer *musicPlayer;
    SystemSoundID btnPressSound;
}
-(IBAction)btnEasyPress:(id)sender;
-(IBAction)btnNormalPress:(id)sender;
-(IBAction)btnHardPress:(id)sender;
-(IBAction)btnRSPress:(id)sender;
- (void)initMusicPlayer;
@end
