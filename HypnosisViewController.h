//
//  HypnosisViewController.h
//  Hypnosis
//
//  Created by 钟立 on 16/10/18.
//  Copyright © 2016年 钟立. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HypnosisViewController : UIViewController

- (void)drawHypnoticMessage:(NSString *)message;
- (void)updateDisplay:(CADisplayLink *)sender;

@end

