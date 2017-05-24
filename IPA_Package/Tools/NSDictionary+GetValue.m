//
//  NSDictionary+getValue.m
//  项目常用文件
//
//  Created by lxf on 2017/5/16.
//  Copyright © 2017年 lxf. All rights reserved.
//

#import "NSDictionary+GetValue.h"

@implementation NSDictionary (GetValue)

//-(id )GetObjectFromObjectsName:(NSString *)name
//{
//    return  [DYParsers getObjectByObjectName:name andFromDictionary:self];
//}


-(NSString *)GetStringForKey:(id)key
{
    id object=[self objectForKey:key];
    
    if ([object isKindOfClass:[NSNull class]]||object == nil)
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",object];
}

-(NSArray *)GetArrayForKey:(id)key
{
    id object=[self objectForKey:key];
    
    if (![object isKindOfClass:[NSArray class]])
    {
        return [NSArray array];
    }
    return object;
}

-(NSDictionary *)GetDictionaryForKey:(id)key
{
    id object=[self objectForKey:key];
    
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return [NSDictionary dictionary];
    }
    return object;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end

@implementation NSMutableDictionary(DYSetObjectForKey)


-(void)DWSetObject:(id)anObject forKey:(id<NSCopying>)aKey;
{
    if (anObject == nil) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}
@end
