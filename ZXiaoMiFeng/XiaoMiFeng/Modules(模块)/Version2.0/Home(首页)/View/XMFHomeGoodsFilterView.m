//
//  XMFHomeGoodsFilterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/5.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsFilterView.h"
#import "XMFHomeGoodsFilterHeaderView.h"//筛选的组头view
#import "XMFHomeGoodsFilterPriceCell.h"//筛选的价格cell
#import "XMFHomeGoodsFilterCommonCell.h"//筛选的共用cell
#import "XMFHomeGoodsFilterModel.h"//筛选的model


//在.m文件中添加
@interface  XMFHomeGoodsFilterView()<UICollectionViewDataSource,UICollectionViewDelegate,XMFHomeGoodsFilterCommonCellDelegate,XMFHomeGoodsFilterPriceCellDelegate>


/** 筛选的view */
@property (weak, nonatomic) IBOutlet UIView *rightView;


/** 筛选的列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


/** 重置 */
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

/** 完成 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


/** 布局 */
@property (nonatomic , strong) UICollectionViewFlowLayout *filterFlowLayout;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsFilterModel *> *dataSourceArr;

/** 当前选中的indexPath */
@property (nonatomic , strong) NSIndexPath *currentIndexPath;

/** 选中的标签字典 */
@property (nonatomic, strong) NSMutableDictionary *selectedTagMutDic;

/** 输入价格cell的model */
@property (nonatomic, strong) XMFHomeGoodsFilterSonModel *inputPriceSonModel;

/** 来源类型 */
@property (nonatomic, assign) GoodsFilterViewFromType fromType;


@end

@implementation XMFHomeGoodsFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)xibGoodsFilterViewFromType:(GoodsFilterViewFromType)type{
    
    XMFHomeGoodsFilterView *filterView = [XMFHomeGoodsFilterView XMFLoadFromXIB];
    
    filterView.fromType = type;
    
    return filterView;
    
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0);

    [self setupUI];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat radius = 4.f;
    
    [self.resetBtn xw_roundedCornerWithCornerRadii:CGSizeMake(radius, radius) cornerColor:self.backgroundColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0x333333) borderWidth:1.f];
    
    [self.sureBtn cornerWithRadius:radius];
    
}

//布局
-(void)setupUI{
    
    
    self.myCollectionView.collectionViewLayout = self.filterFlowLayout;
        
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeGoodsFilterCommonCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeGoodsFilterCommonCell class])];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeGoodsFilterPriceCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeGoodsFilterPriceCell class])];
    
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeGoodsFilterHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFHomeGoodsFilterHeaderView class])];
    
    
//    XMFHomeGoodsFilterModel *model = self.dataSourceArr[0];
    
