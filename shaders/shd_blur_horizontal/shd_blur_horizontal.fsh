// @blokatt

#extension GL_OES_standard_derivatives : enable

#define RADIUS 75.0
#define PI 3.1415926535897932384626433832795
#define SIGMA (RADIUS / 3.)
#define TSQR_SIGMA (2. * SIGMA * SIGMA)
#define NOISE_LEVEL 0.1

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_glowProperties;
uniform float u_time;

// The compiler should optimise this.
float gauss(float v) {
	return (1.0 / sqrt(TSQR_SIGMA * PI)) * exp(-(v * v) / TSQR_SIGMA);   
}

// Doesn't have to be necessarily intensity, smoothstep wouldn't be a bad idea 
float luma(vec3 c){
	return 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b;
}

// Should be replaced with a texture.
float rand(vec2 n) { 
	n += fract(length(u_glowProperties) + u_time * .01);
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453) - .5;
}

void main()
{	
    vec2 offset = vec2(1. / 1280., 0.);   	
	vec4 blur = vec4(0);    
		
    for (float i = -RADIUS; i <= RADIUS; i += 1.) {  
		if (v_vTexcoord.x < 0. || v_vTexcoord.y < 0. || v_vTexcoord.x > 1. || v_vTexcoord.y > 1.) {
			continue;
		}
		vec3 tex = texture2D(gm_BaseTexture, v_vTexcoord + offset * i).rgb;
		vec2 gaussV = vec2(gauss(i), gauss(i * u_glowProperties.b));    	
		blur += vec4(vec3(tex.rgb * gaussV.x), luma(tex) * gaussV.y);	
    }

    gl_FragColor = vec4(blur.rgb * u_glowProperties.r, blur.a * u_glowProperties.g ) * (1. + NOISE_LEVEL * rand(gl_FragCoord.xy));	
}
