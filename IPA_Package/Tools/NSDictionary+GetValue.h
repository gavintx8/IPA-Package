//
//  NSDictionary+getValue.h
//  项目常用文件
//
//  Created by lxf on 2017/5/16.
//  Copyright © 2017年 lxf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GetValue)

//-(id )GetObjectFromObjectsName:(NSString *)name;
-(NSString *)GetStringForKey:(id)key;
-(NSArray *)GetArrayForKey:(id)key;
-(NSDictionary *)GetDictionaryForKey:(id)key;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

@interface NSMutableDictionary(DYSetObjectForKey)

-(void)DWSetObject:(id)anObject forKey:(id<NSCopying>)aKey;


@end
