//
//  MZLShortArticleTagsVC.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-12-29.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZLModelShortArticle.h"

@interface MZLShortArticleTagsVC : UIViewController<UITextFieldDelegate>

- (NSDictionary *)selectedTags;

@property (nonatomic, strong) MZLModelShortArticle *model;

@end
