//
//  MZLModelAuthorDetail.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-4-25.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLModelObject.h"
#import "MZLModelAuthor.h"

@interface MZLModelAuthorDetail : MZLModelAuthor

@property (nonatomic, assign) NSInteger totalLocationCount;
@property (nonatomic, assign) BOOL isSignedWriter;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, strong) NSArray *articles;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, strong) MZLModelImage *cover;

@property(nonatomic, readonly) NSString *coverUrl;


@end
