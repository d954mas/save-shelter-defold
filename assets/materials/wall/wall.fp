varying mediump vec4 var_position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D tex0;
uniform lowp vec4 tint;
uniform mediump vec4 light_color;

void main()
{
    vec4 color = texture2D(tex0, var_texcoord0.xy);
    gl_FragColor = vec4(color.rgb*light_color.rgb,1.0);
}

