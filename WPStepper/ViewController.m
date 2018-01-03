//
//  ViewController.m
//  WPStepper
//
//  Created by 吴朋 on 2016/12/31.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "ViewController.h"

#import "WPUIStepper.h"

@interface ViewController ()<WPUIStepperDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WPUIStepper *stepper = [[WPUIStepper alloc] initWithFrame:CGRectMake(80, 80, 120, 30)];
    stepper.minValue = 1;
    stepper.defaultValue = 3;
    stepper.maxValue = 1232;
    stepper.delegate = self;
    stepper.onlyIntType = YES;
    stepper.stepValue = 2;
    stepper.isCycle = YES;
    stepper.showNumColor = [UIColor blackColor];
    stepper.stepSignColor = [UIColor redColor];
//    stepper.signSize = 40;
    [self.view addSubview:stepper];
}

#pragma mark - WPUIStepperDelegate

- (void)stepperInputValueIllegal:(WPUIStepper *)stepper {
    NSLog(@"不合法");
}

- (void)stepperDidClickSign:(WPUIStepper *)stepper currentValue:(NSString *)currentValue clickType:(WPUIStepperClickType)signType {
    NSString *typeStr = signType == WPUIStepperClickTypeMinu ? @"减号" : @"加号";
    NSLog(@"当前值 %@ %ld  点击%@", currentValue, stepper.tag, typeStr);
}

- (void)stepperDidBeginEditingWithKeyBoard:(WPUIStepper *)stepper {
    NSLog(@"开始输入");
}

-(BOOL)stepperValueDidChangeWithKeyBoard:(WPUIStepper *)stepper inputChangeValue:(NSString *)inputChangValue {
    NSLog(@"以前的值%@  正在改变值 %@", [NSNumber numberWithFloat:stepper.stepperValue], inputChangValue);
    if (inputChangValue && inputChangValue.length > 0) {
        if ([@"0123456789" containsString:inputChangValue]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return YES;
    }
}

- (void)stepperDidEndEditingWithKeyBoard:(WPUIStepper *)stepper {
    NSLog(@"结束值  %@   %ld", [NSNumber numberWithFloat:stepper.stepperValue], stepper.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
