//
//  ReversePolandNotation.m
//  CommonToolkit
//
//  Created by Ares on 13-6-3.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "ReversePolandNotation.h"

#import "NSStack.h"

#import "NSNumber+Extension.h"

#import "NSMutableString+Extension.h"

// 0 ascii code
#define ZERO_ASCII_CODE 48

// operands separator
#define OPERANDS_SEPARATOR  '#'

// declare
// operator priority
bool priority(char leftOP, char rightOP);

// check operand character is digit
bool isDigit(char data);

// check operand character is sign: '(', ')' or operator
bool isSign(char data);

// implement
extern bool translateFAOE2RPN(const char faoexpression[], char rpnotation[]){
    bool _ret = true;
    
    // check four arithmetic operation expression and reverse Poland notation array
    if (NULL == faoexpression || NULL == rpnotation) {
        NSLog(@"four arithmetic operation expression = %s and reverse Poland notation = %s", faoexpression, rpnotation);
        
        _ret = false;
    } else {
        // define sign stack
        NSStack *_signStack = [[NSStack alloc] init];
        
        // define reverse Poland notation length
        int _rpnotationLength = 0;
        
        // process four arithmetic operation expression
        for (int i = 0; i < strlen(faoexpression); i++) {
            // get each four arithmetic operation expression character
            char _faoexpressionChar = faoexpression[i];
            
            // check it
            if (isDigit(_faoexpressionChar)) {
                // if digit direct cpoy
                rpnotation[_rpnotationLength++] = _faoexpressionChar;
                rpnotation[_rpnotationLength] = '\0';
                
                // check next character
                if (i + 1 < strlen(faoexpression) && !isDigit(faoexpression[i + 1])) {
                    // not digit, append separator
                    rpnotation[_rpnotationLength++] = OPERANDS_SEPARATOR;
                    rpnotation[_rpnotationLength] = '\0';
                }
            }
            else if (isSign(_faoexpressionChar)) {
                // if '(' or the sign stack is empty then push it to sigh stack
                if(_faoexpressionChar == '(' || _signStack.empty) {
                    [_signStack push:[NSNumber numberWithChar:_faoexpressionChar]];
                }
                // if ')' then pop all character before '(' and assignment, '(' was also popped but not be assigned
                else if(_faoexpressionChar == ')') {
                    // get sign stack top character as temp
                    char _signTmp = ((NSNumber *)[_signStack top]).charValue;
                    
                    // sign stack pop
                    [_signStack pop];
                    
                    // pop all
                    while(_signTmp != '(') {
                        // sign stack top copy
                        if (OPERANDS_SEPARATOR == rpnotation[_rpnotationLength - 1]) {
                            rpnotation[_rpnotationLength - 1] = _signTmp;
                            
                        }
                        else {
                            rpnotation[_rpnotationLength++] = _signTmp;
                            rpnotation[_rpnotationLength] = '\0';
                        }
                        
                        // update temp character
                        _signTmp = ((NSNumber *)[_signStack top]).charValue;
                        
                        // sign stack pop
                        [_signStack pop];
                    }
                }
                // sign is operator
                else {
                    // get sign stack top character as temp
                    char _signTmp = ((NSNumber *)[_signStack top]).charValue;
                    
                    // if sign stack top is '(', then push it to sign stack
                    if(_signTmp == '(') {
                        [_signStack push:[NSNumber numberWithChar:_faoexpressionChar]];
                    }
                    // two characters both not '(' or ')'
                    else {
                        // check two operators priority
                        // current character priority is higher, then push it to sign stack
                        if(priority(_signTmp, _faoexpressionChar)) {
                            [_signStack push:[NSNumber numberWithChar:_faoexpressionChar]];
                        }
                        // current character priority is lower, then pop the top and assignment, compare the top the sign stack with current character
                        else {
                            // sign stack top copy
                            if (OPERANDS_SEPARATOR == rpnotation[_rpnotationLength - 1]) {
                                rpnotation[_rpnotationLength - 1] = _signTmp;
                            }
                            else {
                                rpnotation[_rpnotationLength++] = _signTmp;
                                rpnotation[_rpnotationLength] = '\0';
                            }
                            
                            // sign stack pop
                            [_signStack pop];
                            
                            // rollback and process again
                            i--;
                        }
                    }
                }
            }
        }
        
        // get all remain characters of sign stack and assignment when four arithmetic operation expression had been processed
        while(!_signStack.empty) {
            // append all remain characters of sign stack
            rpnotation[_rpnotationLength++] = ((NSNumber *)[_signStack top]).charValue;
            rpnotation[_rpnotationLength] = '\0';
            
            // sign stack pop
            [_signStack pop];
        }
    }
    
    return _ret;
}

