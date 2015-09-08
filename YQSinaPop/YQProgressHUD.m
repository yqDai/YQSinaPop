//
//  YQProgressHUD.m
//  动画
//
//  Created by 代玉钦 on 15/8/4.
//  Copyright (c) 2015年 dyq. All rights reserved.
//

#import "YQProgressHUD.h"
#define YQProgressHUDTitleFont [UIFont systemFontOfSize:16]
#define YQProgressHUDTitleMargin 10
#define YQProgressHUDImageWidth 28
#define YQProgressHUDRectangleMargin 2
#define YQProgressHUDRectangleCount 5
#define YQProgressHUDRectangleWidth 6
#define YQProgressHUDRectangleHeight 10
#define YQProgressHUDCircleRadius 25
#define YQProgressHUDChrysanthemumWidth 30


@interface YQProgressHUD ()


@property (nonatomic,weak) UILabel *msgLabel;

@property (nonatomic,weak) UIImageView *statusImage;

@property (nonatomic,weak) UIView *backgroundView;


@end

@implementation YQProgressHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    UIViewController *topVC = [self topVC];
//    self.bounds = CGRectMake(0, 0, topVC.view.frame.size.width * 0.5, 100);
//    self.center = topVC.view.center;
//    
//    self.statusImage.frame = CGRectMake(0, 0, self.bounds.size.width, 60);
//    
//    self.msgLabel.frame = CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 30);
//    
//}

- (UIViewController *)topVC
{
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)setupView
{
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.65;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    [[self topVC].view addSubview:self];
    self.hidden = YES;
    
    UIImageView *statusImage = [[UIImageView alloc] init];
    statusImage.contentMode = UIViewContentModeCenter;
    [self addSubview:statusImage];
    self.statusImage = statusImage;
    
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.font = YQProgressHUDTitleFont;
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:msgLabel];
    self.msgLabel = msgLabel;
}


+ (void)showWithmessage:(NSString *)message image:(NSString *)image duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType
{
    YQProgressHUD *hud = [self progressHUD];
    [hud setupView];
    UIViewController *topVC = [hud topVC];
    hud.hidden = NO;
    hud.msgLabel.text = message;
    hud.center = topVC.view.center;
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = YQProgressHUDTitleFont;
    CGSize titleSize = [message sizeWithAttributes:attrs];
    hud.bounds = CGRectMake(0, 0, titleSize.width + 2 * YQProgressHUDTitleMargin, 3 * YQProgressHUDTitleMargin + titleSize.height + YQProgressHUDImageWidth);
    
    if (!image.length)
    {
        hud.statusImage.frame = CGRectZero;
        hud.msgLabel.center = CGPointMake(hud.bounds.size.width * 0.5, hud.bounds.size.height * 0.5);
        hud.msgLabel.bounds = (CGRect){{0,0},titleSize};
    }
    else
    {
        hud.statusImage.frame = CGRectMake(hud.bounds.size.width * 0.5 - YQProgressHUDImageWidth * 0.5, YQProgressHUDTitleMargin , YQProgressHUDImageWidth, YQProgressHUDImageWidth);
        hud.statusImage.image = [UIImage imageNamed:image];
        hud.msgLabel.frame = CGRectMake(YQProgressHUDTitleMargin, CGRectGetMaxY(hud.statusImage.frame) + YQProgressHUDTitleMargin, titleSize.width, titleSize.height);
    }
    if (animationType == YQProgressHUDAnimationTypeBalloon)
    {
        CAKeyframeAnimation *anima = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        anima.duration = 0.5;
        anima.values = @[@0,@1.3,@1.0];
        [hud.layer addAnimation:anima forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            anima.values = @[@1.0,@1.3,@0];
            anima.duration = 0.5;
            anima.removedOnCompletion = NO;
            anima.fillMode = kCAFillModeForwards;
            [hud.layer addAnimation:anima forKey:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
                [hud removeFromSuperview];
            });
        });
    }
    else if (animationType == YQProgressHUDAnimationTypeBottom)
    {
        CAKeyframeAnimation *animaTrans = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        CAKeyframeAnimation *animaRotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        animaTrans.duration = 0.5;
        animaTrans.values = @[@(-topVC.view.bounds.size.height * 0.8),@0];
        animaRotate.duration = 0.5;
        animaRotate.values = @[@0,@(-M_PI * 0.25),@0];
        [hud.layer addAnimation:animaTrans forKey:nil];
        [hud.layer addAnimation:animaRotate forKey:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            animaTrans.duration = 0.5;
            animaTrans.values = @[@0,@(topVC.view.bounds.size.height * 0.8)];
            animaTrans.removedOnCompletion = NO;
            animaTrans.fillMode = kCAFillModeForwards;
            animaRotate.duration = 0.5;
            animaRotate.values = @[@0,@(M_PI * 0.25),@0];
            animaRotate.removedOnCompletion = NO;
            animaRotate.fillMode = kCAFillModeForwards;
            [hud.layer addAnimation:animaRotate forKey:nil];
            [hud.layer addAnimation:animaTrans forKey:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hud.hidden = YES;
                [hud removeFromSuperview];
            });
        });
    }
    else if (animationType == YQProgressHUDAnimationTypeFadeInFadeOut)
    {
        hud.alpha = 0;
        [UIView animateWithDuration:1.5 animations:^{
            hud.alpha = 0.65;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.5 animations:^{
                    hud.alpha = 0;
                } completion:^(BOOL finished) {
                    [hud removeFromSuperview];
                }];
            });
        }];
    }
    else if (animationType == YQProgressHUDAnimationTypeNone)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hud.hidden = YES;
            [hud removeFromSuperview];
        });
    }
    
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType
{
    [self showWithmessage:title image:@"YQProgressHUD.bundle/error" duration:duration animationType:animationType];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType
{
    [self showWithmessage:title image:@"YQProgressHUD.bundle/success" duration:duration animationType:animationType];
}

+ (void)showMessageWithTitle:(NSString *)title duration:(CGFloat)duration animationType:(YQProgressHUDAnimationType)animationType
{
    [self showWithmessage:title image:nil duration:duration animationType:animationType];
}

+ (instancetype)progressHUD
{
    return [[self alloc] init];
}

- (void)showProgressHUDWithTitle:(NSString *)title indicatorType:(YQProgressHUDIndicatorType)indicatorType
{
    UIViewController *topVC = [self topVC];
    UIView *backgroundView = [[UIView alloc] init];
    [topVC.view addSubview:backgroundView];
    backgroundView.frame = topVC.view.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.65;
    self.backgroundView = backgroundView;
    if (indicatorType == YQProgressHUDIndicatorTypeCircle)
    {
        [self animationCircleWithTitle:title];
    }
    else if (indicatorType == YQProgressHUDIndicatorTypeRectangle)
    {
        [self animationRectangleWithTitle:title];
    }
    else if (indicatorType == YQProgressHUDIndicatorTypeChrysanthemum)
    {
        [self animationChrysanthemumWithTitle:title];
    }
}

- (void)animationRectangleWithTitle:(NSString *)title
{
    UIViewController *topVC = [self topVC];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, YQProgressHUDRectangleHeight * 0.5 + YQProgressHUDTitleMargin +topVC.view.center.y, topVC.view.bounds.size.width, 40);
    for (int i = 0; i < YQProgressHUDRectangleCount; i++)
    {
        UIView *animationView = [[UIView alloc] init];
        animationView.backgroundColor = [UIColor whiteColor];
        UIViewController *topVC = [self topVC];
        CGFloat animaX = (topVC.view.bounds.size.width - YQProgressHUDRectangleWidth * YQProgressHUDRectangleCount - YQProgressHUDRectangleMargin * (YQProgressHUDRectangleCount - 1)) * 0.5 +i * (YQProgressHUDRectangleMargin + YQProgressHUDRectangleWidth);
        CGFloat animaY = (topVC.view.bounds.size.height - YQProgressHUDRectangleHeight) * 0.5;
        animationView.frame = CGRectMake(animaX, animaY, YQProgressHUDRectangleWidth, YQProgressHUDRectangleHeight);
        [self.backgroundView addSubview:animationView];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        animation.duration = 1.0;
        animation.beginTime = CACurrentMediaTime() + i * 0.1;
        animation.values = @[@1,@2.5,@1];
        animation.removedOnCompletion = NO;
        animation.repeatCount = MAXFLOAT;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animationView.layer addAnimation:animation forKey:nil];
    }
}

