//
//  DVMQuestion.m
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import "DVMQuestion.h"

@implementation DVMQuestion

static NSString * const kKeyCategory = @"category";
static NSString * const kKeyType = @"type";
static NSString * const kKeyDifficulty = @"difficulty";
static NSString * const kKeyQuestion = @"question";
static NSString * const kKeyCorrectAnswer = @"correct_answer";
static NSString * const kKeyIncorrectAnswers = @"incorrect_answers";

- (instancetype)initWithQuestion:(NSString *)question
                            type:(NSString *)type
                        category:(NSString *)category
                      difficulty:(NSString *)difficulty
                   correctAnswer:(NSString *)correctAnswer
                incorrectAnswers:(NSArray *)incorrectAnswers
{
    self = [super init];
    if (self) {
        _question = question;
        _type = type;
        _category = category;
        _difficulty = difficulty;
        _correctAnswer = correctAnswer;
        _incorrectAnswers = incorrectAnswers;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *category = [dictionary[kKeyCategory] stringByRemovingPercentEncoding];
    NSString *type = [dictionary[kKeyType] stringByRemovingPercentEncoding];
    NSString *difficulty = [dictionary[kKeyDifficulty] stringByRemovingPercentEncoding];
    NSString *question = [dictionary[kKeyQuestion] stringByRemovingPercentEncoding];
    NSString *correctAnswer = [dictionary[kKeyCorrectAnswer] stringByRemovingPercentEncoding];
    NSArray *incorrectUnformattedAnswers = dictionary[kKeyIncorrectAnswers];
    NSMutableArray *incorrectAnswers = [NSMutableArray new];
    for (NSString *answer in incorrectUnformattedAnswers) {
        [incorrectAnswers addObject:[answer stringByRemovingPercentEncoding]];
    }
    
    return [self initWithQuestion:question
                             type:type
                         category:category
                       difficulty:difficulty
                    correctAnswer:correctAnswer
                 incorrectAnswers:incorrectAnswers];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Question:\nCategory: %@\nType: %@\nDifficulty: \nQuestion: %@\nCorrect Answer: %@\nIncorrect Answers: %@", _category, _type, _difficulty, _question, _incorrectAnswers];
}

@end
