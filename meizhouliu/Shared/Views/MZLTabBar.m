//
//  MZLTabBar.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-6-11.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLTabBar.h"
#import "MZLSharedData.h"
#import "MZLAppNotices.h"
#import <IBMessageCenter.h>
#import "UIView+MZLAdditions.h"

@interface MZLTabBar () {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *imgTabPersonalized;
@property (weak, nonatomic) IBOutlet UILabel *labelTabPersonalized;
@property (weak, nonatomic) IBOutlet UIImageView *imgTabPersonalizedShortArticles;
@property (weak, nonatomic) IBOutlet UILabel *labelTabPersonalizedShortArticles;
@property (weak, nonatomic) IBOutlet UIImageView *imgTabExplore;
@property (weak, nonatomic) IBOutlet UILabel *labelTabExplore;
@property (weak, nonatomic) IBOutlet UIImageView *imgTabMy;
@property (weak, nonatomic) IBOutlet UILabel *labelTabMy;
@property (weak, nonatomic) IBOutlet UIImageView *imgMessageHint;
@property (weak, nonatomic) IBOutlet UIView *tabShortArticle;

@end

@implementation MZLTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [IBMessageCenter removeMessageListenersForTarget:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (id)tabBarInstance:(CGSize)parentViewSize {
    MZLTabBar *result = [MZLTabBar viewFromNib:@"MZLTabBar"];
    CGFloat y = parentViewSize.height - MZLTabBarHeight;
    result.frame = CGRectMake(0, y, parentViewSize.width, MZLTabBarHeight);
    _sharedInstance = result;
    [IBMessageCenter addGlobalMessageListener:MZL_NOTIFICATION_APP_MESSAGE_UPDATED target:_sharedInstance action:@selector(onAppMessagesUpdated)];
    [_sharedInstance checkTabBarMessageHint];
    [result createTopSepView];
    [result.tabShortArticle setBackgroundColor:MZL_COLOR_YELLOW_FDD414()];
    [result onTabSelected:TAB_PERSONALIZED_SHORT_ARTICLES];
    return result;
}

- (void)onTabSelected:(NSInteger)selectedIndex {
    UIImageView *placeHolderImage = [[UIImageView alloc] init];
    UILabel *placeHolderLbl = [[UILabel alloc] init];
    NSArray *images = @[self.imgTabPersonalized, self.imgTabPersonalizedShortArticles, placeHolderImage, self.imgTabExplore, self.imgTabMy];
    NSArray *lbls = @[self.labelTabPersonalized, self.labelTabPersonalizedShortArticles, placeHolderLbl, self.labelTabExplore, self.labelTabMy];
    
    NSArray *normalImageNames = @[@"tab_article", @"tab_personalized", @"", @"tab_explore", @"tab_my"];
    for (int i = 0; i <= images.count - 1; i ++) {
        UIImageView *tempImage = images[i];
        if (tempImage == placeHolderImage) { // 短文编写tab不需要额外的处理
            continue;
        }
        UILabel *tempLbl = lbls[i];
        if (selectedIndex == i) { // highlight
            NSString *highlightImageName = [NSString stringWithFormat:@"%@_sel", normalImageNames[i]];
            tempImage.image = [UIImage imageNamed:highlightImageName];
            tempLbl.textColor = @"4c3b14".co_toHexColor;
        } else {
            tempImage.image = [UIImage imageNamed:normalImageNames[i]];
            tempLbl.textColor = @"929292".co_toHexColor;
        }
    }
}

- (void)onAppMessagesUpdated {
    [self checkTabBarMessageHint];
}

- (void)checkTabBarMessageHint {
    _sharedInstance.imgMessageHint.visible = [MZLAppNotices unReadMessageCount] > 0;
}

static MZLTabBar *_sharedInstance;

+ (MZLTabBar *)sharedInstance {
    return _sharedInstance;
}

@end
