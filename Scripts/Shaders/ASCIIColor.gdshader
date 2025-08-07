shader_type canvas_item;

uniform float character_size : hint_range(4.0, 32.0) = 8.0;
uniform float brightness_multiplier : hint_range(0.1, 3.0) = 1.2;
uniform bool invert_brightness = false;

// ASCII character patterns stored as bit patterns
// Each character is 8x8 pixels, stored as 8 floats
const float ascii_chars[11 * 8] = {
    // Space (0)
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    // . (1)
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 24.0, 0.0,
    // : (2)
    0.0, 0.0, 24.0, 0.0, 0.0, 24.0, 0.0, 0.0,
    // + (3)
    0.0, 8.0, 8.0, 62.0, 8.0, 8.0, 0.0, 0.0,
    // = (4)
    0.0, 0.0, 62.0, 0.0, 62.0, 0.0, 0.0, 0.0,
    // % (5)
    98.0, 100.0, 8.0, 16.0, 32.0, 76.0, 134.0, 0.0,
    // # (6)
    20.0, 20.0, 126.0, 20.0, 126.0, 20.0, 20.0, 0.0,
    // & (7)
    60.0, 102.0, 60.0, 56.0, 103.0, 102.0, 63.0, 0.0,
    // 8 (8)
    60.0, 102.0, 102.0, 60.0, 102.0, 102.0, 60.0, 0.0,
    // @ (9)
    60.0, 102.0, 110.0, 106.0, 110.0, 96.0, 62.0, 0.0,
    // █ (10) - full block
    255.0, 255.0, 255.0, 255.0, 255.0, 255.0, 255.0, 255.0
};

// Get bit value from character pattern
float get_char_pixel(int char_index, int x, int y) {
    if (char_index < 0 || char_index >= 11 || x < 0 || x >= 8 || y < 0 || y >= 8) {
        return 0.0;
    }

    float row = ascii_chars[char_index * 8 + y];
    float bit_pos = 7.0 - float(x);
    return floor(mod(row / pow(2.0, bit_pos), 2.0));
}

// Convert brightness to character index
int brightness_to_char(float brightness) {
    if (invert_brightness) {
        brightness = 1.0 - brightness;
    }

    brightness = clamp(brightness * brightness_multiplier, 0.0, 1.0);

    if (brightness < 0.1) return 0;      // space
    else if (brightness < 0.2) return 1; // .
    else if (brightness < 0.3) return 2; // :
    else if (brightness < 0.4) return 3; // +
    else if (brightness < 0.5) return 4; // =
    else if (brightness < 0.6) return 5; // %
    else if (brightness < 0.7) return 6; // #
    else if (brightness < 0.8) return 7; // &
    else if (brightness < 0.9) return 8; // 8
    else if (brightness < 0.95) return 9; // @
    else return 10; // █
}
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 char_pos = floor(SCREEN_UV * screen_size / character_size);
    vec2 pixel_pos = mod(SCREEN_UV * screen_size, character_size);

    // Sample the original color at the character position
    vec2 char_center = (char_pos + 0.5) * character_size / screen_size;
    vec3 original_color = texture(SCREEN_TEXTURE, char_center).rgb;

    // Calculate brightness
    float brightness = dot(original_color, vec3(0.299, 0.587, 0.114));

    // Get the character to display
    int char_index = brightness_to_char(brightness);

    // Get the pixel value for this position in the character
    int px = int(pixel_pos.x);
    int py = int(pixel_pos.y);
    float char_pixel = get_char_pixel(char_index, px, py);

    // Apply color
    vec3 final_color = original_color * char_pixel;

    COLOR = vec4(final_color, 1.0);
}