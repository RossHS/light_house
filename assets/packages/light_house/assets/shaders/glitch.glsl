{
  "sksl": {
    "entrypoint": "glitch_fragment_main",
    "shader": "// This SkSL shader is autogenerated by spirv-cross.\n\nfloat4 flutter_FragCoord;\n\nuniform vec2 iResolution;\nuniform float iTime;\nuniform shader iChannel0;\nuniform half2 iChannel0_size;\n\nvec4 fragColor;\n\nfloat bottomStaticOpt;\nfloat scalinesOpt;\nfloat rgbOffsetOpt;\nfloat horzFuzzOpt;\n\nvec2 FLT_flutter_local_mod289(vec2 x)\n{\n    return x - (floor(x * 0.00346020772121846675872802734375) * 289.0);\n}\n\nvec3 FLT_flutter_local_mod289(vec3 x)\n{\n    return x - (floor(x * 0.00346020772121846675872802734375) * 289.0);\n}\n\nvec3 FLT_flutter_local_permute(vec3 x)\n{\n    vec3 param = ((x * 34.0) + vec3(1.0)) * x;\n    return FLT_flutter_local_mod289(param);\n}\n\nfloat FLT_flutter_local_snoise(vec2 v)\n{\n    vec2 i = floor(v + vec2(dot(v, vec2(0.3660254180431365966796875))));\n    vec2 x0 = (v - i) + vec2(dot(i, vec2(0.211324870586395263671875)));\n    bvec2 _99 = bvec2(x0.x > x0.y);\n    vec2 i1 = vec2(_99.x ? vec2(1.0, 0.0).x : vec2(0.0, 1.0).x, _99.y ? vec2(1.0, 0.0).y : vec2(0.0, 1.0).y);\n    vec4 x12 = x0.xyxy + vec4(0.211324870586395263671875, 0.211324870586395263671875, -0.57735025882720947265625, -0.57735025882720947265625);\n    vec4 _110 = x12;\n    vec2 _112 = _110.xy - i1;\n    x12.x = _112.x;\n    x12.y = _112.y;\n    vec2 param = i;\n    i = FLT_flutter_local_mod289(param);\n    vec3 param_1 = vec3(i.y) + vec3(0.0, i1.y, 1.0);\n    vec3 param_2 = (FLT_flutter_local_permute(param_1) + vec3(i.x)) + vec3(0.0, i1.x, 1.0);\n    vec3 p = FLT_flutter_local_permute(param_2);\n    vec3 m = max(vec3(0.5) - vec3(dot(x0, x0), dot(x12.xy, x12.xy), dot(x12.zw, x12.zw)), vec3(0.0));\n    m *= m;\n    m *= m;\n    vec3 x = (fract(p * vec3(0.024390242993831634521484375)) * 2.0) - vec3(1.0);\n    vec3 h = abs(x) - vec3(0.5);\n    vec3 ox = floor(x + vec3(0.5));\n    vec3 a0 = x - ox;\n    m *= (vec3(1.792842864990234375) - (((a0 * a0) + (h * h)) * 0.8537347316741943359375));\n    vec3 g;\n    g.x = (a0.x * x0.x) + (h.x * x0.y);\n    vec2 _227 = (a0.yz * x12.xz) + (h.yz * x12.yw);\n    g.y = _227.x;\n    g.z = _227.y;\n    return 130.0 * dot(m, g);\n}\n\nfloat FLT_flutter_local_staticV(vec2 uv)\n{\n    vec2 param = vec2(9.0, (iTime * 1.2000000476837158203125) + 3.0);\n    float staticHeight = (FLT_flutter_local_snoise(param) * 0.300000011920928955078125) + 5.0;\n    vec2 param_1 = vec2(1.0, (iTime * 1.2000000476837158203125) - 6.0);\n    float staticAmount = (FLT_flutter_local_snoise(param_1) * 0.100000001490116119384765625) + 0.300000011920928955078125;\n    vec2 param_2 = vec2(-9.75, (iTime * 0.60000002384185791015625) - 3.0);\n    float staticStrength = (FLT_flutter_local_snoise(param_2) * 2.0) + 2.0;\n    vec2 param_3 = vec2((5.0 * pow(iTime, 2.0)) + pow(uv.x * 7.0, 1.2000000476837158203125), pow((((mod(iTime, 100.0) + 100.0) * uv.y) * 0.300000011920928955078125) + 3.0, staticHeight));\n    return (1.0 - step(FLT_flutter_local_snoise(param_3), staticAmount)) * staticStrength;\n}\n\nvoid FLT_main()\n{\n    bottomStaticOpt = 1.0;\n    scalinesOpt = 1.0;\n    rgbOffsetOpt = 1.0;\n    horzFuzzOpt = 1.0;\n    vec2 uv_1 = flutter_FragCoord.xy / iResolution;\n    vec2 param_4 = vec2(iTime * 1.2999999523162841796875, 5.0);\n    float jerkOffset = (1.0 - step(FLT_flutter_local_snoise(param_4), 0.800000011920928955078125)) * 0.0500000007450580596923828125;\n    vec2 param_5 = vec2(iTime * 15.0, uv_1.y * 80.0);\n    float fuzzOffset = FLT_flutter_local_snoise(param_5) * 0.0030000000260770320892333984375;\n    vec2 param_6 = vec2(iTime * 1.0, uv_1.y * 25.0);\n    float largeFuzzOffset = FLT_flutter_local_snoise(param_6) * 0.0040000001899898052215576171875;\n    float y = uv_1.y;\n    float xOffset = (fuzzOffset + largeFuzzOffset) * horzFuzzOpt;\n    float staticVal = 0.0;\n    for (float y_1 = -1.0; y_1 <= 1.0; y_1 += 1.0)\n    {\n        float maxDist = 0.02500000037252902984619140625;\n        float dist = y_1 / 200.0;\n        vec2 param_7 = vec2(uv_1.x, uv_1.y + dist);\n        staticVal += ((FLT_flutter_local_staticV(param_7) * (maxDist - abs(dist))) * 1.5);\n    }\n    staticVal *= bottomStaticOpt;\n    float red = iChannel0.eval(iChannel0_size * ( vec2((uv_1.x + xOffset) - (0.00999999977648258209228515625 * rgbOffsetOpt), y))).x + staticVal;\n    float green = iChannel0.eval(iChannel0_size * ( vec2(uv_1.x + xOffset, y))).y + staticVal;\n    float blue = iChannel0.eval(iChannel0_size * ( vec2((uv_1.x + xOffset) + (0.00999999977648258209228515625 * rgbOffsetOpt), y))).z + staticVal;\n    vec3 color = vec3(red, green, blue);\n    float scanline = (sin(uv_1.y * 800.0) * 0.039999999105930328369140625) * scalinesOpt;\n    color -= vec3(scanline);\n    fragColor = vec4(color, 1.0);\n}\n\nhalf4 main(float2 iFragCoord)\n{\n      flutter_FragCoord = float4(iFragCoord, 0, 0);\n      FLT_main();\n      return fragColor;\n}\n",
    "stage": 1,
    "uniforms": [
      {
        "array_elements": 0,
        "bit_width": 32,
        "columns": 1,
        "location": 0,
        "name": "iResolution",
        "rows": 2,
        "type": 10
      },
      {
        "array_elements": 0,
        "bit_width": 32,
        "columns": 1,
        "location": 1,
        "name": "iTime",
        "rows": 1,
        "type": 10
      },
      {
        "array_elements": 0,
        "bit_width": 0,
        "columns": 1,
        "location": 2,
        "name": "iChannel0",
        "rows": 1,
        "type": 12
      }
    ]
  }
}