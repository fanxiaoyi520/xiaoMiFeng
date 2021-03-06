//
//  XMFHomeGoodsFilterView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/5.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//ๆฅ่ชไบๅช้
typedef enum : NSUInteger {
    fromSearchResultVc,
    fromHomeSimpleVc,
} GoodsFilterViewFromType;


@class XMFHomeGoodsFilterView;

@protocol XMFHomeGoodsFilterViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeGoodsFilterViewDidClick:(XMFHomeGoodsFilterView *)filterView button:(UIButton *)button selectedDic:(NSMutableDictionary *)selectedTagDic;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeGoodsFilterView : UIView

-(void)show;

-(void)hide;


@property (nonatomic, weak) id<XMFHomeGoodsFilterViewDelegate> delegate;

/** ่ชๅฎไนๅๅปบๆนๆณ */
+(instancetype)xibGoodsFilterViewFromType:(GoodsFilterViewFromType)type;


@end

NS_ASSUME_NONNULL_END
