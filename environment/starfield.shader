shader_type canvas_item;

uniform vec2 position;

const float TEXTURE_SIZE = 1028.0;
//const float DIVISOR = 500.0;


void fragment(){
	vec2 shifted_uv_front = UV;
	shifted_uv_front.x += (position.x * TEXTURE_PIXEL_SIZE.x);
	shifted_uv_front.y += (position.y * TEXTURE_PIXEL_SIZE.y);

	// Fake FMOD
	shifted_uv_front.x = sign(shifted_uv_front.x) * (abs(shifted_uv_front.x) - TEXTURE_SIZE * floor(abs(shifted_uv_front.x) / TEXTURE_SIZE));
	shifted_uv_front.y = sign(shifted_uv_front.y) * (abs(shifted_uv_front.y) - TEXTURE_SIZE * floor(abs(shifted_uv_front.y) / TEXTURE_SIZE));

	vec2 shifted_uv_back = UV;
	shifted_uv_back.x += (position.x * TEXTURE_PIXEL_SIZE.x / 2.0);
	shifted_uv_back.y += (position.y * TEXTURE_PIXEL_SIZE.y / 2.0);
	
	// shifted_uv_back = shifted_uv_back / 2.0;

	// Fake FMOD
	shifted_uv_back.x = sign(shifted_uv_back.x) * (abs(shifted_uv_back.x) - TEXTURE_SIZE * floor(abs(shifted_uv_back.x) / TEXTURE_SIZE));
	shifted_uv_back.y = sign(shifted_uv_back.y) * (abs(shifted_uv_back.y) - TEXTURE_SIZE * floor(abs(shifted_uv_back.y) / TEXTURE_SIZE));
	

	COLOR = texture(TEXTURE, shifted_uv_front) + texture(TEXTURE, shifted_uv_back);
}
