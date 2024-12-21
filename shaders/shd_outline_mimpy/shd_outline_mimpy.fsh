varying vec2 v_vTexcoord;
varying vec4 v_vColour;

const float TWOPI = 3.14159265 * 2.;
const float PRECISION = 32.;

const vec3 COLOR = vec3(0.839, 0., 0.486);

uniform vec2 texel_dimensions;
//uniform sampler2D surface_texture;
uniform float width;

void main()
{
    vec4 col = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    if (col.a == 0.) {
        col.rgb = COLOR;
        for (float i = 0.; i <= TWOPI; i = i + TWOPI / PRECISION) {
            vec2 dir = vec2(cos(i), sin(i));
            col.a += texture2D(gm_BaseTexture, v_vTexcoord + dir * texel_dimensions * width).a;
        }
    }
    
    gl_FragColor = col;
}


