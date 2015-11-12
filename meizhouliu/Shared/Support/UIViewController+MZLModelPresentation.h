//
//  UIViewController+MZLModelPresentation.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MZLModelPresentation) <UINavigationBarDelegate>

- (void)initWithStatusBar:(UIView *)statusBar navBar:(UINavigationBar *)navBar;

@end
