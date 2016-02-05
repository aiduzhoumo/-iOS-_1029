//
//  MZLMyFavoriteHeaderView.h
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/18.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZLMyFavoriteHeaderViewHeight 200.0
#define MZL_MY_ARTICLE_INDEX 1
#define MZL_MY_WANT_INDEX 2
#define MZL_MY_FAVOR_INDEX 3
#define MZL_MY_NOTIFICATION_INDEX 4

@class MZLModelUser;

typedef enum :NSInteger {
    feriendKindListAttention,
    feriendKindListFensi
} feriendKindList;

@protocol MZLMyFavoriteHeaderViewDelegate <NSObject>
- (void)onMyFavoriteHeaderViewTopBarSelected:(NSInteger)tabIndex;
- (void)toAuthorDetailVc;
- (void)toFeriendListVc:(feriendKindList)kindList;
@end

@interface MZLMyFavoriteHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userHeadIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *attentionLbl;
@property (weak, nonatomic) IBOutlet UILabel *attentionCount;
@property (weak, nonatomic) IBOutlet UILabel *fensiLbl;
@property (weak, nonatomic) IBOutlet UILabel *fensiCount;
@property (weak, nonatomic) IBOutlet UILabel *userIntroductionLbl;

@property (weak, nonatomic) IBOutlet UIView *topVIew;

@property (nonatomic, assign) feriendKindList kindList;

@property (nonatomic, weak) MZLModelUser *user;

@property (nonatomic, weak) id<MZLMyFavoriteHeaderViewDelegate> delegate;

+ (instancetype)myFavoriteHeaderViewInstance:(CGSize)parentViewSize;
- (void)onTabSelected:(NSInteger)selectedTabIndex;
- (void)updateUnreadCount;

- (void)initWithMyFavoriteHeaderView;
- (void)updateUserInfo:(MZLModelUser *)user;

@end

@interface MZLMyFavoriteHeaderView (Protected)

- (NSArray *)tabNames;
- (NSArray *)tabIcons;
- (NSArray *)tabSelectedIcons;
- (NSArray *)tabIndexes;

@end
