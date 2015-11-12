//
//  MZLCommentResponse.h
//  mzl_mobile_ios
//
//  Created by Whitman on 14-8-26.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLServiceResponseObject.h"
#import "MZLModelComment.h"

@interface MZLCommentResponse : MZLServiceResponseObject

@property (nonatomic, strong) MZLModelComment *comment;

@end
