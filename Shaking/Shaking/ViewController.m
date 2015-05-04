//
//  ViewController.m
//  Shaking
//
//  Created by liangyu on 15/5/4.
//  Copyright (c) 2015年 cheng. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "UIButton+XHButtonTitlePosition.h"


#define kXHSelectedButtonSpacing (kIsiPad ? 80 : 30)
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface ViewController () {
    SystemSoundID shakingSoundID;
}

@property (nonatomic, strong) UIImageView *shakeUpImageView;
@property (nonatomic, strong) UIImageView *shakeDownImageView;

@property (nonatomic, strong) UIImageView *shakeUpLineImageView;
@property (nonatomic, strong) UIImageView *shakeDownLineImageView;

@property (nonatomic, strong) UIButton *peopleButton;
@property (nonatomic, strong) UIButton *musicButton;

@property (nonatomic, strong) UIImageView *shakeBackgroundImageView;

@property (nonatomic, assign) CGFloat animationDistans;

@end

@implementation ViewController

- (void)buttonClicked:(UIButton *)sender {
    self.peopleButton.selected = (sender == self.peopleButton);
    self.musicButton.selected = (sender == self.musicButton);
}

- (void)shaking {
    CABasicAnimation *shakeUpImageViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeUpImageViewAnimation.fromValue = 0;
    shakeUpImageViewAnimation.toValue = [NSNumber numberWithFloat:-self.animationDistans];
    shakeUpImageViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shakeUpImageViewAnimation.duration = 0.4;
    shakeUpImageViewAnimation.removedOnCompletion = NO;
    shakeUpImageViewAnimation.fillMode = kCAFillModeBoth;
    shakeUpImageViewAnimation.autoreverses = YES;
    
    CABasicAnimation *shakeDownImageViewAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeDownImageViewAnimation.delegate = self;
    shakeDownImageViewAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    shakeDownImageViewAnimation.fromValue = 0;
    shakeDownImageViewAnimation.toValue = [NSNumber numberWithFloat:self.animationDistans];
    shakeDownImageViewAnimation.duration = 0.4;
    shakeDownImageViewAnimation.removedOnCompletion = NO;
    shakeDownImageViewAnimation.autoreverses = YES;
    shakeDownImageViewAnimation.fillMode = kCAFillModeBoth;
    
    [self.shakeUpImageView.layer addAnimation:shakeUpImageViewAnimation forKey:@"shakeUpImageViewAnimationKey"];
    [self.shakeDownImageView.layer addAnimation:shakeDownImageViewAnimation forKey:@"shakeDownImageViewAnimationKey"];
}

- (void)pullServerNearUsers {
    
}

#pragma mark - Propertys

- (UIImageView *)shakeUpImageView {
    if (!_shakeUpImageView) {
        _shakeUpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 1.0 / 3)];
        _shakeUpImageView.backgroundColor = self.view.backgroundColor;
        _shakeUpImageView.image = [UIImage imageNamed:@"Shake_Logo_Up"];
        _shakeUpImageView.contentMode = UIViewContentModeBottom;
        
        [_shakeUpImageView addSubview:self.shakeUpLineImageView];
    }
    return _shakeUpImageView;
}

- (UIImageView *)shakeDownImageView {
    if (!_shakeDownImageView) {
        _shakeDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.shakeUpImageView.frame), CGRectGetWidth(self.shakeUpImageView.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.shakeUpImageView.bounds))];
        _shakeDownImageView.backgroundColor = self.view.backgroundColor;
        _shakeDownImageView.userInteractionEnabled = YES;
        _shakeDownImageView.image = [UIImage imageNamed:@"Shake_Logo_Down"];
        _shakeDownImageView.contentMode = UIViewContentModeTop;
        
        [_shakeDownImageView addSubview:self.shakeDownLineImageView];
    }
    return _shakeDownImageView;
}

