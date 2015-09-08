//
//  YQSinaPopController.m
//  YQSinaPop
//
//  Created by 代玉钦 on 15/8/7.
//  Copyright (c) 2015年 dyq. All rights reserved.
//

#import "YQSinaPopController.h"
#import "YQProgressHUD.h"
#import "YQAudioTool.h"
#import "POP.h"
#define YQSinaPopButtonCount 6
#define YQSinaPopButtonTitleFont [UIFont systemFontOfSize:14]
#define YQSinaAddButtonWidth 64
#define YQSinaAddButtonHeight 44
#define YQSinaPopButtonWidth 71
#define YQSinaPopButtonHeight 90
#define YQSinaPopRowMaxCount 3
#define YQPopButtonTitleToImageMargin 8
#define YQSinaCloseButtonWidth 25
#define YQSinaCloseButtonHeight 25
#define YQSinaCloseButtonMarginToBottom 10
#define YQSinaImageViewHeight 48

typedef enum {
    YQPopButtonTypeIdea = 0,
    YQPopButtonTypePhoto,
    YQPopButtonTypeCamera,
    YQPopButtonTypeLbs,
    YQPopButtonTypeReview,
    YQPopButtonTypeMore
} YQPopButtonType;

@interface YQSinaPopButton : UIButton

@end

@implementation YQSinaPopButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = YQSinaPopButtonWidth;
    CGFloat imageH = YQSinaPopButtonWidth;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = YQSinaPopButtonWidth + YQPopButtonTitleToImageMargin;
    CGFloat titleW = YQSinaPopButtonWidth;
    CGFloat titleH = YQSinaPopButtonHeight - YQSinaPopButtonWidth - YQPopButtonTitleToImageMargin;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = YQSinaPopButtonTitleFont;
    }
    return self;
}

@end

@interface YQSinaPopController ()

@property (nonatomic,strong) NSMutableArray *popButtons;

@property (nonatomic,weak) UIView *backgroundCover;

@property (nonatomic,weak) UIButton *closeButton;

@end

@implementation YQSinaPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAddButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [YQAudioTool disposeSoundWithFileName:@"composer_open.wav"];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (NSMutableArray *)popButtons
{
    if (!_popButtons)
    {
        _popButtons = [NSMutableArray array];
    }
    return _popButtons;
}

