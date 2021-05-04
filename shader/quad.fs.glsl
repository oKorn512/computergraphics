#version 330
  
layout(location = 0)  out vec4 out0; // output color 

in vec2 tc;

uniform sampler2D diffuse; // object color
uniform sampler2D normal;
uniform sampler2D position;
uniform sampler2D depth;

uniform vec3 lightDir;
uniform mat4 viewMatrix;
uniform int debug;

const float shinyness = 32.0;
const float specularStrength = 0.7;
const vec3 specColor = vec3(0.4, 0.4, 0.4);
const vec3 ambientLight = vec3(0);
const vec3 diffuseColor = vec3(1);

void main() 
{ 

	vec3 col = vec3(0,0,0);
	vec2 TC = tc;
	
	if (debug == 1) {
		gl_FragDepth = -0.5;


		if (TC.y > 0.5) {
			TC.y -= 0.5;
			if (TC.x < 0.5) col = texture2D(diffuse, TC*vec2(2,2)).rgb;
			else			col = texture2D(normal, (TC-vec2(0.5,0))*vec2(2,2)).rgb;
		}
		else {
			if (TC.x < 0.5) col = vec3(texture2D(depth, TC*vec2(2,2)).r);
			else			col = texture2D(position, (TC-vec2(0.5,0))*vec2(2,2)).rgb;
		}
	} else {
		// TODO A1 (a)
		// Note that, the approximation of Phong lighting using the halfway vector (which is used by the reference)
		// yields slightly different results than regular Phong lighting
		
		vec3 light2 = (viewMatrix * vec4(lightDir, 0)).rgb;
		float diff = max(dot(texture2D(normal, TC).rgb ,-light2), 0.0);
		
		//float diff = max(dot(texture2D(normal, TC).rgb ,-lightDir), 0.0);
		vec3 diffuseLight =  diffuseColor * diff;
		
		vec3 viewDir = normalize(-texture2D(position, TC).rgb); //why? viewspace cameraPosition
		vec3 reflectDir = reflect(lightDir,texture2D(normal,TC).rgb);
		float spec = pow(max(dot(viewDir, reflectDir), 0.0), shinyness);
		vec3 specularLight = specularStrength * spec * specColor;
		col = (ambientLight + diffuseLight + specularLight) * texture2D(diffuse, TC).rgb ;
		gl_FragDepth = texture2D(depth, TC).r;
	}

	out0 = vec4(col, 1);
}
