//
//  XMFShoppingCartChangedView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/10/20.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFShoppingCartChangedView.h"
#import "XMFShoppingCartChangedCell.h"
#import "XMFShoppingCartCellModel.h"


//å¨.mæä»¶ä¸­æ·»å 
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


//æ¾ç¤ºå¨æ´ä¸ªçé¢ä¸
-(void)show{
    
    //å¯ä»¥åºé¨å¼¹åº
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//éèå¼¹æ¡
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


//éèå¼¹æ¡
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //å¤æ­ç¹å»çç¹æ¯å¦å¨æä¸ªåºåèå´å
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
 
    
}





//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//åæ¶
            
            [self hide];
        }
            break;
            
        case 1:{//ç¡®è®¤
            
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


#pragma mark - âââââââ tableViewçä»£çæ¹æ³åæ°æ®æº ââââââââ

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
    
//    ç¨å·ç±»å 1-èèå½é 2-èèæµ·æ·
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
