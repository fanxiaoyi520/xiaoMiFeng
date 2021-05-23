//
//  XMFShopCartModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/29.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/*****************最里面层的model,字段goodsId、price、goodsSn*******************/
@interface  XMFShopCartDetailModel:NSObject

@property (nonatomic, copy) NSString *cartId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *goodsSn;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) NSArray *specifications;

//@property (nonatomic, copy) NSString *checked;

/** 记录是否选中*/
@property (nonatomic,assign)BOOL  isChoose;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *shipmentRegion;

@property (nonatomic, copy) NSString *taxes;


//是否包邮
@property (nonatomic, copy) NSString *freeShipping;

//是否包税
@property (nonatomic, copy) NSString *taxFlag;

//限购数量
@property (nonatomic, copy) NSString *limitBuyNum;

@end



/**************************中间层model,字段name********************************/
@interface  XMFShopCartMiddleModel: NSObject


/** 店铺名称，地区名称*/
@property (nonatomic,copy)NSString *shipmentRegion;

/** 存放model*/
@property (nonatomic,strong)NSMutableArray <XMFShopCartDetailModel *>*cartMiddleList;



/** 区头是否选中*/
@property (nonatomic,assign)BOOL  isChoose;

/** 每个区的价格总和*/
@property (nonatomic,assign)NSInteger sectionTotalPrice;

/** 记录选中的cell*/
@property (nonatomic,strong)NSMutableArray *recordCdModelSelected ;


/** 记录选中的行*/
@property (nonatomic,assign)NSInteger  indexPathRow;

/** 记录选中的区*/
@property (nonatomic,assign)NSInteger  indexPathSection;



@end



/**************************最外层model,字段name********************************/
@interface XMFShopCartModel : NSObject


/** 记录区是否被全选*/
@property (nonatomic,strong)NSMutableArray *recordArr;

/** 存放model*/
@property (nonatomic,strong)NSMutableArray <XMFShopCartMiddleModel *> *cartNewList;


/**原先的 存放model*/
@property (nonatomic,strong)NSMutableArray <XMFShopCartDetailModel *> *cartList;


@end

NS_ASSUME_NONNULL_END
