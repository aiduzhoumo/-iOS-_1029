//
//  MZLAuthorHeader.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-5-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelUser;

typedef enum :NSInteger {
    feriendListKindAttention,
    feriendListKindFensi
} feriendListKind;

@protocol MZLAuthorHeaderShowProgressIndicatorDelegate <NSObject>
- (void)showProgressIndicatorAlertViewOnAuthorDetailVC;
- (void)hideProgressIndicatorAlertViewOnAuthorDetailVC:(BOOL)isSuccess;
@end

typedef void (^feriendListClick)(MZLModelUser *user,feriendListKind listKind);

@interface MZLAuthorHeader : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgAuthorHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *lblAreas;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptions;

@property (weak, nonatomic) IBOutlet UIView *vwBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthorArticleTitle;

@property (weak, nonatomic) IBOutlet UILabel *attention;
@property (weak, nonatomic) IBOutlet UILabel *attentionLable;
@property (weak, nonatomic) IBOutlet UILabel *fensi;
@property (weak, nonatomic) IBOutlet UILabel *fensiLable;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (nonatomic, weak) id<MZLAuthorHeaderShowProgressIndicatorDelegate> delegate;
@property (nonatomic, copy) feriendListClick clickBlcok;

@property (nonatomic, assign) feriendListKind listKind;

@property (nonatomic, strong) MZLModelUser *user;

- (void)initWithAuthorInfo:(MZLModelUser *)author;

@end
