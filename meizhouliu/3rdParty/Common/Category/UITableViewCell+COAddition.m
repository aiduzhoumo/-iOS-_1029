//
//  UITableViewCell+COAddition.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-3.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UITableViewCell+COAddition.h"
#import "UIImage+COAdditions.h"

@implementation UITableViewCell (COAddition)

- (instancetype)co_initWithReuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (void)co_replaceDeleteControlWithImage:(UIImage *)image bgImage:(UIImage *)bgImage bgColor:(UIColor *)bgColor {
    [self co_replaceDeleteControlOnView:self image:image bgImage:bgImage bgColor:bgColor];
}

- (void)co_replaceDeleteControlOnView:(UIView *)view image:(UIImage *)image bgImage:(UIImage *)bgImage bgColor:(UIColor *)bgColor {
    for (UIView *subview in view.subviews)
    {
        /**
         // ios 6 or earlier compatibility
         if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"])
         {
         //we'll add a view to cover the default control as the image used has a transparent BG
         UIView *backgroundCoverDefaultControl = [[UIView alloc] initWithFrame:CGRectMake(0,0, 64, 33)];
         [backgroundCoverDefaultControl setBackgroundColor:[UIColor whiteColor]];//assuming your view has a white BG
         [[subview.subviews objectAtIndex:0] addSubview:backgroundCoverDefaultControl];
         UIImage *deleteImage = [UIImage imageNamed:delete_button_name];
         UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,deleteImage.size.width, deleteImage.size.height)];
         [deleteBtn setImage:[UIImage imageNamed:delete_button_name]];
         [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
         }
         */
        // this handles iOS7 and higher
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"])
        {
            // 删除除了“删除”button外的其它子控件
            for (UIView* innerSubView in subview.subviews) {
                if (! [innerSubView isKindOfClass:[UIButton class]]) {
                    [innerSubView removeFromSuperview];
                } else {
                    UIButton *deleteButton = (UIButton *)innerSubView;
                    [deleteButton setImage:image forState:UIControlStateNormal];
                    if (bgImage) {
                        [deleteButton setBackgroundImage:bgImage forState:UIControlStateNormal];
                    }
                    [deleteButton setBackgroundColor:bgColor];
                    [deleteButton setTitle:@"" forState:UIControlStateNormal];
                    for(UIView *btnSubView in deleteButton.subviews)
                    {
                        // 移除“删除”文字
                        if([btnSubView isKindOfClass:[UILabel class]])
                        {
                            [btnSubView removeFromSuperview];
                        }
                    }
                }
            }
            return;
        }
        if ([subview.subviews count] > 0){
            [self co_replaceDeleteControlOnView:subview image:image bgImage:bgImage bgColor:bgColor];
        }
    }
}

+ (NSString *)co_defaultReuseIdentifier {
    return NSStringFromClass(self);
}

@end
