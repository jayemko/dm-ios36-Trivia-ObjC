//
//  DVMGameController.h
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import <Foundation/Foundation.h>
#import "DVMGame.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ResponseCode) {
    ResponseCodeSuccess,
    ResponseCodeNoResults,
    ResponseCodeInvalidParameter,
    ResponseCodeTokenNotFound,
    ResponseCodeTokenEmpty,
    ResponseCodeFetchError
};

@interface DVMGameController : NSObject

+ (void)fetchNewGameOfType:(NSString *)type
                difficulty:(NSString *)difficulty
                  category:(NSInteger)category
         numberOfQuestions:(NSInteger)numberOfQuestions
              sessionToken:(NSString *)sessionToken
                completion:(void (^) (DVMGame *, ResponseCode))completion;

+ (void)requestSessionToken:(void (^) (NSString *, ResponseCode))completion;

@end

@interface DVMGameController (ResponseCode)

+ (NSString *)codeDescription:(ResponseCode)code;

@end

NS_ASSUME_NONNULL_END
