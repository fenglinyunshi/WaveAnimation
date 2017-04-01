//
//  ViewController.m
//  WaveAnimation
//
//  Created by Dustin on 17/4/1.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "ViewController.h"
#import "WaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WaveView *waveView = [[WaveView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, (self.view.frame.size.height-self.view.frame.size.width/2)/2, self.view.frame.size.width/2, self.view.frame.size.width/2)];
    waveView.layer.cornerRadius = self.view.frame.size.width/4;
    [self.view addSubview:waveView];
}





@end
