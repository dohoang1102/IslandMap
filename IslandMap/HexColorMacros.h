//
//  HexColorMacros.h
//  IslandMap
//
//  Created by Kris Bulman on 12-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef IslandMap_HexColorMacros_h
#define IslandMap_HexColorMacros_h

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#endif
