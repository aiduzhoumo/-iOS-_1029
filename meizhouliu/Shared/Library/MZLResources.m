//
//  MZLResources.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLResources.h"
#import "COUtils.h"
#import "UIStoryboard+COAddition.h"

UIFont *MZL_FONT(CGFloat size) {
    return [UIFont systemFontOfSize:size];
}

UIFont *MZL_BOLD_FONT(CGFloat size) {
    return [UIFont boldSystemFontOfSize:size];
}

UIFont *MZL_ITALIC_FONT(CGFloat size) {
    return [UIFont italicSystemFontOfSize:size];
}

UIImage *MZL_DEFAULT_IMAGE() {
    return nil;
}

UIImage *MZL_NAVBAR_BG_IMAGE() {
    return [UIImage imageNamed:@"NavbarImg"];
}

UIColor *MZL_NAVBAR_BG_COLOR() {
    return [UIColor whiteColor];
}

UIColor *MZL_NAVBAR_TITLE_COLOR() {
    return MZL_COLOR_BLACK_555555();
}

UIColor *MZL_NAVBAR_TINT_COLOR() {
    return colorWithHexString(@"#b9b9b9");
}

UIFont *MZL_NAVBAR_TITLE_FONT() {
    return MZL_BOLD_FONT(17.0);
}

UIColor *MZL_COLOR_BLACK_555555() {
    return colorWithHexString(@"#555555");
}

UIColor *MZL_COLOR_GREEN_61BAB3() {
    return colorWithHexString(@"#61bab3");
}

UIColor *MZL_COLOR_GREEN_A1E2D5() {
    return colorWithHexString(@"#A1E2D5");
}

UIColor *MZL_COLOR_GREEN_85DDCC() {
    return colorWithHexString(@"#85ddcc");
}

UIColor *MZL_COLOR_YELLOW_STATUSBAR() {
    return colorWithHexString(@"#ffeea1");
}

UIColor *MZL_COLOR_YELLOW_FDD414() {
    return colorWithHexString(@"#fdd414");
}

UIColor *MZL_COLOR_BLACK_999999() {
    return colorWithHexString(@"#999999");
}

UIColor *MZL_COLOR_GRAY_F2F2F2() {
    return colorWithHexString(@"#f2f2f2");
}

UIColor *MZL_COLOR_GRAY_F7F7F7() {
    return colorWithHexString(@"#f7f7f7");
}

UIColor *MZL_COLOR_GRAY_B2B2B2() {
    return colorWithHexString(@"#B2B2B2");
}

UIColor *MZL_COLOR_GRAY_7F7F7F() {
    return colorWithHexString(@"#7F7F7F");
}

UIColor *MZL_BG_COLOR() {
    return MZL_COLOR_GRAY_F7F7F7();
}

UIColor *MZL_SEPARATORS_BG_COLOR() {
    return MZL_COLOR_GRAY_B2B2B2();
}

UIColor *MZL_TAB_SEPARATOR_COLOR() {
    return [UIColor lightGrayColor];
}

#pragma mark - story boards

UIStoryboard *MZL_MODEL_STORYBOARD() {
    return [UIStoryboard co_storyboardWithName:@"ModelController"];
}

UIStoryboard *MZL_MAIN_STORYBOARD() {
    return [UIStoryboard co_storyboardWithName:@"Main_iPhone"];
}

UIStoryboard *MZL_SHORT_ARTICLE_STORYBOARD() {
    return [UIStoryboard co_storyboardWithName:@"ShortArticle"];
}



