//
//  XMFShoppingCartChangedView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartChangedView.h"
#import "XMFShoppingCartChangedCell.h"
#import "XMFShoppingCartCellModel.h"


//在.m文件中添加
@interface  XMFShoppingCartChangedView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;






@end


@implementation XMFShoppingCartChangedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.7);
    
    
    self.myTableView.dataSource = self;
    
    self.myTableView.delegate = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsVerticalScrollIndicator = YES;
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFShoppingCartChangedCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFShoppingCartChangedCell class])];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView cornerWithRadius:16.f direction:CornerDirectionTypeTopLeft | UIRectCornerTopRight];
    
}


//显示在整个界面上
-(void)show{
    
    //可以底部弹出
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


//隐藏弹框
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
 
    
}





//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//取消
            
            [self hide];
        }
            break;
            
        case 1:{//确认
            
            if (_sureBtnBlock) {
                _sureBtnBlock();
            }
            
            [self hide];
            
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)setDataSourceArr:(NSMutableArray<XMFShoppingCartCellGoodsModel *> *)dataSourceArr{
    
    
    _dataSourceArr = dataSourceArr;
    
    
    if (dataSourceArr.count > 3) {
        
        self.myTableViewHeight.constant =  3 * 150 + 37;

        
    }else{
        
        self.myTableViewHeight.constant = dataSourceArr.count* 150 + 37;
    }
    
    
    
    [self.myTableView reloadData];
    
    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.dataSourceArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFShoppingCartChangedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFShoppingCartChangedCell class])];
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.goodsModel = self.dataSourceArr[indexPath.row];
        
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    
    return 150;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UIView *headerView = [[UIView alloc]init];
    
    headerView.backgroundColor = KWhiteColor;
    
    XMFShoppingCartCellGoodsModel *goodsModel = [self.dataSourceArr firstObject];
    
    NSString *imageStr;
    
//    税号类型 1-蜜蜂国际 2-蜜蜂海淘
    if ([goodsModel.taxType isEqualToString:@"2"]) {
        
        imageStr = @"icon_haitao_60x17";
        
    }else{
        
        imageStr = @"icon_guoji_60x17";
    }
    
    UIImageView *headerImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
    
    
    [headerView addSubview:headerImgView];
    
    [headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.mas_equalTo(headerView.mas_left).offset(14);
        
        make.bottom.mas_equalTo(headerView.mas_bottom).offset(4);
        
    }];
    

    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 37;
}



@end
