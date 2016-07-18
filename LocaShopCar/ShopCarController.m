//
//  ShopCarController.m
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "ShopCarController.h"
#import "MJExtension.h"
#import "ShopCarModel.h"
#import "GoodsCell.h"
#import "LTDBShopCar.h"
#import "ShopCarGruopModel.h"

@interface ShopCarController ()<UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray * cellDatas;

@end

@implementation ShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次将要进入前清除数据
    [self.cellDatas removeAllObjects];
    //从数据库获取数据
    NSArray * arr = [[LTDBShopCar shareInstance] getShopCarModel];
   [self.cellDatas addObjectsFromArray:arr];
    [self.tableView reloadData];
}

//懒加载
- (NSMutableArray *)cellDatas
{
    if (!_cellDatas) {
        _cellDatas = [NSMutableArray array];
    }
    
    return _cellDatas;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCarGruopModel *groupModel = self.cellDatas[section];
    UILabel * headerLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerLbl.backgroundColor = [UIColor whiteColor];
    headerLbl.textColor = [UIColor blueColor];
    headerLbl.text = [NSString stringWithFormat:@"   %@",groupModel.shopName];
    return headerLbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShopCarGruopModel *groupModel = self.cellDatas[section];
    return groupModel.goods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCarGruopModel *groupModel = self.cellDatas[indexPath.section];
    GoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCarCell"];
    cell.cellType = ShopCarCellType;
    [cell cellDataWithModel:groupModel.goods[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(){
        [weakSelf dealDeleteResult:indexPath];
    };
    return cell;
}

//删除购物车数据
- (void)dealDeleteResult:(NSIndexPath *)indexPath
{
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * rightAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ShopCarGruopModel *groupModel = self.cellDatas[indexPath.section];
            [[LTDBShopCar shareInstance] deleteShopCarModel:groupModel.goods[indexPath.row]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [groupModel.goods removeObjectAtIndex:indexPath.row];
                
                if (groupModel.goods.count == 0) {
                    [self.cellDatas removeObjectAtIndex:indexPath.section];
                    [self.tableView reloadData];
                }else{
                   [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
                }
                
                
            });
            
        });
    }];
    [alertVc addAction:leftAction];
    [alertVc addAction:rightAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

@end
