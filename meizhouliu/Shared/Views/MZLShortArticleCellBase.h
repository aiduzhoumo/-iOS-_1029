//
//  MZLShortArticleCellBase.h
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/8.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZLModelShortArticle;

@interface MZLShortArticleCellBase : UITableViewCell

@property (nonatomic, weak) UIViewController *ownerController;
@property (nonatomic, strong) MZLModelShortArticle *shortArticle;


- (void)_onUpStatusModified;
- (void)_onCommentStatusModified;

@end
