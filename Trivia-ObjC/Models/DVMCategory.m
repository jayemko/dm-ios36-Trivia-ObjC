//
//  DVMCategory.m
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import "DVMCategory.h"

@implementation DVMCategory

- (instancetype)initWithCategoryName:(NSString *)name
                          categoryId:(NSInteger)categoryId
{
    self = [super init];
    if (self) {
        _name = name;
        _categoryId = categoryId;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Category name:%@, id:%ld", _name, _categoryId];
}

@end
