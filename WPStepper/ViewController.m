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
    stepper.maxValue = 12;
    stepper.delegate = self;
    stepper.onlyIntType = YES;
    stepper.stepValue = 0.5;
    stepper.isCycle = NO;
    stepper.showNumColor = [UIColor blackColor];
    stepper.stepSignColor = [UIColor redColor];
//    stepper.signSize = 40;
    [self.view addSubview:stepper];
}

#pragma mark - WPUIStepperDelegate

- (void)stepperInputValueIllegal:(WPUIStepper *)stepper {
    NSLog(@"不合法");
}

- (void)stepperDidClickSign:(WPUIStepper *)stepper currentValue:(NSString *)currentValue {
    NSLog(@"当前值 %@", currentValue);
}

- (void)stepperDidBeginEditingWithKeyBoard:(WPUIStepper *)stepper {
    NSLog(@"开始输入");
}

-(void)stepperValueDidChangeWithKeyBoard:(WPUIStepper *)stepper inputChangeValue:(NSString *)inputChangValue {
    NSLog(@"以前的值%@  正在改变值 %@", [NSNumber numberWithFloat:stepper.stepperValue], inputChangValue);
}

- (void)stepperDidEndEditingWithKeyBoard:(WPUIStepper *)stepper {
    NSLog(@"结束值  %@", [NSNumber numberWithFloat:stepper.stepperValue]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
