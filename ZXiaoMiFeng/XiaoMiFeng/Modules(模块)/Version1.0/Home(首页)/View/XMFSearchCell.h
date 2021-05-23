//
//  XMFSearchCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFSearchCell : UICollectionViewCell

@property(nonatomic,copy)NSString *searchStr;

@property(nonatomic,strong)KKPaddingLabel *wordLabel;

/*! 返回cell的size */
- (CGSize)sizeForCell;

@end

NS_ASSUME_NONNULL_END
