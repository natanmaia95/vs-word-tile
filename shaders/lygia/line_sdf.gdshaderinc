/*
contributors: Patricio Gonzalez Vivo
description: clamp a value between 0 and 1
use: <float|vec2|vec3|vec4> saturation(<float|vec2|vec3|vec4> value)
examples:
    - https://raw.githubusercontent.com/patriciogonzalezvivo/lygia_examples/main/math_functions.frag
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#if !defined(FNC_SATURATE) && !defined(saturate)
#define FNC_SATURATE
#define saturate(V) clamp(V, 0.0, 1.0)
#endif

/*
contributors: Inigo Quiles
description: Segment SDF
use: lineSDF(<vec2> st, <vec2> A, <vec2> B)
*/

#ifndef FNC_LINESDF
#define FNC_LINESDF
float lineSDF( in vec2 st, in vec2 a, in vec2 b ) {
    vec2 b_to_a = b - a;
    vec2 to_a = st - a;
    float h = saturate(dot(to_a, b_to_a)/dot(b_to_a, b_to_a));
    return length(to_a - h * b_to_a );
}

float lineSDF(vec3 p, vec3 a, vec3 b) {
    //https://mathworld.wolfram.com/Point-LineDistance3-Dimensional.html
    return length(cross(p - a, p - b))/length(b - a);
}
#endif