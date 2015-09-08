//
//  YQProgressHUD.h
//  动画
//
//  Created by 代玉钦 on 15/8/4.
//  Copyright (c) 2015年 dyq. All rights reserved.
//

#import <UIKit/UIKit.h>

// 弹框出现的动画类型
typedef enum {
    YQProgressHUDAnimationTypeNone,
    YQProgressHUDAnimationTypeBalloon,
    YQProgressHUDAnimationTypeBottom,
    YQProgressHUDAnimationTypeFadeInFadeOut
} YQProgressHUDAnimationType;

// 指示器类型
typedef enum {
    YQProgressHUDIndicatorTypeRectangle,
    YQProgressHUDIndicatorTypeCircle,
    YQProgressHUDIndicatorTypeChrysanthemum
} YQProgressHUDIndicatorType;

@interface YQProgressHUD : UIView

/*
 * 提示成功或者正确的弹框，图标样式为“√”
 * 弹框的文字
 * duration 展示的时间
 * animationType 动画样式
 */
+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType;

/*
 * 提示错误或者失败的弹框，图标样式为“×”
 * 弹框的文字
 * duration 展示的时间
 * animationType 动画样式
 */
+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType;

/*
 * 提示普通消息的弹框，无图标样式
 * 弹框的文字
 * duration 展示的时间
 * animationType 动画样式
 */
+ (void)showMessageWithTitle:(NSString *)title duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType;

/*
 * 提醒用户的蒙板，会盖住整个屏幕
 * 蒙板文字
 * animationType 蒙板指示器样式
 */
- (void)showProgressHUDWithTitle:(NSString *)title indicatorType:(YQProgressHUDIndicatorType)indicatorType;

/*
 * 隐藏并销毁蒙板
 */
- (void)hideProgressHUD;
@end
