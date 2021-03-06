//
//  XMFGoodsRecommendView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/9.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsRecommendModel;
@class XMFGoodsRecommendView;

@protocol XMFGoodsRecommendViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)goodsRecommendCellOnXMFGoodsRecommendViewDidSelected:(XMFGoodsRecommendView *)recommendView recommendModel:(XMFGoodsRecommendModel *)recommendModel;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end



@interface XMFGoodsRecommendView : UIView

@property (nonatomic, strong) NSMutableArray *dataSourceArr;


@property (nonatomic, weak) id<XMFGoodsRecommendViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
