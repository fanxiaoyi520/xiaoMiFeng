//
//  XMFMyAuthenticationListCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/21.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyAuthenticationListCell.h"
#import "XMFMyAuthenticationListModel.h"


//在.m文件中添加
@interface  XMFMyAuthenticationListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLB;


@property (weak, nonatomic) IBOutlet UILabel *identityIDLB;


@property (weak, nonatomic) IBOutlet KKPaddingLabel *statusLB;





@end

@implementation XMFMyAuthenticationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(XMFMyAuthenticationListModel *)model{
    
    _model = model;
    
    self.nameLB.text = model.realName;
    
    self.identityIDLB.text = model.idCardNo;
    
}

@end
