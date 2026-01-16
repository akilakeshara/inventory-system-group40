package com.inventory.util;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ColorUtil {

    private static final List<String> PREDEFINED_COLORS = Arrays.asList(
        "#10b981", "#3b82f6", "#f59e0b", "#ef4444", "#8b5cf6", "#ec4899", "#6366f1"
    );

    private static final Map<String, String> categoryColors = new HashMap<>();
    private static int colorIndex = 0;

    public static synchronized String getColor(String category) {
        if (!categoryColors.containsKey(category)) {
            if (colorIndex < PREDEFINED_COLORS.size()) {
                categoryColors.put(category, PREDEFINED_COLORS.get(colorIndex));
                colorIndex++;
            } else {
                int hash = category.hashCode();
                int hue = Math.abs(hash % 360);
                String color = "hsl(" + hue + ", 70%, 50%)";
                categoryColors.put(category, color);
            }
        }
        return categoryColors.get(category);
    }
}