//    XMFHomeGoodsFilterSonModel *sonmodel = model.standardArr[0];
    
    
    
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 0:{//重置
            
            for (XMFHomeGoodsFilterModel *filterMode in self.dataSourceArr) {
                
                for (XMFHomeGoodsFilterSonModel *filterSonMode in filterMode.standardArr) {
                    
                    filterSonMode.tagSeleted = NO;
                    
                }
                
                
            }
            
            //输入价格框清空
            self.inputPriceSonModel.minPrice = @"";
            
            self.inputPriceSonModel.maxPrice = @"";
            
            
            [self.myCollectionView reloadData];
            
            
        }
            break;
            
        case 1:{//完成
            
            //提前清空字典
            [self.selectedTagMutDic removeAllObjects];
            
            for (int i = 0; i < self.dataSourceArr.count; ++i) {
                
                XMFHomeGoodsFilterModel *filterModel = self.dataSourceArr[i];
            
                for (int j = 0; j < filterModel.standardArr.count; ++j) {
                    
                    XMFHomeGoodsFilterSonModel *filterSonModel = filterModel.standardArr[j];
                    
                    if (filterSonModel.tagSeleted) {
                        //只保存选中的
                        if (i == 0) {
                            //第一组

                            if (j == 3) {
                                 //200以上标签数据
                                
                                [self.selectedTagMutDic setValue:@"200" forKey:@"bottomPrice"];
                                
                                [self.selectedTagMutDic removeObjectForKey:@"highestPrice"];
                                
                                
                            }else{
                                //其他价格标签数据
                                
                                NSArray *partArr = [filterSonModel.standard componentsSeparatedByString:@"-"];
                                
                                [self.selectedTagMutDic setValue:partArr[0] forKey:@"bottomPrice"];
                                
                                [self.selectedTagMutDic setValue:partArr[1] forKey:@"highestPrice"];
                            }
                            
                            
                        }else if (i == 1){
                            //第二组
                            
                            if (j == 0) {
                                
                                NSString * taxFlag =   filterSonModel.tagSeleted ? @"1" :@"0";
                                
                                [self.selectedTagMutDic setValue:taxFlag forKey:@"taxFlag"];
                                
                                
                            }else if (j == 1){
                                
                                NSString * freeShipping =   filterSonModel.tagSeleted ? @"1" :@"0";
                                                                
                                [self.selectedTagMutDic setValue:freeShipping forKey:@"freeShipping"];
                                
                            }

                            
                        }else if (i == 2){
                            //第三组
                            
                            [self.selectedTagMutDic setValue:@(j) forKey:@"orderType"];
                        }
                        
                    }
   

                }
                

                    
                //获取价格输入框数据
                if (self.inputPriceSonModel.maxPrice.length > 0) {
                    
                    
                    [self.selectedTagMutDic setValue:self.inputPriceSonModel.maxPrice forKey:@"highestPrice"];
                }
                
                if (self.inputPriceSonModel.minPrice.length > 0) {
                    
                    [self.selectedTagMutDic setValue:self.inputPriceSonModel.minPrice forKey:@"bottomPrice"];
                }

                
            }
            
        
            
            //执行代理方法
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeGoodsFilterViewDidClick:button:selectedDic:)]) {
                
                [self.delegate buttonsOnXMFHomeGoodsFilterViewDidClick:self button:sender selectedDic:[self.selectedTagMutDic mutableCopy]];
            }
            
            
            
            [self hide];
        }
            break;
            
        default:
            break;
    }
    
    
    
}





#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.dataSourceArr.count;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    XMFHomeGoodsFilterModel *filterModel = self.dataSourceArr[section];
    
    return filterModel.standardArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section == 0 && indexPath.item == 4) {
        //输入价格的cell
        
      XMFHomeGoodsFilterPriceCell  *priceCell = (XMFHomeGoodsFilterPriceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeGoodsFilterPriceCell class]) forIndexPath:indexPath];
        
        priceCell.delegate = self;
        
        
        priceCell.sonModel = self.inputPriceSonModel;
    
    
        return priceCell;
        
        
    }else{
        
        XMFHomeGoodsFilterCommonCell *commonCell = (XMFHomeGoodsFilterCommonCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeGoodsFilterCommonCell class]) forIndexPath:indexPath];
    
        commonCell.delegate = self;
        
        XMFHomeGoodsFilterModel *filterModel = self.dataSourceArr[indexPath.section];

        XMFHomeGoodsFilterSonModel *filterSonModel = filterModel.standardArr[indexPath.item];
        
        commonCell.sonModel = filterSonModel;
        
//        [commonCell.standardBtn setTitle:filterSonModel.standard forState:UIControlStateNormal];
        
        return commonCell;
        
    }
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
 
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        
        XMFHomeGoodsFilterHeaderView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFHomeGoodsFilterHeaderView class]) forIndexPath:indexPath];
        
        XMFHomeGoodsFilterModel *filterModel = self.dataSourceArr[indexPath.section];
        
        headView.titleLB.text = filterModel.title;
        
        return headView;
    
    }else {
        
         return nil;
    }
    

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(self.rightView.width, 20);
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.item == 4) {
        
        return CGSizeMake(self.rightView.width - 40,35.f);
        
    }else{
        
        return CGSizeMake((self.rightView.width - 40 - 15)/2,35.f);

    }

}


#pragma mark - ——————— XMFHomeGoodsFilterCommonCell代理方法 ————————

