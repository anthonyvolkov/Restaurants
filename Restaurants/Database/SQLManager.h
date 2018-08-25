//
//  SQLManager.h
//  Restaurants
//
//  Created by anthony volkov on 7/22/18.
//  Copyright © 2018 playgendary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLManager : NSObject {
    NSString *databasePath;
}

+ (SQLManager*)sharedManager;
- (void)copyDatabaseIntoDocumentsDirectory;

- (NSArray *)selectMultipleRows: (NSString*) sql;
- (NSDictionary *)selectOneRow: (NSString*) sql;

- (BOOL)insertRow: (NSString*) sql;
- (BOOL)deleteRow: (NSString*) sql;
- (BOOL)updateRow: (NSString*) sql;

@end
