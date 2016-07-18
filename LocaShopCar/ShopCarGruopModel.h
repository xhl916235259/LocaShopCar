//
//  ShopCarGruopModel.h
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarGruopModel : NSObject

/** 商家ID */
@property (nonatomic,copy) NSString * shopId;

/** 商家名字 */
@property (nonatomic,copy) NSString * shopName;

/** 商品集合 */
@property (nonatomic,strong) NSMutableArray * goods;

@end
