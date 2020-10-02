//
//  DVMCategory.h
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVMCategory : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSInteger categoryId;

- (instancetype)initWithCategoryName:(NSString *)name
                          categoryId:(NSInteger)categoryId;

@end

NS_ASSUME_NONNULL_END
