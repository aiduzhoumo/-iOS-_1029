//
//  MZLShortArticleProgressView.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15-2-3.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZLShortArticleProgressViewDelegate <NSObject>

@optional
- (void)onProgressViewHide;

@end

@interface MZLShortArticleProgressView : UIView

@property (nonatomic, strong) NSString *displayText;
@property (nonatomic, weak) UIView *viewToBlur;

+ (instancetype)instance;

//- (void)show;
- (void)showWithDelegate:(id<MZLShortArticleProgressViewDelegate>)delegate;
//- (void)hide;
- (void)hide:(BOOL)animatedFlag;
- (void)setCancellable:(BOOL)flag;

@end
