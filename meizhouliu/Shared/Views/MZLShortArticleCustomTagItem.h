//
//  MZLShortArticleCustomTagItem.h
//  mzl_mobile_ios
//
//  Created by race on 15/1/15.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLShortArticleCustomTagItem : UIView

- (void)setTagText:(NSString *)text;
@property (nonatomic,weak) UILabel *lblTag;
@end