//点击cell标签
-(void)buttonsOnXMFHomeGoodsFilterCommonCellDidClick:(XMFHomeGoodsFilterCommonCell *)cell button:(UIButton *)button{
    
        
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    XMFHomeGoodsFilterModel *filterModel = self.dataSourceArr[indexPath.section];
    
    XMFHomeGoodsFilterSonModel  *filterSonModel = filterModel.standardArr[indexPath.row];
    
    
    /** 处理单选 */
    NSString *currentSeletedStr = [NSString string];
    
    
    if (filterModel.isMultipleSelect) {
        
        
    }else{
        
        for (XMFHomeGoodsFilterSonModel *sonModel in filterModel.standardArr) {
            
            if (sonModel.tagSeleted) {
                currentSeletedStr = sonModel.standard;
            }
            
            sonModel.tagSeleted = NO;
        }
        
        
    }
    
    
    
    if (self.currentIndexPath != indexPath/** 不是第一次选中 */) {
        
        if ([currentSeletedStr isEqualToString:filterSonModel.standard]) {
            
            filterSonModel.tagSeleted = NO;
            
        } else {
            
            filterSonModel.tagSeleted = !filterSonModel.tagSeleted ;
        }
        
        
        self.currentIndexPath = indexPath;
        
        
    }else{
        
        if ([currentSeletedStr isEqualToString:filterSonModel.standard]) {
            
            if (filterModel.isMultipleSelect) {
                
                filterSonModel.tagSeleted = YES;
                
            } else {
                
                filterSonModel.tagSeleted = NO;
                
            }
            
        } else {
            
            filterSonModel.tagSeleted = !filterSonModel.tagSeleted ;
            
        }
        
        self.currentIndexPath = nil;
        
        
    }
    
    
    
    //如果是点击了第一组的价格区间
    if (indexPath.section == 0) {
        
        if (filterSonModel.tagSeleted) {
            
            if (indexPath.row == 3) {
                
                self.inputPriceSonModel.maxPrice = @"";
                
                self.inputPriceSonModel.minPrice = @"200";
                
                
            }else{
                
                NSArray *partArr = [filterSonModel.standard componentsSeparatedByString:@"-"];
                
                self.inputPriceSonModel.minPrice = partArr[0];
                
                self.inputPriceSonModel.maxPrice = partArr[1];
                
                
            }
            

        }else{
            
            self.inputPriceSonModel.maxPrice = @"";
            
            self.inputPriceSonModel.minPrice = @"";
            
        }
        
        
    }
    
    
    
    
    
    
    [self.myCollectionView reloadData];
    
    
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [weakself.myCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
    });*/
}


#pragma mark - ——————— XMFHomeGoodsFilterPriceCell的代理方法 ————————

/** 输入发生改变的时候代理方法 */
-(void)textFieldOnXMFHomeGoodsFilterPriceCellInput:(XMFHomeGoodsFilterPriceCell *)cell filterSonModel:(XMFHomeGoodsFilterSonModel *)sonModel{
    
    
    /*
    if (sonModel.minPrice.length && sonModel.maxPrice.length) {
        if (sonModel.minPrice.doubleValue > sonModel.maxPrice.doubleValue) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最小价格不能大于最大价格,请重新选择" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            sonModel.minPrice = @"";
            sonModel.maxPrice = @"";
            [self.myCollectionView reloadData];
        }
    }*/
    
    
    
}


/** 输入结束的时候代理方法 */
-(void)textFieldOnXMFHomeGoodsFilterPriceCellEndInput:(XMFHomeGoodsFilterPriceCell *)cell filterSonModel:(XMFHomeGoodsFilterSonModel *)sonModel{
    
    /*
    if (sonModel.minPrice.length && sonModel.maxPrice.length) {
        if (sonModel.minPrice.doubleValue > sonModel.maxPrice.doubleValue) {
            
                        
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最小价格不能大于最大价格,请重新选择" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alert show];
            sonModel.minPrice = @"";
            sonModel.maxPrice = @"";
            [self.myCollectionView reloadData];
        }
    }*/
    
    
    //只要当价格输入框内有内容输入的时候就清掉选中的价格
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    XMFHomeGoodsFilterModel *filterModel = self.dataSourceArr[indexPath.section];
    
    for (XMFHomeGoodsFilterSonModel *sonModel in filterModel.standardArr) {
        
        sonModel.tagSeleted = NO;
        
        DLog(@"最小金额：%@",sonModel.minPrice);
    }
    
    
    [self.myCollectionView reloadData];
    
    
}


