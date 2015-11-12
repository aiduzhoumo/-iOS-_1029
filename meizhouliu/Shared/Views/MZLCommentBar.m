//
//  MZLMZLCommentBar.m
//  mzl_mobile_ios
//
//  Created by race on 14-8-27.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLCommentBar.h"
#import "MZLArticleCommentViewController.h"

#define PLACEHOLDER_TEXT @"添加评论"
#define COMMENT_LINE_HEIGHT MZL_HEIGHT_COMMENT_BAR
#define COMMENT_TOTAL_BYTE 9
#define MAX_LENGTH_COMMENT 140
#define COMMENT_LENGTH_TIP_FORMAT @"%@ / %@"

@implementation MZLCommentBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (id)commentBarInstance:(CGSize)parentViewSize {
    MZLCommentBar *result = [MZLCommentBar viewFromNib:@"MZLCommentBar"];
    result.heightOfView = parentViewSize.height;
    result.frame = CGRectMake(0, parentViewSize.height - COMMENT_LINE_HEIGHT, parentViewSize.width, COMMENT_LINE_HEIGHT);
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentViewSize.width, 0.5)];
    [topLine setBackgroundColor:colorWithHexString(@"cccccc")];
    [result addSubview:topLine];
    [result initInternal:result];
    return result;
}


#pragma mark - common

- (NSString *)commentLengthTip:(NSInteger)currentLength {
    return [NSString stringWithFormat:COMMENT_LENGTH_TIP_FORMAT, @(currentLength), @(MAX_LENGTH_COMMENT)];
}

- (NSString *)commentLengthTip {
    return [self commentLengthTip:0];
}

- (void)initInternal:(MZLCommentBar *) result {
    result.textComment.delegate =result;
    [result.btnComment addTarget:result action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
    [result.textComment.layer setBorderColor:[colorWithHexString(@"#cccccc") CGColor]];
    [result.textComment.layer setBorderWidth:0.5];
    [result.textComment.layer setCornerRadius:4];
    [result.lblCurrentByte setTextColor:MZL_COLOR_BLACK_999999()];
    [result.lblPlaceHolder setTintColor:MZL_COLOR_BLACK_999999()];
    [result.btnComment setTitleColor:MZL_COLOR_BLACK_999999() forState:UIControlStateNormal];
    [result.lblCurrentByte setText:[self commentLengthTip]];
}

- (void)adjustToKeyboardHeight:(UITextView *)textView {
    if (textView.contentSize.height > 90) {
        //TO DO
        return;
        
    }
    CGRect newFrame = self.frame;
    CGFloat distance = newFrame.size.height - textView.contentSize.height - 16;
    newFrame.size.height = textView.contentSize.height + 16;
    newFrame.origin.y += distance;
    self.frame = newFrame;
}

- (void)resetCommentBar {
    [self.textComment resignFirstResponder];
    [self.textComment setText:@""];
    [self.lblPlaceHolder setText:PLACEHOLDER_TEXT];
    CGRect newFrame = self.frame;
    newFrame.size.height = COMMENT_LINE_HEIGHT;
    newFrame.origin.y = self.heightOfView - COMMENT_LINE_HEIGHT;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
    }];
    [self.lblCurrentByte setText:[self commentLengthTip]];
    [self.btnComment setTitleColor:MZL_COLOR_BLACK_999999() forState:UIControlStateNormal];
}

- (void)toComment{
    NSString *content = self.textComment.text;
    if (isEmptyString(content)) {
        return;
    } else if (content.length > 140) {
        [UIAlertView showAlertMessage:[NSString stringWithFormat:@"评论内容太长了哟（最多%d个字）！", MAX_LENGTH_COMMENT]];
        return;
    }
    [self.ownerController addComment];
}


#pragma mark - text view delegate

- (NSUInteger)numberOfLinesInTextView:(UITextView *)textView
{
    NSLayoutManager *layoutManager = [textView layoutManager];
    NSUInteger index, numberOfLines;
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:[textView textContainer]];
    NSRange lineRange;
    for (numberOfLines = 0, index = glyphRange.location; index < glyphRange.length; numberOfLines++){
        (void) [layoutManager lineFragmentRectForGlyphAtIndex:index
                                               effectiveRange:&lineRange];
        index = NSMaxRange(lineRange);
    }
    return numberOfLines;
}

#pragma mark - textView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self.lblPlaceHolder setText:PLACEHOLDER_TEXT];
        [self.btnComment setTitleColor:MZL_COLOR_BLACK_999999() forState:UIControlStateNormal];
    }else{
        [self.lblPlaceHolder setText:@""];
        [self.btnComment setTitleColor:colorWithHexString(@"#fdd414") forState:UIControlStateNormal];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {}

- (void)textViewDidChange:(UITextView *)textView {
    [self adjustToKeyboardHeight:textView];
    //当字数超过140，字体颜色变红
    if (textView.text.length >= MAX_LENGTH_COMMENT) {
        [self.lblCurrentByte setTextColor:[UIColor redColor]];
    }else{
        [self.lblCurrentByte setTextColor:MZL_COLOR_BLACK_999999()];
    }
    //reset placeholder and comment button
    if (textView.text.length == 0) {
        [self.lblPlaceHolder setText:PLACEHOLDER_TEXT];
         [self.btnComment setTitleColor:MZL_COLOR_BLACK_999999() forState:UIControlStateNormal];
    }else{
        [self.lblPlaceHolder setText:@""];
        [self.btnComment setTitleColor:colorWithHexString(@"#fdd414") forState:UIControlStateNormal];
    }
    
    [self.lblCurrentByte setText:[self commentLengthTip:textView.text.length]];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Disable emoji input
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage])
    {
        [UIAlertView showAlertMessage:@"暂时不支持emoji表情哦~" title:@"温馨提示"];
        return NO;
    }
    return YES;
}

@end
