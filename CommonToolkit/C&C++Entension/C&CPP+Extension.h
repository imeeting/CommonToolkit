//
//  C&CPP+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-6-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#ifndef CommonToolkit_C_CPP_Extension_h
#define CommonToolkit_C_CPP_Extension_h

// C extension
// CGRect maker
// CGRect make with format string
CG_EXTERN CGRect CGRectMakeWithFormat(UIView *view, NSValue *xValue, NSValue *yValue, NSValue *widthValue, NSValue *heightValue);

// reverse Poland notation
// translate four arithmetic operation expression to reverse Poland notation
extern bool translateFAOE2RPN(const char faoexpression[], char rpnotation[]);

// evaluate four arithmetic operation expression
extern float evaluateFAOE(const char faoexpression[]);

// C++ extension

#endif
