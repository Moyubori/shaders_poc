#version 320 es

// From
// https://gist.github.com/Hebali/6ebfc66106459aacee6a9fac029d0115

precision highp float;

layout(location=0)out vec4 fragColor;

layout(location=0)uniform vec2 resolution;
layout(location=2)uniform sampler2D image;

void main(){
    float w = 1.0 / resolution.x;
    float h = 1.0 / resolution.y;
    vec2 pos = gl_FragCoord.xy / resolution.xy;
    vec4 n0 = texture(image, pos + vec2( -w, -h));
    vec4 n1 = texture(image, pos + vec2(0.0, -h));
    vec4 n2 = texture(image, pos + vec2(  w, -h));
    vec4 n3 = texture(image, pos + vec2( -w, 0.0));
    vec4 n4 = texture(image, pos);
    vec4 n5 = texture(image, pos + vec2(  w, 0.0));
    vec4 n6 = texture(image, pos + vec2( -w, h));
    vec4 n7 = texture(image, pos + vec2(0.0, h));
    vec4 n8 = texture(image, pos + vec2(  w, h));
    vec4 sobel_edge_h = n2 + (2.0*n5) + n8 - (n0 + (2.0*n3) + n6);
    vec4 sobel_edge_v = n0 + (2.0*n1) + n2 - (n6 + (2.0*n7) + n8);
    vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));

    fragColor = vec4(1.0 - sobel.rgb, 1.0 );
}