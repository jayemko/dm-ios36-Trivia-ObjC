//
//  DVMGame.m
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import "DVMGame.h"

@implementation DVMGame

- (instancetype)initWithResults:(NSArray *)results
{
    self = [super init];
    if (self) {
        _questions = [self questionsFromResults:results];
    }
    return self;
}

- (NSArray *)questionsFromResults:(NSArray *)results
{
    NSMutableArray *questionArray = [NSMutableArray new];
    for (NSDictionary *result in results) {
        DVMQuestion *newQuestion = [[DVMQuestion alloc]initWithDictionary:result];
        [questionArray addObject:newQuestion];
    }
    return questionArray;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Game: %ld question", _questions.count];
}

@end
