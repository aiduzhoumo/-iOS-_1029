//
//  UITableViewCell+MZLShortArticle.m
//  mzl_mobile_ios
//
//  Created by Whitman on 15/4/2.
//  Copyright (c) 2015年 Whitman. All rights reserved.
//

#import "UITableViewCell+MZLShortArticle.h"
#import "MZLModelShortArticle.h"

@implementation UITableViewCell (MZLShortArticle)

//+ (NSString *)_mzl_sa_reuseIdFromModel:(MZLModelShortArticle *)model {
//    BOOL flag = [self _mzl_isLongContentFor:model];
//    if (model.photos.count == 1) {
//        if (flag) {
//            return MZLSAC_ReuseId1PhotoLongContent;
//        } else {
//            return MZLSAC_ReuseId1PhotoShortContent;
//        }
//    } else {
//        if (flag) {
//            return MZLSAC_ReuseId9PhotoLongContent;
//        } else {
//            return MZLSAC_ReuseId9PhotoShortContent;
//        }
//    }
//}

//+ (NSString *)mzl_sa_contentFromModel:(MZLModelShortArticle *)model {
//    NSString *content = model.content;
//    if (isEmptyString(content)) {
//        return content;
//    }
//    content = [content co_strip];
//    return content;
//}

//+ (BOOL)_mzl_sa_isLongContentFor:(MZLModelShortArticle *)article {
//    NSString *content = [self mzl_sa_contentFromModel:article];
//    if (isEmptyString(content)) {
//        return NO;
//    }
//    NSInteger lineCount = [content co_numberOfLinesConstrainedToWidth:CONTENT_WIDTH withFont:MZL_FONT(CONTENT_FONT_SIZE)];
//    return lineCount > CONTENT_MAX_LINES;
//}

@end
