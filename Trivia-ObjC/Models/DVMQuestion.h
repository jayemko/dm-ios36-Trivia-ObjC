//
//  DVMQuestion.h
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVMQuestion : NSObject

@property (nonatomic, copy, readonly) NSString *category;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *difficulty;
@property (nonatomic, copy, readonly) NSString *question;
@property (nonatomic, copy, readonly) NSString *correctAnswer;
@property (nonatomic, copy, readonly) NSArray *incorrectAnswers;

- (instancetype)initWithQuestion:(NSString *)question
                            type:(NSString *)type
                        category:(NSString *)category
                      difficulty:(NSString *)difficulty
                   correctAnswer:(NSString *)correctAnswer
                incorrectAnswers:(NSArray *)incorrectAnswers;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
