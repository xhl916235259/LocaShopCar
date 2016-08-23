//
//  ShopCarHeaderView.m
//  LocaShopCar
//
//  Created by letian on 16/8/23.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "ShopCarHeaderView.h"
#import "ShopCarGruopModel.h"
#import "ShopCarModel.h"

@interface ShopCarHeaderView ()

/** label */
@property (nonatomic,weak) UILabel * shopName;

/** 全选button */
@property (nonatomic,weak) UIButton * selectButton;

/** 实体 */
@property (nonatomic,strong) ShopCarGruopModel * model;


@end


@implementation ShopCarHeaderView


+ (instancetype)backHeaderViewWithTableView:(UITableView *)tableView
{
    ShopCarHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    
    if (headerView == nil) {
        headerView = [[ShopCarHeaderView alloc] initWithReuseIdentifier:NSStringFromClass(self)];
    }
    return headerView;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:selectButton];
        selectButton.frame = CGRectMake(9, 0, 40, 40);
        [selectButton addTarget:self action:@selector(viewClick) forControlEvents:UIControlEventTouchUpInside];
        self.selectButton = selectButton;
        
        UILabel * headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(49, 0, [UIScreen mainScreen].bounds.size.width-40, 40)];
        headerLbl.backgroundColor = [UIColor whiteColor];
        headerLbl.textColor = [UIColor blueColor];
        [self.contentView addSubview:headerLbl];
        self.shopName = headerLbl;
    }
    
    return self;
}

- (void)headerViewDataWtihModel:(ShopCarGruopModel *)model;
{
    self.model = model;
    
    self.shopName.text = [NSString stringWithFormat:@"   %@",model.shopName];
    
    UIImage * selectImg = model.isSelect ? [UIImage imageNamed:@"tm_mcart_checked"] : [UIImage imageNamed:@"tm_mcart_unchecked"];
    [self.selectButton setImage:selectImg forState:UIControlStateNormal];
}

- (void)viewClick
{
    self.model.select = !self.model.select;
    
    for (ShopCarModel * model in self.model.goods) {
        model.select = self.model.select;
    }
    
    if (self.callBack) {
        self.callBack();
    }
}

@end
