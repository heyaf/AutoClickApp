//
//  NSDictionary+SafeData.h
//  AutoClickApp
//
//  Created by 贺亚飞 on 2023/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SafeData)
- (id)objectSafeForKey:(NSString*)key;

- (NSArray*)arraySafeForKey:(NSString*)key;

- (NSDictionary*)dictionarySafeForKey:(NSString*)key;

- (NSString*)stringSafeForKey:(NSString*)key;

- (NSMutableArray*)mutableArraySafeForKey:(NSString*)key;

- (NSMutableDictionary*)mutableDictionarySafeForKey:(NSString*)key;

- (NSInteger)integerSafeForKey:(NSString*)key;

- (CGFloat)floatSafeForKey:(NSString*)key;

- (double)doubleSafeForKey:(NSString*)key;

- (NSNumber*)numberSafeForKey:(NSString*)key;

- (int)intSafeForKey:(NSString*)key;

- (NSDate *)dateSafeForKey:(NSString*)key;

- (BOOL)boolSafeForKey:(NSString*)key;
@end

NS_ASSUME_NONNULL_END
