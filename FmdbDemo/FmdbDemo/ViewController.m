//
//  ViewController.m
//  FmdbDemo
//
//  Created by weixiaoyang on 2016/11/16.
//  Copyright © 2016年 weixiaoyang. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "QueueViewController.h"

@interface ViewController ()
@property (nonatomic,strong) FMDatabase *db;

- (IBAction)insertBtnClicked;
- (IBAction)updateBtnClicked;
- (IBAction)deleteBtnClicked;
- (IBAction)queryBtnClicked;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据库
    [self setupDatabase];
}

/**
 *  初始化数据库 并创建用户表
 */
- (void)setupDatabase
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"wayne.db"];
    
    //数据库为创建
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    self.db = db;
    //打开数据库
    if([db open]){
        //成功创建User表
        NSString *sql = @"create table if not exists user('id' integer primary key autoincrement not null, 'name' varchar(30),'password' varchar(30))";
       BOOL success = [db executeUpdate:sql];
        if (success) {
            NSLog(@"创建用户表成功");
        }else{
            NSLog(@"创建用户表失败==%@",[db lastErrorMessage]);
        }
        
    }else{
        NSLog(@"----数据库打开失败==%@",[db lastErrorMessage]);
    }
}
/**
 *  插入表格数据
 */
-(void)insertUserData
{
    if([self.db open]){
        NSString *sql = @"insert into user (name,password) values(?,?)";
        
        BOOL success = [self.db executeUpdate:sql,@"张三",@"123456" ];
        
        if (success) {
            NSLog(@"-----插入用户数据成功");
        }else{
            NSLog(@"----插入用户数据失败==%@",[self.db lastErrorMessage]);
            
        }
        [self.db close];
    }
    
}
- (IBAction)insertBtnClicked {
    [self insertUserData];
}

/**
 *  修改表格数据
 */
-(void)updateUserData
{
    if ([self.db open]) {
        NSString *sql = @"update user set name ='李四' where name = '张三'";
        BOOL success = [self.db executeUpdate:sql];
        
        if (success) {
            NSLog(@"=====数据更新成功");
        }else{
            NSLog(@"=====数据更新失败");
        }
        
        [self.db close];
    }
    
    
    
}
- (IBAction)updateBtnClicked {
    [self updateUserData];
}
/**
 *  查询表格数据
 */
-(void)queryUserData
{
    if ([self.db open]) {
        NSString *sql = @"select * from user";
        
        FMResultSet *set = [self.db executeQuery:sql];
        while ([set next]) {
            NSString *name = [set stringForColumnIndex:1];
            NSString *password = [set stringForColumnIndex:2];
            
            NSLog(@"qurey ==== %@==%@",name,password);
        }

        [set close];
        
        [self.db close];
    }
    
}


- (IBAction)queryBtnClicked {
    [self queryUserData];
}
/**
 *  删除表格数据
 */
-(void)deleteUserData
{
    if ([self.db open]) {
        NSString *sql = @"delete from user";
        
        BOOL success = [self.db executeUpdate:sql];
        
        if (success) {
            NSLog(@"-----删除所有用户数据成功");
        }else{
            NSLog(@"----删除所有用户数据失败==%@",[self.db lastErrorMessage]);
            
        }
        
        [self.db close];
    }
    
}

- (IBAction)deleteBtnClicked {
    [self deleteUserData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    QueueViewController *queueVc = [[QueueViewController alloc]init];
    
    [self presentViewController:queueVc animated:YES completion:nil];
}
@end
