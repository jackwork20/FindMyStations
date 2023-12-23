//
//  FeedDetailModel.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedDetailModel : NSObject

@property (nonatomic, strong) NSString      *fileId;

@property (nonatomic, strong) NSString      *coverUrl;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *videoIntroduce;
@property (nonatomic, strong) NSString      *videoDesStr;

@end

NS_ASSUME_NONNULL_END
