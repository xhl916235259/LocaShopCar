//
//  GoodsCell.h
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GoodsCellType,
    ShopCarCellType,

} CellType;

@class ShopCarGruopModel;
@interface GoodsCell : UITableViewCell

- (void) cellDataWithModel:(NSIndexPath*)indexPath andGroupModel:(ShopCarGruopModel *)model;

/** 选中回调 */
@property (nonatomic,copy) dispatch_block_t callBlock;

/** 购买点击回调 */
@property (nonatomic,copy) dispatch_block_t btBlock;

/** 删除回调 */
@property (nonatomic,copy) dispatch_block_t deleteBlock;

/** cell类型 */
@property (nonatomic,assign) CellType  cellType;


@end
