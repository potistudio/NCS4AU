#version 460 core

layout(location = 0) in float aVertexId;
out vec3 vColor;
out vec2 TexCoord;

uniform vec4 track;   // x:球サイズ y:高さ z:周期 w:Z(evolution)
uniform float f1;      // 強さ(projectionFactor)
uniform vec2  f2;      // x:サイズ感度 y:ノイズ感度
uniform vec3  f3;      // noiseFlowSpeed
uniform int   uResolution;      // 分割数(resolution)
uniform ivec3 i3;      // x:isReactive y:isSpherical z:applyNoise
uniform float time;
uniform float uAudioStrength;
uniform vec2 uScreenSize; // 画面解像度(width, height)

// --- Perlinノイズ(前回と同一のハッシュ/勾配テーブル) ---
const int permBase[256] = int[256](
    151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,140, 36,103, 30,
     69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,247,120,234, 75,  0, 26,197, 62,
     94,252,219,203,117, 35, 11, 32, 57,177, 33, 88,237,149, 56, 87,174, 20,125,136,
    171,168, 68,175, 74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
     60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54, 65, 25, 63,161,
      1,216, 80, 73,209, 76,132,187,208, 89, 18,169,200,196,135,130,116,188,159, 86,
    164,100,109,198,173,186,  3, 64, 52,217,226,250,124,123,  5,202, 38,147,118,126,
    255, 82, 85,212,207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
    119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,129, 22, 39,253,
     19, 98,108,110, 79,113,224,232,178,185,112,104,218,246, 97,228,251, 34,242,193,
    238,210,144, 12,191,179,162,241, 81, 51,145,235,249, 14,239,107, 49,192,214, 31,
    181,199,106,157,184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
    222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180
);
int P(int i) { return permBase[i & 255]; }

float gradDot(int hash, float x, float y, float z) {
    switch (hash & 0xF) {
        case 0x0: return  x + y;
        case 0x1: return -x + y;
        case 0x2: return  x - y;
        case 0x3: return -x - y;
        case 0x4: return  x + z;
        case 0x5: return -x + z;
        case 0x6: return  x - z;
        case 0x7: return -x - z;
        case 0x8: return  y + z;
        case 0x9: return -y + z;
        case 0xA: return  y - z;
        case 0xB: return -y - z;
        case 0xC: return  y + x;
        case 0xD: return -y + z;
        case 0xE: return  y - x;
        default:  return -y - z;
    }
}
float fade(float t) { return t*t*t*(t*(t*6.0-15.0)+10.0); }

float perlinNoise3D(vec3 p) {
    int xi = int(floor(p.x)), yi = int(floor(p.y)), zi = int(floor(p.z));
    vec3 f = p - floor(p);
    vec3 u = vec3(fade(f.x), fade(f.y), fade(f.z));
    int A  = P(xi)+yi,   AA = P(A)+zi,   AB = P(A+1)+zi;
    int B  = P(xi+1)+yi, BA = P(B)+zi,   BB = P(B+1)+zi;
    int AAA=P(AA), ABA=P(AB), AAB=P(AA+1), ABB=P(AB+1);
    int BAA=P(BA), BBA=P(BB), BAB=P(BA+1), BBB=P(BB+1);
    return mix(
        mix(mix(gradDot(AAA,f.x,f.y,f.z), gradDot(BAA,f.x-1.0,f.y,f.z), u.x),
            mix(gradDot(ABA,f.x,f.y-1.0,f.z), gradDot(BBA,f.x-1.0,f.y-1.0,f.z), u.x), u.y),
        mix(mix(gradDot(AAB,f.x,f.y,f.z-1.0), gradDot(BAB,f.x-1.0,f.y,f.z-1.0), u.x),
            mix(gradDot(ABB,f.x,f.y-1.0,f.z-1.0), gradDot(BBB,f.x-1.0,f.y-1.0,f.z-1.0), u.x), u.y),
        u.z);
}

