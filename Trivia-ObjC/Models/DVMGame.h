//
//  DVMGame.h
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import <Foundation/Foundation.h>
#import "DVMQuestion.h"

NS_ASSUME_NONNULL_BEGIN



@interface DVMGame : NSObject

@property (nonatomic, strong, readonly) NSArray *questions;

- (instancetype)initWithResults:(NSArray *)results;

@end

NS_ASSUME_NONNULL_END
