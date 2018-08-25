//
//  SQLManager.m
//  Restaurants
//
//  Created by anthony volkov on 7/22/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import "SQLManager.h"
#import "sqlite3.h"

static NSString * const databaseFileName = @"default.db";
static SQLManager *sharedInstance = nil;

@implementation SQLManager

+ (SQLManager *)sharedManager {
    if (!sharedInstance) {
        sharedInstance = [[self alloc] init];
        [sharedInstance copyDatabaseIntoDocumentsDirectory];
    }
    return sharedInstance;
}

- (void)copyDatabaseIntoDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    databasePath = [[NSString alloc] initWithString:[documentsDirectory stringByAppendingPathComponent:databaseFileName]];

    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseFileName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:databasePath error:&error];
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    } else {
        NSLog(@"DB is exist at path: %@", databasePath);
    }
}


static int multipleRowCallback (void *_queryValues, int columnCount, char **values, char **columnNames) {
    NSMutableArray *queryValues = (__bridge NSMutableArray *)_queryValues;
    NSMutableDictionary *individualQueryValues = [NSMutableDictionary dictionary];
    for (int i = 0; i < columnCount; i++) {
        [individualQueryValues setObject:values[i] ? [NSString stringWithUTF8String:values[i]] : [NSNull null] forKey:[NSString stringWithUTF8String:columnNames[i]]];
    }
    
    [queryValues addObject:[NSMutableDictionary dictionaryWithDictionary:individualQueryValues]];
    return 0;
}


static int oneRowCallback (void *_queryValues, int columnCount, char **values, char **columnNames) {
    NSMutableDictionary *queryValues = (__bridge NSMutableDictionary *)_queryValues;
    for (int i = 0; i < columnCount; i++) {
        [queryValues setObject:values[i] ? [NSString stringWithUTF8String:values[i]] : [NSNull null] forKey:[NSString stringWithUTF8String:columnNames[i]]];
    }
    return 0;
}


- (BOOL)executeSQLQuery: (NSString *) sql withCallback: (void *)callbackFunction context:(id)contextObject {
    
    sqlite3 *db = NULL;
    int resultCode = SQLITE_OK;
    char *errorMsg = NULL;
    
    resultCode = sqlite3_open([databasePath UTF8String], &db);
    
    if (resultCode != SQLITE_OK) {
        NSLog(@"Error in opening database: %s", sqlite3_errmsg(db));
        sqlite3_close(db);
        
        return NO;
    }
    
    resultCode = sqlite3_exec(db, [sql UTF8String], callbackFunction, (__bridge void *)(contextObject), &errorMsg);
    
    if (resultCode != SQLITE_OK) {
        NSLog(@"Error %@", sql);
        sqlite3_free(errorMsg);
        sqlite3_close(db);
        
        return NO;
    }
    sqlite3_close(db);
    
    return YES;
}


- (NSArray *)selectMultipleRows: (NSString*) sql {
    NSMutableArray *contextObject = [[NSMutableArray alloc] init];
    
    if ([self executeSQLQuery:sql withCallback:multipleRowCallback context:contextObject]) {
        return [contextObject copy];
    }
    
    return nil;
}


- (NSDictionary *)selectOneRow: (NSString*) sql {
    NSMutableDictionary *contextObject = [[NSMutableDictionary alloc] init];
    
    if ([self executeSQLQuery:sql withCallback:oneRowCallback context:contextObject]) {
        return [contextObject copy];
    }
    
    return nil;
}


- (BOOL)insertRow: (NSString*) sql {
    return [self executeSQLQuery:sql withCallback:NULL context:NULL];
}


- (BOOL)deleteRow: (NSString*) sql {
    return [self executeSQLQuery:sql withCallback:NULL context:NULL];
}


- (BOOL)updateRow: (NSString*) sql {
    return [self executeSQLQuery:sql withCallback:NULL context:NULL];
}


@end
