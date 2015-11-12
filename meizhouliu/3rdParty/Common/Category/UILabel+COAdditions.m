//
//  UILabel+COAdditions.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-28.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UILabel+COAdditions.h"
#import "UIImage+COAdditions.h"

@implementation UILabel (COAdditions)

- (CGSize)textSizeForSingleLine {
    if (! self.text || self.text.length == 0) {
        return CGSizeMake(0.0, 0.0);
    }
    NSDictionary *attrs = @{NSFontAttributeName: self.font};
    return [self.text sizeWithAttributes:attrs];
}

- (void)co_addLeadingImage:(UIImage *)image imageFrame:(CGRect)frame spaceWidthBetweenImageAndTexts:(CGFloat)spaceWidth {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = image;
    if (frame.origin.y > 0) {
        frame = CGRectMake(frame.origin.x, -frame.origin.y, frame.size.width, frame.size.height);
    }
    imageAttachment.bounds = frame;
    NSAttributedString *imageAttrString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    [attrString appendAttributedString:imageAttrString];
    if (spaceWidth > 0) {
        NSTextAttachment *spaceImageAttachment = [[NSTextAttachment alloc] init];
        spaceImageAttachment.image = [UIImage imageWithColor:self.backgroundColor size:frame.size];
        spaceImageAttachment.bounds = CGRectMake(0, 0, spaceWidth, frame.size.height);
        NSAttributedString *spaceAttrString = [NSAttributedString attributedStringWithAttachment:spaceImageAttachment];
        [attrString appendAttributedString:spaceAttrString];
    }
    if (self.text.length > 0) {
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:self.text]];
    }
    self.attributedText = attrString;    
}

- (void)co_addLeadingImage:(UIImage *)image imageSize:(CGSize)imageSize spaceWidth:(CGFloat)width {
    CGFloat centerY = (self.font.lineHeight - imageSize.height) / 2;
    CGFloat y = centerY > 0 ? centerY : 0;
    [self co_addLeadingImage:image imageFrame:CGRectMake(0, y/2, imageSize.width, imageSize.height) spaceWidthBetweenImageAndTexts:width];
}

/** This method should be invoked after text has been set */
- (UILabel *)co_setLineSpacing:(CGFloat)lineSpacing {
    if (isEmptyString(self.text)) {
        return self;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragrahStyle range:NSMakeRange(0, self.text.length)];
    self.attributedText = attributedString;
    return self;
}

@end