- (void)animationCircleWithTitle:(NSString *)title
{
    UIViewController *topVC = [self topVC];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, YQProgressHUDCircleRadius * 2 + YQProgressHUDTitleMargin +topVC.view.center.y, topVC.view.bounds.size.width, 40);
    for (int i = 0; i < 2; i++)
    {
        UIView *animationView = [[UIView alloc] init];
        animationView.backgroundColor = [UIColor whiteColor];
        animationView.alpha = 0.6;
        animationView.layer.cornerRadius = YQProgressHUDCircleRadius;
        animationView.center = topVC.view.center;
        animationView.bounds = CGRectMake(0, 0, YQProgressHUDCircleRadius * 2, YQProgressHUDCircleRadius * 2);
        [self.backgroundView addSubview:animationView];
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 1.0;
        animation.beginTime = CACurrentMediaTime() + i * 0.1;
        if (i)
        {
            animation.values = @[@1,@0,@1];
        }
        else
        {
            animation.values = @[@1,@2,@1];
        }
        animation.removedOnCompletion = NO;
        animation.repeatCount = MAXFLOAT;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [animationView.layer addAnimation:animation forKey:nil];
    }
}

- (void)animationChrysanthemumWithTitle:(NSString *)title
{
    UIViewController *topVC = [self topVC];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.65];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:titleLabel];
    titleLabel.frame = CGRectMake(0, YQProgressHUDChrysanthemumWidth * 0.5 + YQProgressHUDTitleMargin +topVC.view.center.y, topVC.view.bounds.size.width, 40);
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = topVC.view.center;
    activity.bounds = CGRectMake(0, 0, YQProgressHUDChrysanthemumWidth, YQProgressHUDChrysanthemumWidth);
    [self.backgroundView addSubview:activity];
    [activity startAnimating];
}

- (void)hideProgressHUD
{
//    YQProgressHUD *hud = self.backgroundView;
    self.backgroundView.hidden = YES;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

//+ (void)hideProgressHUD
//{
//    [[self progressHUD] hideProgressHUD];
//}

@end
