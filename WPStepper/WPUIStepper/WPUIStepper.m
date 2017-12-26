//
//  WPUIStepper.m
//  WPStepper
//
//  Created by 吴朋 on 2016/12/31.
//  Copyright © 2016年 wp. All rights reserved.
//

#import "WPUIStepper.h"
typedef enum : NSInteger {
    WPUIStepperSignTypeMinu = 100000, //减号的tag
    WPUIStepperSignTypeAdd = 100001 // 加号的tag
} WPUIStepperSignType;

@interface WPUIStepper ()<UITextFieldDelegate>

@property (nonatomic, strong)UIButton *minuSignButton; // 减号按钮
@property (nonatomic, strong)UIButton *addSignButton;  // 加号按钮
@property (nonatomic, strong)UITextField *showNumTextField;  // 中间显示数字的按钮

@end

@implementation WPUIStepper

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitValue];
        CGFloat itemWidth = frame.size.width / 3.0;
        CGFloat itemHeight = frame.size.height;
        _minuSignButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _minuSignButton.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        _minuSignButton.titleLabel.font = [UIFont systemFontOfSize:_signSize weight:2];
        if (!_signUseImage) {
            [_minuSignButton setTitle:@"-" forState:UIControlStateNormal];
            [_minuSignButton setTitleColor:self.stepSignColor forState:UIControlStateNormal];
        }
        _minuSignButton.tag = WPUIStepperSignTypeMinu;
        [_minuSignButton addTarget:self action:@selector(clickTheButtonValue:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minuSignButton];
        
        _showNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_minuSignButton.frame), CGRectGetMinY(_minuSignButton.frame), itemWidth, itemHeight)];
        _showNumTextField.textColor = _showNumColor;
        _showNumTextField.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        _showNumTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _showNumTextField.returnKeyType = UIReturnKeyDone;
        _showNumTextField.textAlignment = NSTextAlignmentCenter;
        _showNumTextField.layer.borderWidth = 0.7;
        _showNumTextField.layer.borderColor = self.stepBorderColor.CGColor;
        _showNumTextField.delegate = self;
        _showNumTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:self.minValue]];
        _showNumTextField.font = self.numFont;
        [self addSubview:_showNumTextField];
        
        _addSignButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addSignButton.frame = CGRectMake(CGRectGetMaxX(_showNumTextField.frame), CGRectGetMinY(_showNumTextField.frame), itemWidth, itemHeight);
        _addSignButton.titleLabel.font = [UIFont systemFontOfSize:_signSize weight:2];
        if (!_signUseImage) {
            [_addSignButton setTitle:@"+" forState:UIControlStateNormal];
            [_addSignButton setTitleColor:self.stepSignColor forState:UIControlStateNormal];
        }
        _addSignButton.tag = WPUIStepperSignTypeAdd;
        [_addSignButton addTarget:self action:@selector(clickTheButtonValue:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addSignButton];
        
        self.layer.cornerRadius = 2.0;
        self.clipsToBounds = YES;
        self.layer.borderColor = self.stepBorderColor.CGColor;
        self.layer.borderWidth = 0.7;
    }
    return self;
}


- (void)clickTheButtonValue:(UIButton *)button {
    
    if ([_showNumTextField isFirstResponder]) {
        [_showNumTextField resignFirstResponder];
    }
    
    NSString *numStr = _showNumTextField.text;
    CGFloat resultNum = [numStr floatValue];
    WPUIStepperClickType clickType = WPUIStepperClickTypeMinu;
    if (button.tag == WPUIStepperSignTypeMinu) {
        resultNum -= self.stepValue;
        if (resultNum < self.minValue) {
            resultNum = self.isCycle ? self.maxValue : self.minValue;
        }
        clickType = WPUIStepperClickTypeMinu;
    }else if (button.tag == WPUIStepperSignTypeAdd) {
        resultNum += self.stepValue;
        if (resultNum > self.maxValue) {
            resultNum =  self.isCycle ? self.minValue : self.maxValue;
        }
        clickType = WPUIStepperClickTypeAdd;
    }
    _showNumTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:resultNum]];
    
    if (_delegate && [_delegate respondsToSelector:@selector(stepperDidClickSign:currentValue:clickType:)]) {
        [_delegate stepperDidClickSign:self currentValue:_showNumTextField.text clickType:clickType];
    }
}

