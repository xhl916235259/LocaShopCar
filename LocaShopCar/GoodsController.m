//
//  GoodsController.m
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "GoodsController.h"
#import "MJExtension.h"
#import "ShopCarModel.h"
#import "ShopCarGruopModel.h"
#import "GoodsCell.h"
#import "LTDBShopCar.h"

@interface GoodsController ()<UITableViewDataSource>

@property (strong,nonatomic) NSMutableArray * cellDatas;

@end

@implementation GoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)cellDatas
{
    if (!_cellDatas) {
        _cellDatas = [NSMutableArray array];
        
        //模型嵌套
        [ShopCarGruopModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"goods" : @"ShopCarModel",
                     // @"statuses" : [Status class]
                     };
        }];
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"GuoupGood.plist" ofType:nil];
        
        [_cellDatas addObjectsFromArray:[ShopCarGruopModel mj_objectArrayWithFile:path]];
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
    GoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell"];
    [cell cellDataWithModel:groupModel.goods[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self) weakSelf = self;
    cell.btBlock = ^(){
        [weakSelf dealWithResult:indexPath];
    };
    return cell;
}

//添加到数据库
- (void)dealWithResult:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%@行购买",@(indexPath.row));
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否购买" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * rightAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ShopCarGruopModel *groupModel = self.cellDatas[indexPath.section];
        [[LTDBShopCar shareInstance] insertUser:groupModel.goods[indexPath.row]];
    }];
    [alertVc addAction:leftAction];
    [alertVc addAction:rightAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

@end
