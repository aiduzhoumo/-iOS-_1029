//
//  MZLMZLCommentBar.h
//  mzl_mobile_ios
//
//  Created by race on 14-8-27.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MZL_HEIGHT_COMMENT_BAR 44

@class MZLArticleCommentViewController;

@interface MZLCommentBar : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textComment;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentByte;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceHolder;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;

@property (nonatomic, assign) CGFloat heightOfView;
@property (nonatomic, weak) MZLArticleCommentViewController *ownerController;

+ (id)commentBarInstance:(CGSize)parentViewSize;

- (void)resetCommentBar;

@end
