//
//  XMFGoodsDatailModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFGoodsDetailSpecificationListModel;
@class XMFGoodsDatailInfoModel;
@class XMFGoodsDatailProductListModel;
@class XMFGoodsDetailIssueModel;
@class XMFGoodsDetailAttributeModel;

@interface XMFGoodsDatailModel : NSObject

@property (nonatomic, strong) XMFGoodsDatailInfoModel * info;

@property (nonatomic, strong) NSArray<XMFGoodsDatailProductListModel *> * productList;

@property (nonatomic, strong) NSArray<XMFGoodsDetailSpecificationListModel *> * specificationList;

@property (nonatomic, strong) NSArray<XMFGoodsDetailIssueModel *> *issue;

@property (nonatomic, strong) NSArray<XMFGoodsDetailAttributeModel *> *attribute;

//是否收藏
@property (nonatomic, copy) NSString *userHasCollect;


//人工加入：选择的规格
@property (nonatomic, copy) NSString *specificationsStr;

//人工加入：选择的类型
@property (nonatomic, assign) NSInteger goodsChooseType;

//人工加入：商品详情数组
@property (nonatomic, strong) NSMutableArray *galleryURLArr;



@end

NS_ASSUME_NONNULL_END
