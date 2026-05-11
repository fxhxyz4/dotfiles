#version 300 es
precision mediump float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

void main() {
    vec2 uv = v_texcoord;

    // slight curve
    vec2 curved = uv - 0.5;
    curved *= 1.0 + dot(curved, curved) * 0.1;
    curved += 0.5;

    vec4 color = texture(tex, curved);

    // scanlines
    float scan = sin(uv.y * 800.0) * 0.04;
    color.rgb -= scan;

    // catppuccin blue tint (#89b4fa)
    color.r *= 0.85;
    color.g *= 0.95;
    color.b *= 1.15;

    fragColor = color;
}
