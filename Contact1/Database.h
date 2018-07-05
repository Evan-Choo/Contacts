//
//  Database.h
//  Contact1
//
//  Created by Evan Choo on 6/28/18.
//  Copyright © 2018 Evan Choo. All rights reserved.
//

#ifndef Database_h
#define Database_h

#import <sqlite3.h>
#import <UIKit/UIKit.h>

@interface Database : NSObject
{
    sqlite3 *sqlite;
}

+(instancetype)defaultDb;

-(bool) openDb:(NSString *)sqlName;
-(bool) closeDb;
-(bool) createTable:(NSString *)tableName;
-(bool) createColumn:(NSString *)column TableName:(NSString *)tableName;
//增加数据
- (BOOL)insertSQLWithColumnName:(NSString *)columnName columnValue:(NSString *)columnValue tableName:(NSString *)tableName;
//删除数据
- (BOOL)deleteSQLWithWhereStr:(NSString *)whereStr tableName:(NSString *)tableName;
//更改数据
- (BOOL)updateSQLWithNewColumnsKeyAndValue:(NSString *)newColumnsKeyAndValue whereStr:(NSString *)whereStr tableName:(NSString *)tableName;
//查找数据
- (sqlite3_stmt *)selectSQLWithOrderBy:(NSString *)orderBy findStr:(NSString *)findStr whereStr:(NSString *)whereStr limit:(int)limit tableName:(NSString *)tableName;

-(int)getCount:(NSString*)tableName;

@end



#endif /* Database_h */