- (void)setInitValue {
    _minValue = 1;
    _maxValue = 100;
    _stepValue = 1;
    _signSize = 16;
    _signUseImage = NO;
    _isCycle = NO;
    _onlyIntType = YES;
    _showNumColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.8 alpha:1];
    _stepSignColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.8 alpha:1];
    _stepBorderColor = [UIColor colorWithRed:0.5 green:0.8 blue:0.8 alpha:1];
    _numFont = [UIFont systemFontOfSize:15];
}



#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(stepperDidBeginEditingWithKeyBoard:)]) {
        [_delegate stepperDidBeginEditingWithKeyBoard:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.onlyIntType) {
        if (range.length == 0 && ![@"0123456789" containsString:string]) {
            return NO;
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(stepperValueDidChangeWithKeyBoard:inputChangeValue:)]) {
       return [_delegate stepperValueDidChangeWithKeyBoard:self inputChangeValue:string];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_showNumTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    BOOL isDecimal = NO;
    if ([textField.text containsString:@"."] && self.onlyIntType) {
        isDecimal = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(stepperInputValueIllegal:)]) {
            [_delegate stepperInputValueIllegal:self];
        }
        return;
    }
    
    CGFloat inputNum = [textField.text floatValue];
    
    if (inputNum < self.minValue) {
        
        _showNumTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:self.minValue]];
    }
    
    if (inputNum > self.maxValue) {
        _showNumTextField.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:self.maxValue]];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(stepperDidEndEditingWithKeyBoard:)]) {
        [_delegate stepperDidEndEditingWithKeyBoard:self];
    }
}

- (void)setMinuViewBackgroundImage:(UIImage *)backImage forState:(UIControlState)controllerStatus {
    self.signUseImage = YES;
    [_minuSignButton setBackgroundImage:backImage forState:controllerStatus];
}

- (void)setAddViewBackgroundImage:(UIImage *)backImage forState:(UIControlState)controllerStatus {
    self.signUseImage = YES;
    [_addSignButton setBackgroundImage:backImage forState:controllerStatus];
}

- (void)setShowNumViewBackgroundImage:(UIImage *)backImage {
    [_showNumTextField setBackground:backImage];
}

- (void)setSignNomalMinuTitle:(NSString *)minuTitle addTitle:(NSString *)addTitle {
    if (!_signUseImage) {
        [_minuSignButton setTitle:minuTitle forState:UIControlStateNormal];
        [_minuSignButton setTitleColor:self.stepSignColor forState:UIControlStateNormal];
        [_addSignButton setTitle:addTitle forState:UIControlStateNormal];
        [_addSignButton setTitleColor:self.stepSignColor forState:UIControlStateNormal];
    }
}


#pragma mark - Default

- (void)setShowNumColor:(UIColor *)showNumColor {
    _showNumColor = showNumColor;
    _showNumTextField.textColor = showNumColor;
}

- (void)setStepSignColor:(UIColor *)stepSignColor {
    _stepSignColor = stepSignColor;
    [_minuSignButton setTitleColor:stepSignColor forState:UIControlStateNormal];
    [_addSignButton setTitleColor:stepSignColor forState:UIControlStateNormal];
}

- (void)setStepBorderColor:(UIColor *)stepBorderColor {
    self.layer.borderColor = stepBorderColor.CGColor;
    _showNumTextField.layer.borderColor = stepBorderColor.CGColor;
}

- (void)setNumFont:(UIFont *)numFont {
    _numFont = numFont;
    _showNumTextField.font = numFont;
}

- (void)setSignUseImage:(BOOL)signUseImage {
    _signUseImage = signUseImage;
    if (signUseImage) {
        [_minuSignButton setTitle:@"" forState:UIControlStateNormal];
        [_addSignButton setTitle:@"" forState:UIControlStateNormal];
    }else {
        [_minuSignButton setTitle:@"-" forState:UIControlStateNormal];
        [_addSignButton setTitle:@"+" forState:UIControlStateNormal];
    }
}

- (void)setSignSize:(CGFloat)signSize {
    if (!_signUseImage) {
        _minuSignButton.titleLabel.font = [UIFont systemFontOfSize:signSize weight:2];
        _addSignButton.titleLabel.font = [UIFont systemFontOfSize:signSize weight:2];
    }
}

- (CGFloat)stepperValue {
    return [_showNumTextField.text floatValue];
}

@end
