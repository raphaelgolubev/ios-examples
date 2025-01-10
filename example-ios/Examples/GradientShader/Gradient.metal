//
//  Gradient.metal
//  example-ios
//
//  Created by Рафаэль Голубев on 10.01.2025.
//

#include <metal_stdlib>
using namespace metal;

// Standard convert from RGB to HUE
static float3 Hue(float H) {
    half R = abs(H * 6 - 3) - 1;
    half G = 2 - abs(H * 6 - 2);
    half B = 2 - abs(H * 6 - 4);
    float3 color = float3(R,G,B);
    return saturate(color);
}

static float4 HSBtoRGB(float3 HSB) {
    float3 hue = ((Hue(HSB.x) - 1) * HSB.y + 1) * HSB.z;
    return float4(hue,
                  1); // Alpha
}

[[ stitchable ]] half4 animatedGradient(float2 position, half4 color, float width, float time) {
    float gradient = position.x / width;
    
    float normalizedTime = (sin(time) + 1) / 2; // sin(time)=[-1; 1], но сдвинули до [0; 1]
    float hue = abs(gradient - normalizedTime); // повторяем анимацию
  
    float3 hueColor = float3(hue, 1, 1);
    float4 rgbColor = HSBtoRGB(hueColor);
    return half4(rgbColor);
}
