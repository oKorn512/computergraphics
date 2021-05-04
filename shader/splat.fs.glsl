#version 330
  
layout(location = 0)  out vec4 out0; // color 

in vec4 v_center;

uniform uvec2 resolution;

uniform sampler2D diffuse;
uniform sampler2D normal;
uniform sampler2D position;

uniform float radius;
uniform vec3 splatColor;
uniform vec3 attenuation_params;
uniform float light_intensity;

vec3 shadeColor;

void main() 
{ 
	vec2 tc = gl_FragCoord.xy / resolution;
	vec4 fragPosition = texture2D(position, tc);
	vec4 distanceFromLight = fragPosition - v_center / v_center.w;
	vec3 col;
	if(length(distanceFromLight) <= radius){
		float normalizedDistance = length(distanceFromLight) / radius;
		float attenuation = 1 / (attenuation_params.x + (attenuation_params.y * normalizedDistance) + (attenuation_params.z * normalizedDistance * normalizedDistance)) 
				- 1 / (attenuation_params.x + attenuation_params.y + attenuation_params.z);
		float diff = max(dot(texture2D(normal, tc).rgb , -distanceFromLight.rgb), 0.0);
		vec3 diffuseLight = splatColor * diff * light_intensity * attenuation;
		col = diffuseLight * texture2D(diffuse, tc).rgb ;
	}
	else{
		discard;
	}
	
	out0 = vec4(col, 1.0);
























}