extern float evaluateFAOE(const char faoexpression[]){
    float _ret = 0.0;
    
    // check four arithmetic operation expression
    if (NULL != faoexpression) {
        // define reverse Poland notation point
        char *_rpnotation = (char *)malloc(strlen(faoexpression) * sizeof(char));
        
        // translate four arithmetic operation expression to reverse Poland notation and evaluate
        if (translateFAOE2RPN(faoexpression, _rpnotation)) {
            _ret = evaluateRPN(_rpnotation);
        }
    }
    
    return _ret;
}

float evaluateRPN(char rpnotation[]){
    float _ret = 0.0;
    
    // check reverse Poland notation
    if (NULL != rpnotation) {
        // define digit stack
        NSStack *_digitStack = [[NSStack alloc] init];
        
        // define operand buffer string
        NSMutableString *_operandBufferString = [[NSMutableString alloc] init];
        
        // evaluate reverse Poland notation
        for (int i = 0; i < strlen(rpnotation); i++) {
            // get reverse Poland notation character
            char _rpnotationChar = rpnotation[i];
            
            // check it
            if (isDigit(_rpnotationChar)) {
                // if it is digit then append it to operand string
                [_operandBufferString appendFormat:@"%c", _rpnotationChar];
            }
            else if (isSign(_rpnotationChar)) {
                // push operand string to digit stack and clear operand buffer string
                if (_operandBufferString.length > 0) {
                    [_digitStack push:[NSNumber numberWithString:_operandBufferString]];
                    [_operandBufferString clear];
                }
                
                // get two operands
                float _leftOperand, _rightOperand;
                
                // check digit stack
                if (_digitStack.empty || _digitStack.count < 2) {
                    NSLog(@"operate two operands error, digit stack = %@", _digitStack);
                    
                    break;
                }
                else {
                    // get top two character of digit stack
                    // tight operand assisgnment
                    _rightOperand = ((NSNumber *)[_digitStack top]).floatValue;
                    
                    // digit stack pop
                    [_digitStack pop];
                    
                    // left operand assisgnment
                    _leftOperand = ((NSNumber *)[_digitStack top]).floatValue;
                    
                    // digit stack pop
                    [_digitStack pop];
                    
                    // two operands operate and push result to digit stack
                    float _result;
                    switch (_rpnotationChar) {
                        case '+':
                            _result = _leftOperand + _rightOperand;
                            break;
                            
                        case '-':
                            _result = _leftOperand - _rightOperand;
                            break;
                            
                        case '*':
                            _result = _leftOperand * _rightOperand;
                            break;
                            
                        case '/':
                            _result = _leftOperand / _rightOperand;
                            break;
                    }
                    [_digitStack push:[NSNumber numberWithFloat:_result]];
                }
            }
            else if (OPERANDS_SEPARATOR == _rpnotationChar) {
                // push operand string to digit stack and clear operand buffer string
                [_digitStack push:[NSNumber numberWithString:_operandBufferString]];
                [_operandBufferString clear];
            }
        }
        
        // check digit stack and get result
        if (_digitStack.empty || _digitStack.count > 1) {
            NSLog(@"get result error, digit stack = %@", _digitStack);
        }
        else {
            // get result
            _ret = ((NSNumber *)[_digitStack top]).floatValue;
            
            // digit stack pop
            [_digitStack pop];
        }
    }
    
    return _ret;
}

bool priority(char leftOP, char rightOP){
    bool _ret = false;
    
    // compare left and right operator
    if((leftOP == '+' || leftOP == '-') && (rightOP == '*' || rightOP == '/')) {
        _ret = true;
    }
    
    return _ret;
}

bool isDigit(char data){
    bool _ret = false;
    
    // check operand character
    if(data >='0' && data <= '9') {
        _ret = true;
    }
    
    return _ret;
}

bool isSign(char data){
    bool _ret = false;
    
    // check operand character
    if(data == '(' || data == ')' || data == '+' || data == '-' || data == '*' || data == '/') {
        _ret = true;
    }
    
    return _ret;
}