- (UIImageView *)shakeUpLineImageView {
    if (!_shakeUpLineImageView) {
        _shakeUpLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_shakeUpImageView.frame) - 3, CGRectGetWidth(self.view.bounds), 10)];
        _shakeUpLineImageView.image = [UIImage imageNamed:@"Shake_Line_Up"];
        _shakeUpLineImageView.hidden = YES;
    }
    return _shakeUpLineImageView;
}

- (UIImageView *)shakeDownLineImageView {
    if (!_shakeDownLineImageView) {
        _shakeDownLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -7, CGRectGetWidth(self.view.bounds), 10)];
        _shakeDownLineImageView.image = [UIImage imageNamed:@"Shake_Line_Down"];
        _shakeDownLineImageView.hidden = YES;
    }
    return _shakeDownLineImageView;
}

- (UIImageView *)shakeBackgroundImageView {
    if (!_shakeBackgroundImageView) {
        _shakeBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.shakeUpImageView.frame) - self.animationDistans, CGRectGetWidth(self.view.bounds), self.animationDistans * 2)];
        _shakeBackgroundImageView.image = [UIImage imageNamed:@"AlbumHeaderBackgrounImage.jpg"];
    }
    return _shakeBackgroundImageView;
}

- (UIButton *)peopleButton {
    if (!_peopleButton) {
        _peopleButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(_shakeDownImageView.bounds) - 38 - kXHSelectedButtonSpacing, CGRectGetHeight(self.view.bounds) - 150, 38, 34)];
        [_peopleButton setImage:[UIImage imageNamed:@"Shake_icon_people"] forState:UIControlStateNormal];
        [_peopleButton setImage:[UIImage imageNamed:@"Shake_icon_peopleHL"] forState:UIControlStateSelected];
        _peopleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_peopleButton setTitle:@"人" forState:UIControlStateNormal];
        [_peopleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _peopleButton.selected = YES;
        [_peopleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_peopleButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _peopleButton;
}

- (UIButton *)musicButton {
    if (!_musicButton) {
        _musicButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.shakeDownImageView.bounds) + kXHSelectedButtonSpacing, self.peopleButton.frame.origin.y, CGRectGetWidth(self.peopleButton.frame), CGRectGetHeight(self.peopleButton.frame))];
        [_musicButton setImage:[UIImage imageNamed:@"Shake_icon_music"] forState:UIControlStateNormal];
        [_musicButton setImage:[UIImage imageNamed:@"Shake_icon_musicHL"] forState:UIControlStateSelected];
        [_musicButton setTitle:@"歌曲" forState:UIControlStateNormal];
        _musicButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_musicButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_musicButton setTitlePositionWithType:XHButtonTitlePostionTypeBottom];
    }
    return _musicButton;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //    }
    //
    //    self.title = NSLocalizedStringFromTable(@"Shake", @"MessageDisplayKitString", @"摇一摇");
    
    //    [self configureBarbuttonItemStyle:XHBarbuttonItemStyleSetting action:^{
    //        DLog(@"摇一摇设置");
    //    }];
    
    self.animationDistans = kIsiPad ? 230 : 100;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.102 green:0.102 blue:0.114 alpha:1.000];
    
    [self.view addSubview:self.shakeUpImageView];
    [self.view addSubview:self.shakeDownImageView];
    
    [self.view addSubview:self.shakeBackgroundImageView];
    [self.view sendSubviewToBack:self.shakeBackgroundImageView];
    
    [self.view addSubview:self.peopleButton];
    [self.view addSubview:self.musicButton];
    
    //想摇你的手机嘛？就写在这，然后，然后，没有然后了
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shake_sound_male.wav" ofType:@""]]), &shakingSoundID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    self.shakeUpLineImageView.hidden = NO;
    self.shakeDownLineImageView.hidden = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.shakeUpLineImageView.hidden = flag;
    self.shakeDownLineImageView.hidden = flag;
    if (flag) {
        [self pullServerNearUsers];
    }
}

#pragma mark - Event Delegate

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if(motion == UIEventSubtypeMotionShake) {
        // 播放声音
        AudioServicesPlaySystemSound(shakingSoundID);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // 真实一点的摇动动画
        [self shaking];
    }
}

@end
