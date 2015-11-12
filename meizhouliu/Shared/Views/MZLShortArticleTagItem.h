//
//  MZLShortArticleTagItem.h
//  mzl_mobile_ios
//
//  Created by race on 15/1/12.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface MZLShortArticleTagItem : UIView

@property(nonatomic,assign) BOOL    selected;            // default is NO
@property (nonatomic,weak) UILabel *lblTag;
- (void)setTagText:(NSString *)text;

@end
