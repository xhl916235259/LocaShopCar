//
//  LTDBHelper.m
//  LocaShopCar
//
//  Created by xhl on 16/7/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "LTDBHelper.h"


@implementation LTDBHelper

//创建单例
+(LTDBHelper*)shareDatabase{
    static dispatch_once_t onceToken;
    static LTDBHelper *sharedInstance=nil;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[LTDBHelper alloc]init];
        [sharedInstance createDB];
    });
    [sharedInstance openDB];
    return sharedInstance;
}


//创建数据库课
-(void)createDB
{
    if(self.db != nil)
    {
        return;
    }
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbFilePath = [filePath stringByAppendingString:@"/cashe.db"];
    self.db = [FMDatabase databaseWithPath:dbFilePath];
}

//打开数据库
-(void)openDB
{
    if (![self.db open]) {
        [self.db open];
    }
    //为数据库设置缓存，提高查询效率
    [self.db setShouldCacheStatements:YES];
}


@end
