//
//  XMFChooseGoodsTypeCell.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/27.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailValueListModel;

@class XMFChooseGoodsTypeCell;

@protocol XMFChooseGoodsTypeCellDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFChooseGoodsTypeCellDidClick:(XMFChooseGoodsTypeCell *)cell button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFChooseGoodsTypeCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *standardBtn;

@property (nonatomic, strong) XMFGoodsDetailValueListModel *valueModel;

@property (nonatomic, weak) id<XMFChooseGoodsTypeCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
