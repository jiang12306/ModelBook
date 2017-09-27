//
//  UIKeyboard.h
//  Baseframework
//
//  Created by Zanilia on 16/8/14.
//

#import <UIKit/UIKit.h>

@protocol UIKeyboardBarDelegate;

typedef NS_ENUM(NSUInteger, UIKeyboardChatType) {
    UIKeyboardChatTypeDefault       = 1,          //The default primitive state
    UIKeyboardChatTypeKeyboard      = 2,          //Keyboard system keyboard or a third party
    UIKeyboardChatTypeFace          = 3,          //Expression on the keyboard
    UIKeyboardChatTypeVoice         = 4,          //Phonetic keyboard
    UIKeyboardChatTypeMore          = 5           //More keyboard operation
};

/**
 *  Universal keyboard (mainly, expression, other (pictures, location, etc.), voice)...
 */
@interface UIKeyboardBar : UIToolbar

// State of the input,default NO
@property (nonatomic) BOOL inputing;

// State of the input,default NO
@property (nonatomic) BOOL textViewFirstResponder;

//Start the input box is the first responder,default NO
@property (nonatomic, strong) NSString *placehoder;

// have the expression, this property must be assigned
@property (nonatomic, strong) NSString *expressionBundleName;

//What keyboard to need your choice, the keyboard is the default ,@[@(UIKeyboardChatTypeKeyboard),...]
@property (nonatomic, strong) NSArray *keyboardTypes;

//Other operating under the title, such as image, video @[@"title1",@"title2",...]
@property (nonatomic, strong) NSArray *KeyboardMoreTitles;

//Other operating under the icon, such as pictures, video @[@"imageName1",@"imageName2",...]
@property (nonatomic, strong) NSArray *KeyboardMoreImages;

//Send button color, the default is blue
@property (nonatomic, strong) UIColor *faceSendColor;
/*
 *Special note
 *expressionBundleName，KeyboardMoreTitles and KeyboardMoreImages assignment Or count assignment 0 Or @""，All hide
*/


@property (nonatomic, strong) id<UIKeyboardBarDelegate> barDelegate;    //default nil


//The input end of state, Property inputing state to NO
- (void)endInput;
@end


@protocol UIKeyboardBarDelegate <NSObject>

@optional

//To switch the keyboard height change constantly
- (void)keyboardBar:(UIKeyboardBar *)keyboard didChangeFrame:(CGRect)frame;

//Choose other more operating under the keyboard keyboard =(UIKeyboardChatTypeMore)
- (void)keyboardBar:(UIKeyboardBar *)keyboard moreHandleAtItemIndex:(NSInteger)index;

//Send text or expression.....UIKeyboardChatTypeFace
- (void)keyboardBar:(UIKeyboardBar *)keyboard sendContent:(NSString *)message;

//Send voice, return parameter for speech bytes and speech....UIKeyboardChatTypeMore
- (void)keyboardBar:(UIKeyboardBar *)keyboard sendVoiceWithFilePath:(NSString *)path seconds:(NSTimeInterval)seconds;
@end
