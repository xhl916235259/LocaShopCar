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
#import "ShopCarHeaderView.h"

@interface ShopCarController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttomChooseBt;
@property (strong,nonatomic) NSMutableArray * cellDatas;
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;

@end

@implementation ShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self allIsSelect];
    [self.tableView reloadData];
    [self settingTotalPrice];
}

/**
 *  处理选中状态
 */
- (void)allIsSelect
{
    //从数据库获取数据
    NSArray * arr = [[LTDBShopCar shareInstance] getShopCarModel];
    
    
    [arr enumerateObjectsUsingBlock:^(ShopCarGruopModel * groupModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //
        if (self.cellDatas.count > idx) {
            
            ShopCarGruopModel * localModel = self.cellDatas[idx];
            
            groupModel.select = localModel.select;
            
            [groupModel.goods enumerateObjectsUsingBlock:^(ShopCarModel * carObj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (localModel.goods.count > idx) {
                    
                    ShopCarModel * model = localModel.goods[idx];
                    carObj.select = model.select;
                }
                
            }];
        }
        
    }];
    
    //每次将要进入前清除数据,判断选中状态之后清除
    [self.cellDatas removeAllObjects];
    //添加
    [self.cellDatas addObjectsFromArray:arr];

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
    __weak typeof(self) weakSelf = self;
    ShopCarGruopModel *groupModel = self.cellDatas[section];
    ShopCarHeaderView * headerView = [ShopCarHeaderView backHeaderViewWithTableView:tableView];
    [headerView headerViewDataWtihModel:groupModel];
    headerView.callBack = ^(){
        [weakSelf reloadTableViewWithSection:section];
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
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
    [cell cellDataWithModel:indexPath andGroupModel:groupModel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(){
        [weakSelf dealDeleteResult:indexPath];
    };
    cell.callBlock = ^(){
        [weakSelf reloadTableViewWithSection:indexPath.section];
    };

    return cell;
}

- (void)reloadTableViewWithSection:(NSInteger)section
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    [self settingTotalPrice];
}

- (IBAction)buttomTotalPrice:(id)sender {
    
    BOOL isSelect = ![[[self buttomInfo] valueForKey:@"isSelect"] boolValue];
    [self.cellDatas enumerateObjectsUsingBlock:^(ShopCarGruopModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.select = isSelect;
        [obj.goods enumerateObjectsUsingBlock:^(ShopCarModel * carObj, NSUInteger idx, BOOL * _Nonnull stop) {
            carObj.select = isSelect;
        }];
    }];
    [self settingTotalPrice];
    [self.tableView reloadData];
}

//是否全选,选中商品的总价，选中商品的数量
- (NSDictionary *)buttomInfo
{
    __block BOOL isSelect = NO;
    __block double allPrice = 0.00;
    __block int    selectCOunt = 0;
    [self.cellDatas enumerateObjectsUsingBlock:^(ShopCarGruopModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj.goods enumerateObjectsUsingBlock:^(ShopCarModel * carModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if (carModel.isSelect == YES) {
                allPrice += carModel.price * carModel.goodsSelectCount;
                selectCOunt += carModel.goodsSelectCount;
            }
        }];
        
        if (obj.select == NO) {//如果为当前有商品未被选中，跳出循环
            isSelect = NO;
            *stop = YES;
        }else if (idx == (self.cellDatas.count -1 )){
            isSelect = YES;
        }
        
        
    }];
    NSDictionary * buttomInfo = @{@"allPrice":@(allPrice),
                                  @"selectCOunt":@(selectCOunt),
                                  @"isSelect":@(isSelect)};
    return buttomInfo;
}

/**
 *  设置底部总价信息
 */
- (void)settingTotalPrice
{
    //设置图片
    UIImage * selectImg = [[[self buttomInfo] valueForKey:@"isSelect"] boolValue]? [UIImage imageNamed:@"tm_mcart_checked"] : [UIImage imageNamed:@"tm_mcart_unchecked"];
    [self.buttomChooseBt setImage:selectImg forState:UIControlStateNormal];
    
    //设置购买数量
    int count = [[[self buttomInfo] objectForKey:@"selectCOunt"] intValue];
    self.numberLbl.text = [NSString stringWithFormat:@"数量: %d",count];
    
    //设置总价
    double allPrice = [[[self buttomInfo] objectForKey:@"allPrice"] doubleValue];
    self.totalPriceLbl.text = [NSString stringWithFormat:@"总价: %.2f",allPrice];
    
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
                
                [self settingTotalPrice];
                
                
            });
            
        });
    }];
    [alertVc addAction:leftAction];
    [alertVc addAction:rightAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}

@end
