#version 460 core

in vec2 TexCoord;
in vec3 vColor;

layout(location = 0) out vec4 FragColor;

void main() {
    vec2 uv = gl_PointCoord * 2.0 - 1.0;
    float d = length(uv);

    float aa = fwidth(d);
    float alpha = 1.0 - smoothstep(1.0 - aa, 1.0 + aa, d);

    if (alpha <= 0.0) discard;

    FragColor = vec4(vColor, alpha);
}
