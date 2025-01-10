//
//  MagnificationLoupe.metal
//  example-ios
//
//  Created by Рафаэль Голубев on 06.01.2025.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;


static float mapRange(float value, float inMin, float inMax, float outMin, float outMax) {
    return ((value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin);
}

static float easeInQuart(float x) {
    return x * x * x * x;
}

[[ stitchable ]] half4 loupe(float2 position, SwiftUI::Layer layer, float4 bounds, float2 loupeCenter, float loupeSize) {
    // Общий размер/разрешение границ видимости шейдера
    float2 size = float2(bounds[2], bounds[3]);

    // Нормализуем `position` в единичные координаты (т.е. [0, 1])
    float2 p = position / size;
    float px = p[0];
    float py = p[1];

    // Отбираем исходный цвет пикселя
    half4 color = layer.sample(position);

    // Вычисляем, насколько далеко текущий пиксель от центра лупы.
    float d = distance(loupeCenter, p);

    float r = loupeSize;
    float shadowRadius = 0.08;

    // Рисуем увеличенное содержимое внутри лупы:
    if (d <= r) {
        // Какова степень "увеличения" эффекта увеличения.
        float offset = 0.10;

        // Немного хакерский способ, но он помогает сохранять радиус увеличения постоянным, даже когда изменяются границы лупы.
        r = 0.18;

        // Вычисляем границы лупы, учитывая ее центр и радиус:
        float loupeMinX = loupeCenter[0] - r;
        float loupeMaxX = loupeCenter[0] + r;
        float loupeMinY = loupeCenter[1] - r;
        float loupeMaxY = loupeCenter[1] + r;

        // Пиксели внутри лупы должны отбирать образцы из меньшего диапазона от лежащего в основе текстура.
        // Это и дает тот "эффект увеличения".
        float zoomRangeMinX = loupeMinX + offset;
        float zoomRangeMaxX = loupeMaxX - offset;

        float zoomRangeMinY = loupeMinY + offset;
        float zoomRangeMaxY = loupeMaxY - offset;

        // Вычисляем новые координаты для отбора образца.
        // Например, когда `px` == `loupeMinX`, он будет преобразован в `zoomRangeMinX`.
        float zoomPosX = mapRange(px, loupeMinX, loupeMaxX, zoomRangeMinX, zoomRangeMaxX);
        float zoomPosY = mapRange(py, loupeMinY, loupeMaxY, zoomRangeMinY, zoomRangeMaxY);

        // де-нормализуем позицию обратно в пользовательское пространство
        // Мы работали с нормализованными единичными значениями, но нам нужно преобразовать эти значения обратно в "пользовательское пространство".
        // Эти значения считаются "де-нормализованными", и мы можем использовать их для отбора текстуры SwiftUI::Layer.
        float2 normalizedSamplePosition = float2(zoomPosX, zoomPosY);
        float2 denormalizedSamplePosition = float2(
                                                   normalizedSamplePosition[0] * size[0],
                                                   normalizedSamplePosition[1] * size[1]
                                                   );

        // Наконец, отбираем слой с новой, "увеличенной" координатой.
        color = layer.sample(denormalizedSamplePosition);
    }
    // Этот блок рисует тень вокруг лупы:
    else if (d > r && d <= r + shadowRadius) {
        float distanceFromEdge = d - r;

        // Прогресс нормализован в диапазоне [0, 1].
        float progress = mapRange(distanceFromEdge, 0, shadowRadius, 1, 0);

        // Быстро уменьшаем прогресс, чтобы создать более реалистичную тень.
        progress = easeInQuart(progress);

        // Наконец, делаем некоторые операции с альфа-каналом, чтобы смешать черный цвет тени с исходным цветом пикселя:
        float shadowOpacity = mapRange(progress, 1, 0, 0.2, 0);
        color = mix(color, half4(half3(0), 1), half4(shadowOpacity));
    }

    return color;
}


