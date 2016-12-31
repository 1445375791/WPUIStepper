//
//  WPUIStepper.h
//  WPStepper
//
//  Created by 吴朋 on 2016/12/31.
//  Copyright © 2016年 wp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPUIStepper;
@protocol WPUIStepperDelegate <NSObject>


/**
 当直接在输入框中输入数字会触发此方法
 */
- (void)stepperDidBeginEditingWithKeyBoard:(WPUIStepper *)stepper;

/**
 结束输入
 */
- (void)stepperDidEndEditingWithKeyBoard:(WPUIStepper *)stepper;


/**
 输入变化 只要输入就会触发
 */
- (void)stepperValueDidChangeWithKeyBoard:(WPUIStepper *)stepper inputChangeValue:(NSString *)inputChangValue;


/**
 点击加号或者减号按钮直接触发
 @param currentValue 当前输入框中的值
 */
- (void)stepperDidClickSign:(WPUIStepper *)stepper currentValue:(NSString *)currentValue;

/**
 输入的信息不满足设置要求时会触发
 */
- (void)stepperInputValueIllegal:(WPUIStepper *)stepper;

@end


@interface WPUIStepper : UIView

@property (nonatomic, assign) CGFloat minValue; //最小值 默认为0

@property (nonatomic, assign) CGFloat maxValue; //最大值 默认为100

@property (nonatomic, assign) CGFloat stepValue; //步长  默认为1

@property (nonatomic, assign, readonly) CGFloat stepperValue; // 结果值

@property (nonatomic, assign) BOOL onlyIntType; // 是否输入的值必须为整型 默认为YES

@property (nonatomic, assign) BOOL isCycle; // 是否循环 当达到最大值或者最小值得时候是否会循环 默认为NO
@property (nonatomic, assign) BOOL signUseImage; // 加减号使用图片还是文字 默认NO 使用文字

@property (nonatomic, strong) UIColor *stepBorderColor; // 边框的颜色

@property (nonatomic, strong) UIColor *stepSignColor; // 符号的颜色

@property (nonatomic, assign) CGFloat signSize; // 设置加减号的大小 默认16 该情况只有在signUseImage为NO 时设置有效

@property (nonatomic, strong) UIColor *showNumColor;  // 显示数字的颜色

@property (nonatomic, strong) UIFont *numFont; // 数字显示样式

@property (nonatomic, weak) id<WPUIStepperDelegate> delegate;


/**
 设置减号的背景图片

 @param backImage 背景图片
 @param controllerStatus 设置的状态
 */
- (void)setMinuViewBackgroundImage:(UIImage *)backImage forState:(UIControlState)controllerStatus;

/**
 设置加号的背景图片
 
 @param backImage 背景图片
 @param controllerStatus 设置的状态
 */
- (void)setAddViewBackgroundImage:(UIImage *)backImage forState:(UIControlState)controllerStatus;

/**
 设置显示数字框的文本

 @param backImage 背景图片
 */
- (void)setShowNumViewBackgroundImage:(UIImage *)backImage;


/**
 设置左右两边的按钮的显示 该设置只有在 signUseImage = NO情况下设置有效

 @param minuTitle 减的显示
 @param addTitle 加的显示
 */
- (void)setSignNomalMinuTitle:(NSString *)minuTitle addTitle:(NSString *)addTitle;


@end
