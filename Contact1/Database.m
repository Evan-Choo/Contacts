//
//  Database.m
//  Contact1
//
//  Created by Evan Choo on 6/28/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"

@interface Database()

@end

static Database *db;

@implementation Database

+(instancetype) defaultDb
{
    if(!db)
        db = [[Database alloc]init];
    
    return db;
}

-(bool) openDb:(NSString *)sqlName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"contacts.sqlite"];
    
    NSLog(@"Database Path: %@", dbPath);
    
    int result = sqlite3_open([dbPath UTF8String], &sqlite);
    
    if (result == SQLITE_OK) {
        return YES; //如果没有回自动创建
    }
    
    return NO;
}

//关闭数据库
- (BOOL)closeDb
{
    int result = sqlite3_close(sqlite);
    if (result == SQLITE_OK) {
        return YES;
    }
    return NO;
}

-(bool) createTable:(NSString *)tableName
{
    char *err;
    
    NSString *sql;
    
    sql = [NSString stringWithFormat:@"create table if not exists %@"
    "("
    "  id integer primary key autoincrement,"
    "  fname varchar(10),"
    "  lname varchar(10),"
    "  phnNum varchar(11) not null,"
    "  addr varchar(50),"
    "  gender integer not null"
    ")", tableName];
    
    NSLog(@"[Create SQL] : %@",sql);
    
    int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err);
    
    if (result == SQLITE_OK) {
        NSLog(@"[Create SQL] : %@",sql);
        return YES;
    }else {
        NSLog(@"[Create SQL] : Fail");
        NSLog(@"error = %s",err);
    }
    
    return NO;
}

-(bool) createColumn:(NSString *)column TableName:(NSString *)tableName
{
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"alter table %@ add %@",tableName,column];
    NSLog(@"[Create SQL] : %@",sql);
    
    int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err);
    
    if (result == SQLITE_OK) {
        NSLog(@"[Create SQL] : OK");
        return YES;
    }else {
        NSLog(@"[Create SQL] : Fail");
        NSLog(@"error = %s",err);
    }
    
    return NO;
}

//增加数据
- (BOOL)insertSQLWithColumnName:(NSString *)columnName columnValue:(NSString *)columnValue tableName:(NSString *)tableName
{
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",tableName,columnName,columnValue];
    NSLog(@"[Insert SQL] : %@",sql);
    
    int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"[DB Insert] : OK");
        return YES;
    }else {
        NSLog(@"[DB Insert] : Fail");
        NSLog(@"error = %s",err);
    }
    
    return NO;
}

//删除数据
- (BOOL)deleteSQLWithWhereStr:(NSString *)whereStr tableName:(NSString *)tableName
{
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,whereStr];
    NSLog(@"[Delete SQL] : %@",sql);
    
    int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"[DB Delete] : OK");
        return YES;
    }else {
        NSLog(@"[DB Delete] : Fail");
        NSLog(@"error = %s",err);
    }
    
    return NO;
}

//更改数据语法:update 表名 set 新数据 where 旧数据，这里的写法也有很多，如 set page='1' where page='2'
- (BOOL)updateSQLWithNewColumnsKeyAndValue:(NSString *)newColumnsKeyAndValue whereStr:(NSString *)whereStr tableName:(NSString *)tableName
{
    char *err;
    
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@",tableName,newColumnsKeyAndValue,whereStr];
    NSLog(@"[Update SQL] : %@",sql);
    
    int result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"[DB Update] : OK");
        return YES;
    }else {
        NSLog(@"[DB Update] : Fail");
        NSLog(@"error = %s",err);
    }
    
    return NO;
}

//查找数据语法:select 列名 from  表名
//关于查找数据的语法就相对复杂一些，下面也只是列举了一部分而已
//简单说一下吧。order by 根据指定的列对查询到的数据进行排序，默认升序，如果要降序则order by 列名 DESC；
//limit 是指获取多少条数据，小于0获取全部，大于0获取limit条
// * 代表所有列。属于将全部列写进去的快捷方法
//where=1，因为where代表条件语句，=1说明绝对为真，属于无约束查询
- (sqlite3_stmt *)selectSQLWithOrderBy:(NSString *)orderBy findStr:(NSString *)findStr whereStr:(NSString *)whereStr limit:(int)limit tableName:(NSString *)tableName
{
    if (!whereStr || whereStr == nil) {
        whereStr = @" where 1=1";
    }else {
        whereStr = [NSString stringWithFormat:@" where 1=1 and %@",whereStr];
    }
    
    if (!findStr || findStr == nil) {
        findStr = @"*";
    }
    
    NSString *limitStr;
    if ( limit > 0 ) {
        limitStr = [NSString stringWithFormat:@" limit %d",limit];
    }else {
        limitStr = @"";
    }
    
    NSString *sql;
    if ( orderBy ) {
        sql = [NSString stringWithFormat:@"select %@ from %@ %@ order by %@ %@",findStr,tableName,whereStr,orderBy,limitStr];
    }else {
        sql = [NSString stringWithFormat:@"select %@ from %@ %@ %@",findStr,tableName,whereStr,limitStr];
    }
    
    NSLog(@"[Select SQL] : %@",sql);
    
    sqlite3_stmt *result;
    
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &result, nil);
    
    return result;
}

- (int)getCount:(NSString*)tableName
{
    NSString *sql = [NSString string];
    
    if (tableName)
    {
        sql = [NSString stringWithFormat:@"select count(*) from %@", tableName];
    }
    else
        sql = @"select count(*) from contacts";
    
    sqlite3_stmt *result;
    
    sqlite3_prepare_v2(sqlite, [sql UTF8String], -1, &result, nil);
    
    if(sqlite3_step(result)==SQLITE_ROW)
    {
        char *count = (char*)sqlite3_column_text(result, 0);
        return atoi(count);
    }
    else
        return -1; //error
}

@end
