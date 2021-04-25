shader_type canvas_item;

uniform vec2 position;

const float TEXTURE_SIZE = 1028.0;

const int LAYERS = 5;
const float DEPTH_FACTOR = 0.7;
const float DEPTH_OFFSET = 0.0;

void fragment(){
	COLOR = vec4(0,0,0,0);
	vec2 shifted_uv_front = UV;
	for (int i = 1; i <= LAYERS; i ++){
		
		// Offset stars by player position
		vec2 shifted_uv = UV;
		shifted_uv.x += (
			position.x / (DEPTH_OFFSET + float(i) / DEPTH_FACTOR) * TEXTURE_PIXEL_SIZE.x
		);
		shifted_uv.y += (
			position.y / (DEPTH_OFFSET + float(i) / DEPTH_FACTOR) * TEXTURE_PIXEL_SIZE.y
		);

		// Extra offset to avoid stacking
		shifted_uv += (TEXTURE_PIXEL_SIZE * float(i) * 250.0);

		// Fake FMOD
		shifted_uv.x = sign(shifted_uv.x) * (
			abs(shifted_uv.x) - TEXTURE_SIZE * floor(abs(shifted_uv.x) / TEXTURE_SIZE)
		);
		shifted_uv.y = sign(shifted_uv.y) * (
			abs(shifted_uv.y) - TEXTURE_SIZE * floor(abs(shifted_uv.y) / TEXTURE_SIZE)
		);
		
		// Invert every other layer
		if(bool(i % 2)){
			shifted_uv.x = 1.0 - shifted_uv.x;
			shifted_uv.y = 1.0 - shifted_uv.y;
		}
		COLOR += texture(TEXTURE, shifted_uv) / (float(i) + 0.5)
	}
}
