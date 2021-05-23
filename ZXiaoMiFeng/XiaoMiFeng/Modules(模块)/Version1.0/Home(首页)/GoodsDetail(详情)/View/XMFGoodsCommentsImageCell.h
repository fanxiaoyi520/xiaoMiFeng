//
//  XMFGoodsCommentsImageCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFGoodsCommentsImageCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageNameStr;

//图片点击Block
@property (nonatomic, copy) void (^commentsImageViewBlock)(UIImageView *tapImageView);

@end

NS_ASSUME_NONNULL_END