// xi,yiから最終座標(ノイズ+球面射影後)を計算
vec3 computePoint(int xi, int yi, int resolution) {
    const float fieldSizeX = 800.0, fieldSizeY = 800.0;
    float gapX = fieldSizeX / float(resolution - 1);
    float gapY = fieldSizeY / float(resolution - 1);

    vec3 pos = vec3(float(xi)*gapX - fieldSizeX*0.5, float(yi)*gapY - fieldSizeY*0.5, 0.0);

    bool isReactive  = i3.x == 1;
    bool isSpherical = i3.y == 1;
    bool applyNoise  = i3.z == 1;

    if (applyNoise) {
        float freq = track.z * 0.001;
        float flowX = time * -(f3.x * 0.1);
        float flowY = time *  (f3.y * 0.1);
        float flowZ = track.w;
        const float dimOff = 100.0;

        float amp = track.y;
        if (isReactive) amp += uAudioStrength * f2.y;

        pos.x += amp * perlinNoise3D(vec3(freq*float(xi)+flowX, freq*float(yi), freq*flowZ+dimOff));
        pos.y += amp * perlinNoise3D(vec3(freq*float(xi)+dimOff, freq*float(yi)+flowY, freq*flowZ));
        pos.z += amp * perlinNoise3D(vec3(freq*float(xi), freq*float(yi)+dimOff, freq*flowZ));
    }

    if (isSpherical && f1 > 0.0) {
        float radius = track.x * 0.5;
        if (isReactive) radius += uAudioStrength * (f2.x * 0.1);
        float len = length(pos);
        vec3 projected = pos * (radius / max(len, 1e-6));
        projected.z = abs(projected.z);
        pos = mix(pos, projected, f1);
    }

    return pos;
}

void main() {
    int id = int(aVertexId);
    int xi = id / uResolution;
    int yi = id % uResolution;

    const float fieldSizeX = 800.0, fieldSizeY = 800.0;
    float gapX = fieldSizeX / float(uResolution - 1);
    float gapY = fieldSizeY / float(uResolution - 1);

    vec3 pos = vec3(float(xi)*gapX - fieldSizeX*0.5, float(yi)*gapY - fieldSizeY*0.5, 0.0);

    bool isReactive  = i3.x == 1;
    bool isSpherical = i3.y == 1;
    bool applyNoise  = i3.z == 1;

    if (applyNoise) {
        float freq = track.z * 0.001;
        float flowX = time * -(f3.x * 0.1);
        float flowY = time *  (f3.y * 0.1);
        float flowZ = track.w;
        const float dimOff = 100.0;
        float amp = track.y;
        if (isReactive) amp += uAudioStrength * f2.y;

        pos.x += amp * perlinNoise3D(vec3(freq*float(xi)+flowX, freq*float(yi), freq*flowZ+dimOff));
        pos.y += amp * perlinNoise3D(vec3(freq*float(xi)+dimOff, freq*float(yi)+flowY, freq*flowZ));
        pos.z += amp * perlinNoise3D(vec3(freq*float(xi), freq*float(yi)+dimOff, freq*flowZ));
    }

    if (isSpherical && f1 > 0.0) {
        float radius = track.x * 0.5;
        if (isReactive) radius += uAudioStrength * (f2.x * 0.1);
        float len = length(pos);
        vec3 projected = pos * (radius / max(len, 1e-6));
        projected.z = abs(projected.z);
        pos = mix(pos, projected, f1);
    }

    float aspect = uScreenSize.x / uScreenSize.y;

    vec2 ndc = pos.xy / 400.0;
    ndc.x /= aspect; // 横方向だけ縮めて正方形を維持

    gl_Position = vec4(ndc, pos.z * 0.001, 1.0);
    gl_PointSize = 6.0;

    TexCoord = vec2(float(xi), float(yi)) / float(uResolution - 1);
    vColor = vec3(1.0);
}
