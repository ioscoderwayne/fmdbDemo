//
//  QueueViewController.m
//  FmdbDemo
//
//  Created by weixiaoyang on 2016/11/16.
//  Copyright © 2016年 weixiaoyang. All rights reserved.
// 线程安全的方式

#import "QueueViewController.h"
#import "FMDB.h"

@interface QueueViewController ()

@property (nonatomic,strong) FMDatabaseQueue *queue;

- (IBAction)queryBtnClicked;
- (IBAction)insertBtnClicked;
- (IBAction)updateBtnClicked;
- (IBAction)deleteBtnClicked;
- (IBAction)transactionBtnClicked;


@end

@implementation QueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化Student 数据库
    [self setupDataBase];
    
}
/**
 *  初始化Student数据库
 */
-(void)setupDataBase
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"Student.db"];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        if([db open]){
            //打开成功 创建Student表
            NSString *sql = @"create table if not exists student('id' integer primary key autoincrement not null, 'name' varchar(30),'age' integer)";
           BOOL success = [db executeUpdate:sql];
            if (success) {
                NSLog(@"创建student表成功");
            }else{
                NSLog(@"创建student表失败==%@",[db lastErrorMessage]);

            }
        }else{
            NSLog(@"数据库打开失败==%@",[db lastErrorMessage]);
        }
        
        [db close];
    }];
}

- (IBAction)queryBtnClicked {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            //查询语句
            NSString *sql = @"select * from student";
            //执行sql语句
            FMResultSet *set = [db executeQuery:sql];
            
            while ([set next]) {
                NSLog(@"student====%@===%d",[set stringForColumn:@"name"],[set intForColumn:@"age"]);
            }
            //关闭数据库
            [db close];
        }
    }];

}

- (IBAction)insertBtnClicked {
    [self.queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            NSString *name = @"jack";
            NSInteger age = 20;
            //插入语句
            NSString *sql = @"insert into student(name,age) values(?,?)";
            //执行sql语句
            BOOL success = [db executeUpdate:sql,name,@(age)];
            if (success) {
                NSLog(@"插入数据成功");
            }else{
                NSLog(@"插入数据失败==%@",[db lastErrorMessage]);
            }
            
            //关闭数据库
            [db close];
        }
    }];

}

- (IBAction)updateBtnClicked {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            //删除语句
            NSString *sql = @"update student set name = 'rose' where name = 'jack'";
            //执行sql语句
            BOOL success = [db executeUpdate:sql];
            if (success) {
                NSLog(@"更新student数据成功");
            }else{
                NSLog(@"更新student数据失败==%@",[db lastErrorMessage]);
            }
            
            //关闭数据库
            [db close];
        }
    }];

}

- (IBAction)deleteBtnClicked {
    [self.queue inDatabase:^(FMDatabase *db) {
        if (db.open) {
            //删除语句
            NSString *sql = @"delete from student";
            //执行sql语句
            BOOL success = [db executeUpdate:sql];
            if (success) {
                NSLog(@"删除student数据成功");
            }else{
                NSLog(@"删除student数据失败==%@",[db lastErrorMessage]);
            }
            
            //关闭数据库
            [db close];
        }
    }];

}

- (IBAction)transactionBtnClicked {
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
       
        if ([db open]) {
            NSString *name = @"lily";
            NSInteger age = 25;
            //插入语句
            NSString *sql = @"insert into student(name,age) values(?,?)";
            [db executeUpdate:sql,name,@(age)];
            
            BOOL somethingwrong = NO;
            
            if (somethingwrong) {
                *rollback = YES;
                return;
            }
            
            [db close];
        }
        
    }];
}
@end
