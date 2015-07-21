//
//  ViewController.m
//  AVAudioPlayerDemo
//
//  Created by Richey on 15/7/20.
//  Copyright (c) 2015年 Richey. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SDProgressView.h"
#import "LoadVC.h"

@interface ViewController ()<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
@property (nonatomic        ) AVAudioPlayer         *player;
@property (nonatomic,strong ) UISlider              *volumeSlider;
@property (nonatomic,strong ) UIProgressView        *progress;
@property (nonatomic,strong ) NSTimer               *timer;
@property (nonatomic        ) SDPieLoopProgressView *loop;
@property (strong, nonatomic) UIButton              *button;
@property (nonatomic        ) NSInteger             i;
@property (nonatomic,strong ) NSURL                 *url;
@property (nonatomic,strong ) NSArray               *arr;
@property (nonatomic,strong ) UISlider              *paceSlider;
@property (nonatomic,strong ) UILabel               *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _arr = @[@"存在",@"沧浪之歌",@"老男孩",@"空城",@"一块红布",@"蓝莲花"];
    [self setupAV];


    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_introduce_bg4.jpg"]];
    imageview.frame = self.view.frame;
    [self.view addSubview:imageview];

    _button = [[UIButton alloc]initWithFrame:CGRectMake(150, 155, 60, 25)];
    [_button setTitle:@"Play" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_button addTarget:self  action:@selector(playOrpause:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_button];
    
    _loop = [SDPieLoopProgressView progressView];
    _loop.frame = CGRectMake(100, 300, 100, 100);
    _loop.progress = 0;
    [self.view addSubview:_loop];

    _volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(100, 450, 200, 10)];
    [self.view addSubview:_volumeSlider];
    _volumeSlider.minimumValue = 0;
    _volumeSlider.maximumValue = 1;
    _volumeSlider.value        = 0.5;
    self.player.volume         = 0.5;
    [_volumeSlider addTarget:self action:@selector(valumeChange) forControlEvents:UIControlEventValueChanged];

    _paceSlider = [[UISlider alloc]initWithFrame:CGRectMake(100, 500, 200, 10)];
    [self.view addSubview:_paceSlider];
    _paceSlider.minimumValue = 0;
    _paceSlider.maximumValue = self.player.duration;
    [_paceSlider addTarget:self action:@selector(paceChange) forControlEvents:UIControlEventValueChanged];
    _loop.center = self.view.center;


    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 60, 25)];
    [nextButton setTitle:@"下一首" forState:UIControlStateNormal];
    [nextButton setTitle:@"" forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchDown];
    [nextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:nextButton];

    UIButton *LastButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 200, 60, 25)];
    [LastButton setTitle:@"上一首" forState:UIControlStateNormal];
    [LastButton setTitle:@"" forState:UIControlStateHighlighted];
    [LastButton addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchDown];
    [LastButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:LastButton];

    _label = [[UILabel alloc]initWithFrame:CGRectMake(100, 250, 160, 25)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = _arr[_i];
    [self.view addSubview:_label];

    UIButton *loadButton = [[UIButton alloc]initWithFrame:CGRectMake(150, self.view.bounds.size.height - 100, 60, 25)];
    [loadButton setTitle:@"下载" forState:UIControlStateNormal];
    [loadButton setTitle:@"" forState:UIControlStateHighlighted];
    [loadButton addTarget:self action:@selector(loadMusic) forControlEvents:UIControlEventTouchDown];
    [loadButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:loadButton];


}


-(void)next
{
    _i += 1;
    if (_i >= _arr.count){
        _i = 0;
    }
    [self setupAV];
    [self.player play];

}

-(void)last
{
    _i -= 1;
    if (_i < 0) {
        _i = _arr.count-1;
    }
    [self setupAV];
    [self.player play];

}

- (void)progressSimulation
{
    static CGFloat progress = 0;

    if (progress < 1.0) {
        progress += 0.01;

        // 循环
        if (progress >= 1.0) progress = 0;
        _loop.progress = progress;

    }
}


-(void)valumeChange
{
    self.player.volume = _volumeSlider.value;
}

-(void)stopTimer
{
    [self.player pause];
    if (self.timer != nil) {
        [self.timer invalidate];
    }
}

-(void)startTimer
{
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(Action) userInfo:nil repeats:YES];
}



- (void)playOrpause:(id)sender {

    if (self.player.playing) {
        [_button setTitle:@"Play" forState:UIControlStateHighlighted];
        [_button setTitle:@"Play" forState:UIControlStateNormal];
        [self stopTimer];
    }else{
        [_button setTitle:@"Pause" forState:UIControlStateHighlighted];
        [_button setTitle:@"Pause" forState:UIControlStateNormal];
        [self startTimer];
    }

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag == YES) {
        [self.button setTitle:@"Play" forState:UIControlStateNormal];
        [self.button setTitle:@"Play" forState:UIControlStateHighlighted];
    }
}

-(void)Action
{
    _paceSlider.value = self.player.currentTime;
    _loop.progress = self.player.currentTime/self.player.duration;

    if (_loop.progress > 0.999) {
        [self next];
    }

}


-(void)setupAV
{
    _url = [[NSBundle mainBundle] URLForResource:_arr[_i] withExtension:@"mp3"];
    NSError *error;
    AVAudioPlayer *newplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:_url error:&error];
    self.player              = newplayer;
    self.player.delegate     = self;
    self.player.enableRate   = YES;
    [self.player prepareToPlay];
     _label.text = _arr[_i];
}

-(void)paceChange
{
    if (self.player.playing) {
        [self stopTimer];
        self.player.currentTime = _paceSlider.value;
        [self startTimer];
    }else{
        self.player.currentTime = _paceSlider.value;
        [self.player stop];
    }
}

-(void)loadMusic
{
    LoadVC *loadvc = [[LoadVC alloc]init];
    [self.navigationController pushViewController:loadvc animated:YES];
}
@end
