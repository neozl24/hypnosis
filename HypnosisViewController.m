//
//  HypnosisViewController.m
//  Hypnosis
//
//  Created by 钟立 on 16/10/18.
//  Copyright © 2016年 钟立. All rights reserved.
//

#import "HypnosisViewController.h"
#import "HypnosisView.h"

#define FPS 20

@interface HypnosisViewController () <UITextFieldDelegate, UIScrollViewDelegate> {
    NSTimeInterval timeElapsed;
}

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic) HypnosisView *hypnosisView;

@end

@implementation HypnosisViewController

@synthesize hypnosisView;

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"催眠";
        
        self.tabBarItem.image = [UIImage imageNamed:@"Hypno.png"];
    }
    
    return self;
}

//- (void)loadView {
//    重写这个函数比较容易出错，书中的例子是设定好View之后，再赋值给self.view
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    CGRect bigRect = frame;
    bigRect.size.width *= 2.0;
    bigRect.size.height *= 2.0;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    
    hypnosisView = [[HypnosisView alloc] initWithFrame:bigRect];
    hypnosisView.backgroundColor = [UIColor blackColor];
    hypnosisView.center = scrollView.center;
    
    [scrollView addSubview:hypnosisView];
    
    scrollView.bounces = NO;
    scrollView.bouncesZoom = NO;
    scrollView.scrollEnabled = NO;
    scrollView.panGestureRecognizer.enabled = NO;
    scrollView.contentSize = bigRect.size;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2.0;
    
    CGRect textFieldRect = CGRectMake(frame.size.width/2 - 80, -80, 160, 30);
    UITextField* textField = [[UITextField alloc] initWithFrame:textFieldRect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.alpha = 0.8;
    textField.placeholder = @"催眠我吧";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    
    textField.delegate = self;
    
    [self.view addSubview:textField];
    
    self.textField = textField;
    
    timeElapsed = 0;
    
    CADisplayLink* gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateDisplay:)];
    gameTimer.preferredFramesPerSecond = FPS;
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0 delay:0.6 usingSpringWithDamping:0.25 initialSpringVelocity:0.0 options:0 animations:^{
        CGRect frame = CGRectMake(self.view.bounds.size.width/2 - 80, 80, 160, 30);
        self.textField.frame = frame;
    } completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawHypnoticMessage:(NSString *)message {
    for (int i = 0; i < 1 + arc4random() % 3; i++) {
        UILabel* messageLabel = [[UILabel alloc] init];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        messageLabel.font = [UIFont systemFontOfSize: (12 + arc4random() % 10)];
        
        [messageLabel sizeToFit];
        
        int width = (int)(self.view.frame.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        int height = (int)(self.view.frame.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        messageLabel.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            messageLabel.alpha = 0.5 + arc4random_uniform(4) / 10.0;;
        }];
        
        [UIView animateKeyframesWithDuration:2.0 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.6 animations:^{
                messageLabel.center = self.view.center;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.3 animations:^{
                int x = arc4random() % width;
                int y = arc4random() % height;
                messageLabel.center = CGPointMake(x, y);
            }];
        } completion:NULL];
        
        UIInterpolatingMotionEffect *horizontalMotionEffect, *verticalMotionEffect;
        int shiftDistance = 10 + arc4random() % 20;
        
        horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-shiftDistance);
        horizontalMotionEffect.maximumRelativeValue = @(shiftDistance);
        
        [messageLabel addMotionEffect:horizontalMotionEffect];
        
        verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-shiftDistance);
        verticalMotionEffect.maximumRelativeValue = @(shiftDistance);
        
        [messageLabel addMotionEffect:verticalMotionEffect];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self drawHypnoticMessage:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    
    return YES;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return hypnosisView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    scrollView.contentOffset = CGPointMake(0, 0); //拖动会影响坐标系，而不是坐标，所以要固定住坐标系。
    
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeigth = self.view.frame.size.height;
    [hypnosisView setCenter:CGPointMake(viewWidth/2, viewHeigth/2)];
    
}

- (void)updateDisplay:(CADisplayLink *)sender {
//    NSTimeInterval time = sender.timestamp;
    [hypnosisView updateDisplayWithTime:timeElapsed];
    timeElapsed += 1.0 / FPS;
}

@end




