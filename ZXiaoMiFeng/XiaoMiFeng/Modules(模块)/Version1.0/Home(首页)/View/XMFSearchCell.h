//
//  XMFSearchCell.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/4/26.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFSearchCell : UICollectionViewCell

@property(nonatomic,copy)NSString *searchStr;

@property(nonatomic,strong)KKPaddingLabel *wordLabel;

/*! θΏεcellηsize */
- (CGSize)sizeForCell;

@end

NS_ASSUME_NONNULL_END
