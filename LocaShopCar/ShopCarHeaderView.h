//
//  ShopCarHeaderView.h
//  LocaShopCar
//
//  Created by letian on 16/8/23.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopCarGruopModel;
@interface ShopCarHeaderView : UITableViewHeaderFooterView

+ (instancetype)backHeaderViewWithTableView:(UITableView *)tableView;

- (void)headerViewDataWtihModel:(ShopCarGruopModel *)model;

/** 回调 */
@property (nonatomic,copy) dispatch_block_t callBack;

@end