#pragma mark - ——————— 显示与隐藏方法 ————————


//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        //        self.frame = [UIScreen mainScreen].bounds;
        
        [keyWindow addSubview:self];
        
        self.frame = CGRectMake(0, 0, KScreenW, KScreenH);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
            
        }];
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0);

    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(KScreenW, 0, KScreenW, KScreenH);
        
    } completion:^(BOOL finished) {
        

    }];
    
}

//点击手势绑定方法
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.rightView.bounds fromView:self.rightView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
}


#pragma mark - ——————— 懒加载 ————————

- (UICollectionViewFlowLayout *)filterFlowLayout {
    if (_filterFlowLayout == nil) {
        _filterFlowLayout = [[UICollectionViewFlowLayout alloc]init];
        _filterFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _filterFlowLayout.minimumLineSpacing = 10.01f;
        _filterFlowLayout.minimumInteritemSpacing = 10.01f;
         _filterFlowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 30, 20);
    }
    return _filterFlowLayout;
}

-(NSMutableArray<XMFHomeGoodsFilterModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
        
        
        NSArray *dataArr;
        
        
        if (self.fromType == fromHomeSimpleVc) {
            
            dataArr = @[
            
                @{
                    
                    @"title":@"价格区间",
                    @"isMultipleSelect":@(NO),
                    @"standardArr":@[
            
                            @{@"standard":@"0-50"},
                    
                            @{@"standard":@"50-100"},
                            
                            @{@"standard":@"100-200"},
                            
                            @{@"standard":@"200以上"},
                            
                             @{@"standard":@"-"},
                    ],
                    

                },
                
                   @{
                        
                        @"title":@"服务",
                        @"isMultipleSelect":@(YES),
                        @"standardArr":@[
                
                                @{@"standard":@"包税"},
                        
                                @{@"standard":@"包邮"},
                                
                        ],

                    },
                
                
                   @{
                        
                        @"title":@"排序",
                        @"isMultipleSelect":@(NO),
                        @"standardArr":@[
                
                                @{@"standard":@"按销量"},
                        
                                @{@"standard":@"按综合"},
                                
                        ],

                    },
                
            
            ];
            
        }else{
            
          dataArr  = @[
            
                @{
                    
                    @"title":@"价格区间",
                    @"isMultipleSelect":@(NO),
                    @"standardArr":@[
            
                            @{@"standard":@"0-50"},
                    
                            @{@"standard":@"50-100"},
                            
                            @{@"standard":@"100-200"},
                            
                            @{@"standard":@"200以上"},
                            
                             @{@"standard":@"-"},
                    ],
                    

                },
                
                   @{
                        
                        @"title":@"服务",
                        @"isMultipleSelect":@(YES),
                        @"standardArr":@[
                
                                @{@"standard":@"包税"},
                        
                                @{@"standard":@"包邮"},
                                
                        ],

                    },

            
            ];
        }
        
        
        
        
        for (NSDictionary *dic in dataArr) {
            
            XMFHomeGoodsFilterModel *model = [XMFHomeGoodsFilterModel yy_modelWithDictionary:dic];
            
            [_dataSourceArr addObject:model];
            
        }
 
        
    }
    return _dataSourceArr;
    
}


-(NSMutableDictionary *)selectedTagMutDic{
    
    if (_selectedTagMutDic == nil) {
        _selectedTagMutDic = [[NSMutableDictionary alloc] init];
    }
    return _selectedTagMutDic;
    
}


-(XMFHomeGoodsFilterSonModel *)inputPriceSonModel{
    
    if (_inputPriceSonModel == nil) {
        _inputPriceSonModel = [[XMFHomeGoodsFilterSonModel alloc] init];
    }
    return _inputPriceSonModel;
    
}


@end
