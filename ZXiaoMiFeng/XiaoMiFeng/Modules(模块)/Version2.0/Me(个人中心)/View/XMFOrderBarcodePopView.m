//
//  XMFOrderBarcodePopView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/22.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderBarcodePopView.h"
#import "XMFMyOrdersListModel.h"//我的订单总model


//在.m文件中添加
@interface  XMFOrderBarcodePopView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewHeight;


@end

@implementation XMFOrderBarcodePopView

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
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //背景view圆角
    [self.bgView cornerWithRadius:10.f];
}



//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
         self.frame = [UIScreen mainScreen].bounds;
         [keyWindow addSubview:self];
        
    } completion:^(BOOL finished) {
        
 
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self removeFromSuperview];

        
    } completion:^(BOOL finished) {
        
        
    }];
    
}


//确定按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    [self hide];
    
}


-(void)setDetailModel:(XMFMyOrdersListModel *)detailModel{
    
    _detailModel = detailModel;
    
    
    NSInteger cellCount = detailModel.freeTaxBarCode.count > 3 ? 3 : detailModel.freeTaxBarCode.count;
    
    self.myTableViewHeight.constant = cellCount * 26.f;
    
    [self.myTableView reloadData];
    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        
    return self.detailModel.freeTaxBarCode.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"防伪袋条码%zd:%@",indexPath.row + 1,self.detailModel.freeTaxBarCode[indexPath.row]];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
            
    return 26.f;
    
}


@end