- (void)setupPopButtonWithImage:(NSString *)image title:(NSString *)title
{
    YQSinaPopButton *popButton = [[YQSinaPopButton alloc] init];
    [popButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [popButton setTitle:title forState:UIControlStateNormal];
    [popButton addTarget:self action:@selector(popButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundCover addSubview:popButton];
    [self.popButtons addObject:popButton];
}

- (void)setupAddButton
{
    UIButton *addButton = [[UIButton alloc] init];
    addButton.imageView.contentMode = UIViewContentModeCenter;
    [addButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [addButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    addButton.frame = CGRectMake(self.view.bounds.size.width * 0.5 - YQSinaAddButtonWidth * 0.5, self.view.bounds.size.height - YQSinaAddButtonHeight, YQSinaAddButtonWidth, YQSinaAddButtonHeight);
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)setupBackgroundCover
{
    UIView *backgroundCover = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundCover.backgroundColor = [UIColor whiteColor];
    backgroundCover.hidden = YES;
    [self.view addSubview:backgroundCover];
    self.backgroundCover = backgroundCover;
}

- (void)addButtonClick
{
    [YQAudioTool playSoundWithFileName:@"composer_open.wav"];
    [self setupBackgroundCover];
    self.backgroundCover.hidden = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_slogan"]];
    imageView.frame = CGRectMake(0, self.view.bounds.size.height * 0.2, self.view.bounds.size.width, YQSinaImageViewHeight);
    imageView.contentMode = UIViewContentModeCenter;
    [self.backgroundCover addSubview:imageView];
    
    [self setupPopButtonWithImage:@"tabbar_compose_idea" title:@"文字"];
    [self setupPopButtonWithImage:@"tabbar_compose_photo" title:@"相册"];
    [self setupPopButtonWithImage:@"tabbar_compose_camera" title:@"拍摄"];
    [self setupPopButtonWithImage:@"tabbar_compose_lbs" title:@"签到"];
    [self setupPopButtonWithImage:@"tabbar_compose_review" title:@"点评"];
    [self setupPopButtonWithImage:@"tabbar_compose_more" title:@"更多"];
    
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"tabbar_compose_background_icon_add"] forState:UIControlStateSelected];
    closeButton.frame = CGRectMake(self.view.bounds.size.width * 0.5 - YQSinaCloseButtonWidth * 0.5, self.view.bounds.size.height - YQSinaCloseButtonMarginToBottom - YQSinaCloseButtonHeight, YQSinaCloseButtonWidth, YQSinaCloseButtonHeight);
    [self.backgroundCover addSubview:closeButton];
    self.closeButton = closeButton;
    
    CGFloat margin = (self.view.bounds.size.width - YQSinaPopButtonWidth * YQSinaPopRowMaxCount) / (YQSinaPopRowMaxCount + 1);
    for (int i = 0; i < self.popButtons.count; i++)
    {
        YQSinaPopButton *popButton = self.popButtons[i];
        popButton.tag = i;
        NSInteger col = i % YQSinaPopRowMaxCount;
        NSInteger row = i / YQSinaPopRowMaxCount;
        CGFloat popButtonX = margin + col * (margin + YQSinaPopButtonWidth);
        CGFloat popButtonY = self.view.bounds.size.height + margin + row * (margin + YQSinaPopButtonHeight);
        popButton.frame = CGRectMake(popButtonX, popButtonY, YQSinaPopButtonWidth, YQSinaPopButtonHeight);
        POPSpringAnimation *anima = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        anima.springBounciness = 8.0f;
        anima.springSpeed = 8.0f;
        anima.toValue = @(-self.view.bounds.size.height * 0.6);
        anima.beginTime = CACurrentMediaTime() + i * 0.025;
        [popButton.layer pop_addAnimation:anima forKey:nil];
    }
}

- (void)closeButtonClick
{
    [YQAudioTool playSoundWithFileName:@"composer_open.wav"];
    self.closeButton.selected = YES;
    for (NSInteger i = 0; i < self.popButtons.count; i++)
    {
        __block YQSinaPopButton *popButton = self.popButtons[self.popButtons.count - 1 - i];
        POPSpringAnimation *anima = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationY];
        anima.springBounciness = 8.0f;
        anima.springSpeed = 8.0f;
        anima.toValue = @(0);
        anima.beginTime = CACurrentMediaTime() + i * 0.025;
        anima.completionBlock = ^(POPAnimation *anima,BOOL completion)
        {
            if (completion)
            {
                [popButton removeFromSuperview];
                popButton = nil;
                if (i == 0)
                {
                    [self.backgroundCover removeFromSuperview];
                    self.backgroundCover = nil;
                    [self.popButtons removeAllObjects];
                }
            }
        };
        [popButton.layer pop_addAnimation:anima forKey:nil];
    }
}

- (void)popButtonClick:(YQSinaPopButton *)popButton
{
    if (popButton.tag == YQPopButtonTypeIdea)
    {
        [YQProgressHUD showMessageWithTitle:@"点击了文字" duration:1.0 animationType:YQProgressHUDAnimationTypeBalloon];
        [self closeButtonClick];
    }
    else if (popButton.tag == YQPopButtonTypePhoto)
    {
        [YQProgressHUD showMessageWithTitle:@"点击了相册" duration:1.0 animationType:YQProgressHUDAnimationTypeBalloon];
        [self closeButtonClick];
    }
    else if (popButton.tag == YQPopButtonTypeCamera)
    {
        [YQProgressHUD showMessageWithTitle:@"点击了拍摄" duration:1.0 animationType:YQProgressHUDAnimationTypeBalloon];
        [self closeButtonClick];
    }
    else if (popButton.tag == YQPopButtonTypeLbs)
    {
        [YQProgressHUD showMessageWithTitle:@"点击了签到" duration:1.0 animationType:YQProgressHUDAnimationTypeBalloon];
        [self closeButtonClick];
    }
    else if (popButton.tag == YQPopButtonTypeReview)
    {
        [YQProgressHUD showMessageWithTitle:@"点击了点评" duration:1.0 animationType:YQProgressHUDAnimationTypeBalloon];
        [self closeButtonClick];
    }
    else if (popButton.tag == YQPopButtonTypeMore)
    {
        [YQProgressHUD showMessageWithTitle:@"点击了更多" duration:1.0 animationType:YQProgressHUDAnimationTypeBalloon];
        [self closeButtonClick];
    }
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
