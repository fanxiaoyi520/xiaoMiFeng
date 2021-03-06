//
//  XMFGoodsCommentsImageCell.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/11.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFGoodsCommentsImageCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageNameStr;

//å¾çç¹å»Block
@property (nonatomic, copy) void (^commentsImageViewBlock)(UIImageView *tapImageView);

@end

NS_ASSUME_NONNULL_END
