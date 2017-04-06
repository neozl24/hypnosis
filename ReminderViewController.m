//
//  ReminderViewController.m
//  Hypnosis
//
//  Created by 钟立 on 16/10/19.
//  Copyright © 2016年 钟立. All rights reserved.
//

#import "ReminderViewController.h"

@import UserNotifications;

@interface ReminderViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker* datePicker;

@end

@implementation ReminderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"定时";
        
        self.tabBarItem.image = [UIImage imageNamed:@"Time.png"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addReminder:(id)sender {
    
    UNUserNotificationCenter* notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    [notificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError* _Nullable error) {
                              if (granted && !error) {
                                  NSLog(@"request authorization succeeded!");
                              }
                          }];
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = @"催眠大师";
    content.body = @"来接受催眠吧!";
    content.sound = [UNNotificationSound soundNamed:@"notification_sound"];
    
    NSString* requestIdentifier = @"Request";
    
    NSDate* date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
    
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    [notificationCenter addNotificationRequest:request withCompletionHandler:^(NSError* _Nullable error){
        NSLog(@"Error: %@",error);
    }];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
