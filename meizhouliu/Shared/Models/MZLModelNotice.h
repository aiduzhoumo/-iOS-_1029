//
//  MZLModelNotice.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-3.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"

@interface MZLModelNotice : MZLModelObject<NSCoding>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *editedDate;

@property (nonatomic, assign) BOOL isRead;

- (BOOL)isEmptyNotice;
- (void)update:(MZLModelNotice *)src;


@end
